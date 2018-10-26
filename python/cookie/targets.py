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

		def board(self):
			return str(self._infos['board'])

		def volume(self):
			return str(self._infos['volume'])

		def created_on(self):
			return str(self._infos['created_on'])

		def arch(self):
			return cookie.profiles.get(self.name(), self.board()).arch()

		def packages(self):
			try:
				path = '%s/installed/packages.json' % self._path
				raw  = json.load(open(path))
				return [ '%s-%s' % (str(k), str(v['version'])) for k, v in raw.items() ]
			except Exception, e:
				return []

		def version(self, name):
			try:
				path = '%s/installed/packages.json' % self._path
				raw  = json.load(open(path))
				return raw[name]['version']
			except Exception, e:
				return None

		def add(self, selector):
			cookie.logger.info('adding %s to the target' % selector)
			pkg = cookie.packages.elect(selector)
			pkg.attach(self.name())
			if self.version(pkg.name()):
				cookie.logger.abort('package %s is already installed' % pkg.name())
			if pkg.has_binpkg():
				cookie.logger.debug('requested package is already build, reusing')
				pkg.clean()
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
			version = self.version(name)
			if version is not None:
				pkg = cookie.packages.get(name, version)
				pkg.attach(self.name())
				pkg.unmerge()
			else:
				raise Exception('package %s is not installed' % name)

		def merge(self):

			# Build list of actions
			tpkg   = self.packages()
			ppkg   = cookie.profiles.get(self.profile(), self.board()).packages()
			remove = [ x for x in tpkg if x not in ppkg ]
			keep   = [ x for x in tpkg if x in ppkg ]
			add    = [ x for x in ppkg if x not in tpkg ]

			# Some kept package might have been modified, check here
			for p in keep:
				pkg = cookie.packages.elect(p)
				pkg.attach(self.name())
				if not pkg.has_binpkg():
					remove.append(p)
					add.append(p)
					keep.remove(p)

			# Summarize actions
			cookie.logger.info('The following packages can be kept:')
			for p in keep: cookie.logger.debug(p)
			cookie.logger.info('The following packages need to be removed:')
			for p in remove: cookie.logger.debug(p)
			cookie.logger.info('The following packages need to be installed:')
			for p in add: cookie.logger.debug(p)

			# Ask for confirmation
			answer = ''
			while answer not in ["y", "n"]:
				answer = raw_input("Proceed with merge [y/n]? ").lower()

			# Abort
			if answer == 'n':
				cookie.logger.abort('merge canceled')

			# Remove packages
			for p in remove:
				cookie.logger.info('removing package %s' % p)
				pkg = cookie.packages.elect(p)
				pkg.attach(self.name())
				pkg.unmerge()

			# Order package to add by dependencies
			obj  = [ cookie.packages.elect(x) for x in add ]
			ins  = [ cookie.packages.elect(x) for x in keep ]
			ord  = [ x for x in obj if x.depends() == [] ]
			rem  = [ x for x in obj if x not in ord ]
			while len(rem) > 0:
				count = len(rem)
				for r in rem:
					ready = True
					for d in r.depends():
						if	not [ x for x in ord if d == x.name() or d in x.provides() ] and not [ x for x in ins if d == x.name() or d in x.provides() ]:
							ready = False
							break
					if ready:
						ord.append(r)
						rem.remove(r)
				if count == len(rem):
					cookie.logger.abort('unable to satisfy dependencies for %s' % str(['%s: %s' % (x.name(), str(x.depends())) for x in rem]))

			# Add packages
			for pkg in ord:
				cookie.logger.info('adding package %s' % pkg.selector())
				self.add(pkg.selector())

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
	def create(self, pname, pboard, name = None):
		now  = str(datetime.date.today())
		name = '%s-%s' % (pname, now) if name == None else name
		cookie.logger.info('creating target %s' % name)
		if name in self.list():
			raise Exception('target %s already exists' % name)
		elif pname not in cookie.profiles.list():
			raise Exception('unknown profile %s' % pname)
		elif pboard not in cookie.profiles.boards(pname):
			raise Exception('unknown board %s for profile %s', (pboard, pname))
		else:

			cookie.logger.debug('creating target volume')
			(s, volume, e) = cookie.shell(quiet = True).run('docker volume create')

			cookie.logger.debug('adding target mapping')
			mapping_file = '%s/mapping.json' % cookie.layout.cache()
			mapping = json.load(open(mapping_file)) if os.path.isfile(mapping_file) else { 'targets':{} }
			mapping['current'] = name
			mapping['targets'][name] = {
				'created_on'	: now,
				'profile'		: pname,
				'board'			: pboard,
				'volume'		: volume[0]
			}
			json.dump(mapping, open(mapping_file, 'w'))

			try:
				profile      = cookie.profiles.get(pname, pboard)
				profile_sha1 = cookie.sha1.compute('%s/crosstool-ng.config' % profile.path())
				built_sha1	 = file('%s/toolchains/%s.sha1' % (cookie.layout.cache(), pname)).read().strip()
				if profile_sha1 == built_sha1:
					cookie.logger.debug('reusing packaged toolchain')
					cookie.docker.run('tar xJf /opt/cookie/cache/toolchains/%s.tar.xz -C /opt/target' % pname)
				else:
					cookie.logger.debug('compiling the profile toolchain')
					raise Exception('target toolchain compilation not implemented')
					#cookie.sha1.save('%s/crosstool-ng.config' % profile.path(), '%s/toolchains/%s.sha1' % (cookie.layout.cache(), profile))
			except Exception, e:
				self.destroy(name)
				raise e
