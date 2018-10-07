import os
import shutil
import datetime
import distutils
import cookie

class targets():

	class target:

		def __init__(self, name):
			self._name     = name
			self._path     = cookie.layout.target(name)
			self._build    = '%s/build' % (self._path)
			self._debian   = '%s/debian' % (self._path)
			self._rootfs   = '%s/rootfs' % (self._path)
			self._manifest = '%s/Manifest' % self._path
			if not os.path.isdir(self._path):
				raise Exception('unknown target %s' % name)
			if self._name == 'current':
				raise Exception('current is not a valid target name')

		def name(self):
			return self._name

		def manifest(self):
			return { line.split('=')[0].strip(): line[line.find('=')+1:].strip() for line in tuple(open(self._manifest,  'r')) if line[0] != '#' and line.find('=') != -1}

		def profile(self):
			return self.manifest()['profile']

		def package(self, selector):
			try:
				pkg = cookie.packages.elect(selector)
				pkg.attach(self.name())
				return pkg
			except Exception, e:
				raise Exception('no package found for selector "%s": %s' % (selector, str(e)))

		def add(self, selector):
			cookie.logger.info('adding package to the target')
			pkg = self.package(selector)
			if pkg.has_binpkg():
				cookie.logger.debug('package was already built with the same options, reusing')
			else:
				pkg.clean()
				pkg.check()
				pkg.fetch()
				pkg.setup()
				pkg.compile()
				pkg.install()
				pkg.mkdeb()
			pkg.merge()

		def remove(self, name):
			# TODO: HERE WE WANT AN INSTALLED PACKAGE ONLY, WE NEED TO GET THE SELECTOR OTHERWISE...
			# TODO: HERE WE HAVE A NAME, NOT A SELECTOR ...
			cookie.logger.info('removing package from the target')
			pkg = self.package(name)
			pkg.unmerge()

		def merge(self):

			# TODO: FIND PACKAGE INSTALLED BUT NOT REQUIRED ...

			# Setup List of package
			prf  = cookie.profiles.get(self.profile())
			pkgl = [ cookie.packages.elect(x) for x in prf.packages() ] # LIST OF PACKAGES
			ord  = [ x for x in pkgl if x.depends() == [] ]
			rem  = [ x for x in pkgl if x not in ord ]
			# Add in order of needed dependencies
			while len(rem) > 0:
				count = len(rem)
				names = [ n.name() for n in ord ]
				for r in rem:
					ready = True
					for d in r.depends():
						if not d in names:
							ready = False
					if ready:
						ord.append(r)
						rem.remove(r)
				if count == len(rem):
					cookie.logger.abort('unable to satisfy dependencies for one or more packages')
			# List of operations
			for pkg in ord:
				pkg.attach(self.name())
				iv = pkg.installed_version()
				if iv == None:
					cookie.logger.debug('[ADD] %s-%s' % (pkg.name(), pkg.version()))
				elif iv != pkg.version():
					cookie.logger.debug('[UPD] %s-%s > %s' % (pkg.name(), iv, pkg.version()))
				elif False:
					cookie.logger.debug('[DEL] %s-%s' % (pkg.name(), pkg.version()))
				else:
					cookie.logger.debug('[IGN] %s-%s' % (pkg.name(), pkg.version()))
			# Confirm
			answer = ''
			while answer not in ["y", "n"]:
				answer = raw_input("Proceed with merge [y/n]? ").lower()
			if answer == 'y':
				for pkg in ord:
					iv = pkg.installed_version()
					if iv == None:
						self.add(pkg.selector())
					elif iv != pkg.version():
						self.remove(pkg.name())
						self.add(pkg.selector())
					elif False:
						self.remove(pkg.name)
					else:
						pass

	@classmethod
	def list(self):
		path = cookie.layout.targets()
		if os.path.isdir(path):
			return [p for p in os.listdir(path) if os.path.isdir(os.path.join(path, p)) and p != 'current']
		else:
			raise Exception('no target directory found')

	@classmethod
	def current(self):
		try:
			path = cookie.layout.targets()
			return os.readlink('%s/current' % path).split('/')[-1]
		except Exception, e:
			return None

	@classmethod
	def get(self, name):
		return self.target(name)

	@classmethod
	def delete(self, name):
		if name not in self.list():
			raise Exception('unknown target %s' % name)
		else:
			path = cookie.layout.targets()
			shutil.rmtree('%s/%s' % (path, name))
			self.select(None if len(self.list()) == 0 else self.list()[0])

	@classmethod
	def select(self, name):
		path = cookie.layout.targets()
		if name is None:
			os.remove('%s/current' % path)
		elif name not in self.list():
			raise Exception('unknown target %s' % name)
		else:
			if os.path.islink('%s/current' % path):
				os.remove('%s/current' % path)
			os.symlink('%s/%s' % (path, name), '%s/current' % path)

	@classmethod
	def create(self, profile, name):
		today = datetime.date.today()
		name = profile if name == None else name
		path = '%s/targets/%s' % (os.getenv('COOKIE'), name)
		if os.path.isdir(path):
			raise Exception('target already exists')
		elif not os.path.isdir(cookie.layout.profile(profile)):
			raise Exception('unknown profile %s' % profile)
		else:
			os.makedirs(path)
			try:
				with open('%s/Manifest' % path, 'w') as handle:
					print >> handle, 'profile=%s' % profile
					print >> handle, 'createdon=%s' % today
					handle.close()
				self.select(name)
			except Exception, e:
				shutil.rmtree(path)
				raise e
