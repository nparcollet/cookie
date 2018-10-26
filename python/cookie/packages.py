import os
import shutil
import cookie
import re
import distutils.version
import hashlib
import json

class packages:

	class package:

		def __init__(self, name, version):
			self._name			= name
			self._version		= version
			self._makefile		= '%s/%s-%s.mk' % (cookie.layout.packages(), name, version)
			self._meta			= { re.split('[:?]?=', line)[0][2:].strip(): line.split('=')[1].strip() for line in tuple(open(self.makefile(), 'r')) if line[0:2] == 'P_' }
			self._description	= self._meta['DESCRIPTION'].strip() 					if 'DESCRIPTION' in self._meta else ''
			self._depends		= [ o.strip() for o in self._meta['DEPENDS'].split() ]  if 'DEPENDS'     in self._meta else []
			self._licences		= [ o.strip() for o in self._meta['LICENCES'].split() ] if 'LICENCES'    in self._meta else []
			self._archs			= [ o.strip() for o in self._meta['ARCHS'].split() ]    if 'ARCHS'       in self._meta else []
			self._provides      = [ o.strip() for o in self._meta['PROVIDES'].split() ] if 'PROVIDES'    in self._meta else []
			self._target		= None
			self._profile		= None
			self._env			= { 'ARCH':'amd64' }

		def selector(self):
			return '%s-%s' % (self.name(), self.version())

		def attach(self, name):
			self._target	= cookie.targets.get(name)
			self._profile	= cookie.profiles.get(self._target.profile(), self._target.board())
			self._env		= self._profile.buildenv()
			self._arch		= self._profile.arch()

		def provides(self):
			return self._provides

		def depends(self):
			return self._depends

		def name(self):
			return self._name

		def version(self):
			return self._version

		def description(self):
			return self._description

		def archs(self):
			return self._archs

		def licences(self):
			return self._licences

		def makefile(self):
			return self._makefile

		def arch(self):
			return self._arch

		def rootfs(self):
			path = '/opt/target/rootfs'
			if not os.path.isdir(path):
				cookie.logger.debug('creating missing rootfs directory')
				os.makedirs(path)
			return path

		def archives(self):
			path = '/opt/target/archives'
			if not os.path.isdir(path):
				cookie.logger.debug('creating missing archives directory')
				os.makedirs(path)
			return path

		def installed(self):
			path = '/opt/target/installed'
			if not os.path.isdir(path):
				cookie.logger.debug('creating missing installed directory')
				os.makedirs(path)
			return path

		def workdir(self):
			path = '/opt/target/build/%s-%s' % (self.name(), self.version())
			if not os.path.isdir(path):
				os.makedirs(path)
			return path

		def destdir(self):
			return '%s/staging' % self.workdir()

		def make(self, rule):
			cookie.logger.info('running %s on package' % rule)
			if self._arch not in self.archs():
				raise Exception('package %s does not support %s architecture' % (self.name(), self._arch))
			else:
				if not os.path.isdir(self.workdir()): os.makedirs(self.workdir())
				srcdir = '%s/%s' % (self.workdir(), self._meta['SRCDIR']) if 'SRCDIR' in self._meta else '%s/srcdir' % self.workdir()
				s = cookie.shell()
				s.loadenv()
				s.addenv(self._env)
				s.setenv('P_WORKDIR', self.workdir())
				s.setenv('P_DESTDIR', self.destdir())
				s.setenv('P_SYSROOT', self.rootfs())
				s.setenv('P_NPROCS',  '4') # TODO: Get this programmatically ...
				s.run('make -C %s -f %s %s' % (srcdir if os.path.isdir(srcdir) else self.workdir(), self.makefile(), rule))

		def clean(self):
			cookie.logger.info('cleaning package workdir')
			if os.path.isdir(self.workdir()):
				cookie.logger.debug('removing old build directory %s' % self.workdir())
				shutil.rmtree(self.workdir())
			else:
				cookie.logger.debug('work does not need to be cleaned')

		def check(self):
			cookie.logger.info('checking package')
			if self._arch not in self._archs:
				raise Exception('architecture %s is not supported by package' % self._arch)
			else:
				cookie.logger.debug('all check passed')

		def fetch(self):
			self.make('fetch')

		def setup(self):
			self.make('setup')

		def compile(self):
			self.make('compile')

		def install(self):
			self.make('install')

		def has_binpkg(self):
			try:
				sha1file      = '%s/%s-%s.sha1' % (self.archives(), self.name(), self.version())
				built_sha1	  = file(sha1file).read().strip()
				makefile_sha1 = cookie.sha1.compute(self.makefile())
				return True if built_sha1 == makefile_sha1 else False
			except Exception, e:
				return False

		def merge(self):
			cookie.logger.info('merging content in rootfs')
			archive = '%s/%s-%s.tar.xz' % (self.archives(), self.name(), self.version())
			(status, entries, errors) = cookie.shell(quiet = True).run('tar -tf %s' % archive)
			conflicts = [ e[2:] for e in entries if os.path.isfile('%s/%s' % (self.rootfs(), e[2:])) or os.path.islink('%s/%s' % (self.rootfs(), e[2:])) ]
			if not os.path.isdir(self.rootfs()):
				os.makedirs(self.rootfs())
			elif conflicts:
				cookie.logger.abort('conflicts detected: %s' % str(conflicts))
			else:
				cookie.shell().run('cd %s && tar xJf %s/%s-%s.tar.xz' % (self.rootfs(), self.archives(), self.name(), self.version()))
				open('%s/%s.list' % (self.installed(), self.name()), 'w').write('\n'.join([ x[1:] for x in reversed(entries) ]))
				try :
					path = '%s/packages.json' % self.installed()
					meta = json.load(open(path)) if os.path.isfile(path) else {}
				except Exception, e:
					meta = {}
				meta[self.name()] = { 'version': self.version() }
				json.dump(meta, open('%s/packages.json' % self.installed(), 'w'))

		def mkarchive(self):
			archive = '%s-%s.tar.xz' % (self.name(), self.version())
			cookie.logger.info('creating archive %s' % archive)
			if not os.path.isdir(self.archives()): os.makedirs(self.archives())
			cookie.shell().run('tar cJf %s/%s -C %s .' % (self.archives(), archive, self.destdir()))
			with open('%s/%s-%s.sha1' % (self.archives(), self.name(), self.version()), 'w') as handle:
				print >> handle, cookie.sha1.compute(self.makefile())
				handle.close()

		def unmerge(self):
			path = '%s/%s.list' % (self.installed(), self.name())
			meta = json.load(open('%s/packages.json' % self.installed()))
			if not os.path.isfile(path): # or self.name() not in meta:
				raise Exception('package %s is not installed' % self.name())
			else:
				for f in open(path).read().split():
					fpath = '%s%s' % (self.rootfs(), f)
					if os.path.islink(fpath) or os.path.isfile(fpath):
						os.unlink(fpath)
					elif os.path.isdir(fpath) and f != '/' and not os.listdir(fpath):
						os.rmdir(fpath)
					else:
						cookie.logger.debug('[I] Ignored entry %s' % fpath)
				del meta[self.name()]
				json.dump(meta, open('%s/packages.json' % self.installed(), 'w'))
				os.unlink(path)

	@classmethod
	def exists(self, name, version):
		return os.path.isfile('%s/%s-%s.mk' % (cookie.layout.packages(), name, version))

	@classmethod
	def parse(self, selector):
		pnv		= selector
		name	= pnv	if pnv.rfind('-') == -1 or not pnv[pnv.rfind('-')+1].isdigit() else '-'.join(pnv.split('-')[0:-1])
		version	= None	if pnv == name else pnv[len(name)+1:]
		return (name, version)

	@classmethod
	def candidates(self, selector):
		(name, version) = self.parse(selector)
		candidates = []
		if version is not None and self.exists(name, version):
			candidates.append((name, version))
		else:
			all  = os.listdir(cookie.layout.packages())
			for a in all:
				candidate = self.parse(a.split('.mk')[0])
				if candidate[0] == name:
					candidates.append((candidate[0], candidate[1]))
		return candidates

	@classmethod
	def elect(self, selector):
		candidates = self.candidates(selector)
		if len(candidates) == 0:
			raise Exception('no matching package for selector %s' % selector)
		else:
			en, ev = candidates[0]
			for n, v in candidates:
				if distutils.version.LooseVersion(ev) < distutils.version.LooseVersion(v):
					ev = v
			return cookie.packages.package(en, ev)

	@classmethod
	def get(self, name, version):
		return self.elect('%s-%s' % (name, version))
