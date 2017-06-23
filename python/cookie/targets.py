import os
import shutil
import datetime
import distutils
import cookie

class targets():

	class target:

		def __init__(self, name):
			self._name     = name
			self._path     = '%s/%s' % (cookie.targets.path, name)
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
				return cookie.package(selector, self.name())
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

		def remove(self, selector):
			cookie.logger.info('removing package from the target')
			pkg = self.package(selector)
			pkg.unmerge()

		def merge(self):
			# PERFORM THE OPERATION OF BUILINDG / INSTALLING ALL TARGET PROFILE PACKAGES
			pass

	path = '%s/targets' % os.getenv('COOKIE')

	@classmethod
	def list(self):
		if os.path.isdir(self.path):
			return [p for p in os.listdir(self.path) if os.path.isdir(os.path.join(self.path, p)) and p != 'current']
		else:
			raise Exception('no target directory found')

	@classmethod
	def current(self):
		try:
			return os.readlink('%s/current' % self.path).split('/')[-1]
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
			shutil.rmtree('%s/%s' % (self.path, name))
			self.select(None if len(self.list()) == 0 else self.list()[0])

	@classmethod
	def select(self, name):
		if name is None:
			os.remove('%s/current' % self.path)
		elif name not in self.list():
			raise Exception('unknown target %s' % name)
		else:
			if os.path.islink('%s/current' % self.path):
				os.remove('%s/current' % self.path)
			os.symlink('%s/%s' % (self.path, name), '%s/current' % self.path)

	@classmethod
	def create(self, profile, name):
		today = datetime.date.today()
		name = profile if name == None else name
		path = '%s/%s' % (self.path, name)
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

	"""
	def merge(self):
		# Create a list of packages in order of dependencies
		ord = [ x for x in self._packages.keys() if self._packages[x].depends() == [] ]
		rem = [ x for x in self._packages.keys() if x not in ord ]
		while len(rem) > 0:
			for r in rem:
				ready = True
				for d in self._packages[r].depends():
					if not d in ord: ready = False
				if not ready: continue
				ord.append(r)
				rem.remove(r)
		# Remove the one that are up to date
		for p in ord:
			pkg = self._packages[p]
			action, reason = pkg.diff()
			print '[%s] %s: %s' % (action, p, reason)
			if action == 'R':
				pkg.unmerge()
			elif action == 'I':
				pkg.merge()
			elif action == 'U':
				pkg.unmerge()
				pkg.merge()
	"""
