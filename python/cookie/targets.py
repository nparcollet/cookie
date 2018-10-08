import os
import shutil
import datetime
import distutils
import json
import cookie

class targets():

	class target:

		def __init__(self, name):
			self._name  = name
			self._path  = '/opt/target'
			self._infos = json.load(open('%s/mapping.json' % cookie.layout.cache()))['targets'][name]

		def name(self):
			return self._name

		def path(self):
			return self._path

		def profile(self):
			return str(self._infos['profile'])

		def volume(self):
			return str(self._infos['volume'])

		def created_on(self):
			return str(self._infos['created_on'])

		def arch(self):
			return cookie.profiles.get(self.profile()).arch()

		def packages(self):
			try:
				path = '%s/installed/packages.json' % self._path
				raw  = json.load(open(path))
				return [ '%s/%s-%s' % (v['overlay'], k, v['version']) for k, v in raw.items() ]
			except Exception, e:
				print e
				return []

		def version(self, name):
			try:
				path = '%s/installed/packages.json' % self._path
				raw  = json.load(open(path))
				return raw[name]['version']
			except Exception, e:
				return None

		def overlay(self, name):
			try:
				path = '%s/installed/packages.json' % self._path
				raw  = json.load(open(path))
				return raw[name]['overlay']
			except Exception, e:
				return None

		def add(self, selector):
			cookie.logger.info('adding %s to the target' % selector)
			pkg = cookie.packages.elect(selector)
			pkg.attach(self.name())
			if self.version(pkg.name()) or self.overlay(pkg.name()):
				cookie.logger.abort('package %s is already installed' % pkg.name())
			if pkg.has_binpkg():
				cookie.logger.debug('requested package is already build, reusing')
			else:
				pkg.clean()
				pkg.check()
				pkg.fetch()
				pkg.setup()
				pkg.compile()
				pkg.install()
				pkg.mkarchive()
			pkg.merge()

		def remove(self, name):
			cookie.logger.info('removing package %s from the target' % name)
			overlay = self.overlay(name)
			version = self.version(name)
			if overlay is not None and version is not None:
				pkg = cookie.packages.get(overlay, name, version)
				pkg.attach(self.name())
				pkg.unmerge()
			else:
				raise Exception('package %s is not installed' % name)

		def merge(self):

			installed = self.packages()


			pass
			"""
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
		"""

	@classmethod
	def list(self):
		try:
			mapping = json.load(open('%s/mapping.json' % cookie.layout.cache()))
			return [ str(x) for x in mapping["targets"].keys() ]
		except Exception, e:
			return []

	@classmethod
	def current(self):
		try:
			mapping = json.load(open('%s/mapping.json' % cookie.layout.cache()))
			return str(mapping["current"])
		except Exception, e:
			return None

	@classmethod
	def get(self, name):
		return self.target(name) if name in self.list() else None

	@classmethod
	def select(self, name):
		names = self.list()
		if name not in names:
			cookie.logger.abort('unknown target %s' % name)
		elif name == self.current():
			cookie.logger.abort('target %s already selected' % name)
		else:
			mapping = json.load(open('%s/mapping.json' % cookie.layout.cache()))
			mapping['current'] = name
			json.dump(mapping, open('%s/mapping.json' % cookie.layout.cache(), 'w'))

	@classmethod
	def destroy(self, name):

		current = self.current()
		if name not in self.list():
			cookie.logger.abort('unknown target %s' % name)
		else:
			mapping = json.load(open('%s/mapping.json' % cookie.layout.cache()))
			cookie.shell().run('docker volume rm %s' % mapping['targets'][name]['volume'])
			del mapping['targets'][name]
			if name == current:
				remain = [ str(x) for x in mapping['targets'].keys() ]
				mapping['current'] = None if len(remain) == 0 else remain[0]
			json.dump(mapping, open('%s/mapping.json' % cookie.layout.cache(), 'w'))

	@classmethod
	def create(self, profile, name = None):
		now  = str(datetime.date.today())
		name = profile + '-' + now if name == None else name
		if name in self.list():
			raise Exception('target %s already exists' % name)
		elif not os.path.isdir(cookie.layout.profile(profile)):
			raise Exception('unknown profile %s' % profile)
		else:
			(s, volume, e) = cookie.shell(quiet = True).run('docker volume create')
			mapping = json.load(open('%s/mapping.json' % cookie.layout.cache()))
			mapping['targets'][name] = {
				'created_on'	: now,
				'profile'		: profile,
				'volume'		: volume[0]
			}
			mapping['current'] = name
			json.dump(mapping, open('%s/mapping.json' % cookie.layout.cache(), 'w'))
