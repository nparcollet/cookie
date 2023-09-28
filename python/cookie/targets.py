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

		def packages(self):
			try:
				path = '%s/installed/packages.json' % self._path
				raw  = json.load(open(path))
				return [ '%s-%s' % (str(k), str(v['version'])) for k, v in raw.items() ]
			except Exception as e:
				return []

		def version(self, name):
			try:
				path = '%s/installed/packages.json' % self._path
				raw  = json.load(open(path))
				return raw[name]['version']
			except Exception as e:
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
				pkg.patch()
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

		def mkimage(self):
			prf = cookie.profiles.get(self.profile(), self.board())
			cookie.shell().run('mkimage %s %s' % (prf.image('size'), prf.image('boot')))

	@classmethod
	def list(self):
		try:
			mapping = json.load(open('%s/mapping.json' % cookie.layout.cache()))
			return [ str(x) for x in mapping["targets"].keys() ]
		except Exception as e:
			return []

	@classmethod
	def current(self):
		try:
			mapping = json.load(open('%s/mapping.json' % cookie.layout.cache()))
			return str(mapping["current"])
		except Exception as e:
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
				'volume'		: volume[0].decode()
			}
			json.dump(mapping, open(mapping_file, 'w'))

			try:
				profile     = cookie.profiles.get(pname, pboard)
				source_file = '%s/%s.config' % (cookie.layout.toolchains(), profile.toolchain())
				source_sha1 = cookie.sha1.compute(source_file)
				target_path = '%s/toolchains' % cookie.layout.cache()
				target_file = '%s/%s.sha1' % (target_path, profile.toolchain())
				target_sha1	= cookie.sha1.load(target_file);
				cookie.logger.debug('toolchain cache directory is %s' % target_path)
				cookie.logger.debug('profile toolchain sha1 is: %s' % source_sha1)
				cookie.logger.debug('prebuilt toolchain sha1 is: %s' % target_sha1)
				if not os.path.isdir(target_path):
					cookie.logger.debug('creating missing cache directory')
					os.makedirs(target_path)
				if source_sha1 == target_sha1:
					cookie.logger.debug('reusing packaged toolchain')
					cookie.docker.run('tar -C /opt/target -xJf /opt/cookie/cache/toolchains/%s.tar.xz' % profile.toolchain())
				else:
					cookie.logger.debug('compiling the profile toolchain')
					cookie.docker.run('cp /opt/cookie/toolchains/%s.config /opt/target/.config' % profile.toolchain())
					cookie.docker.run('ct-ng -C /opt/target build')
					cookie.docker.run('tar -C /opt/target -cJf /opt/cookie/cache/toolchains/%s.tar.xz toolchain' % profile.toolchain())
					cookie.docker.run('rm -rf /opt/target/.build /opt/target/build.log /opt/target/.config')
					cookie.sha1.save(source_sha1, target_file)
			except Exception as e:
				self.destroy(name)
				raise e
