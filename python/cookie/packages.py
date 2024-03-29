import os
import shutil
import cookie
import re
import distutils.version
import hashlib
import json

class packages:

	class package:

		def __init__(self, overlay, name, version):
			self._name			= name
			self._version		= version
			self._overlay 		= overlay
			self._makefile		= '%s/%s/%s-%s.mk' % (cookie.layout.packages(), overlay, name, version)
			self._meta			= { re.split('[:?]?=', line)[0][2:].strip(): line.split('=')[1].strip() for line in tuple(open(self.makefile(), 'r')) if line[0:2] == 'P_' }
			self._description	= self._meta['DESCRIPTION'].strip() 					if 'DESCRIPTION' in self._meta else ''
			self._depends		= [ o.strip() for o in self._meta['DEPENDS'].split() ]  if 'DEPENDS'     in self._meta else []
			self._licences		= [ o.strip() for o in self._meta['LICENCES'].split() ] if 'LICENCES'    in self._meta else []
			self._archs			= [ o.strip() for o in self._meta['ARCHS'].split() ]    if 'ARCHS'       in self._meta else []
			self._options		= [ o.strip() for o in self._meta['OPTIONS'].split() ]  if 'OPTIONS'     in self._meta else []
			self._files			= [ o.strip() for o in self._meta['FILES'].split() ] 	if 'FILES'     	 in self._meta else []
			self._provides      = [ o.strip() for o in self._meta['PROVIDES'].split() ] if 'PROVIDES'    in self._meta else []
			self._target		= None
			self._profile		= None

			#if self._name not in [ 'kernel', 'sysroot']:
			#	if 'kernel' not in self._depends: self._depends.append('kernel')
			#	if 'sysroot' not in self._depends: self._depends.append('sysroot')

		def selector(self):
			return '%s/%s-%s' % (self.overlay(), self.name(), self.version())

		def attach(self, name):
			self._target	= cookie.targets.get(name)
			self._profile	= cookie.profiles.get(self._target.profile(), self._target.board())
			self._arch		= self._profile.arch()

		def provides(self):
			return self._provides if len(self._provides) > 0 else [ self._name ]

		def depends(self):
			return self._depends

		def name(self):
			return self._name

		def version(self):
			return self._version

		def overlay(self):
			return self._overlay

		def description(self):
			return self._description

		def archs(self):
			return self._archs

		def extra_env(self):
			return self.extra_env

		def licences(self):
			return self._licences

		def makefile(self):
			return self._makefile

		def arch(self):
			return self._arch

		def options(self):
			return [ 'P_OPTION_%s' % o.upper() for o in self._options ]

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

		def filesdir(self):
			return '%s/files' % self.workdir()

		def destdir(self):
			return '%s/staging' % self.workdir()

		def make(self, rule):
			cookie.logger.info('running %s on package' % rule)
			if self._arch not in self.archs():
				raise Exception('package %s does not support %s architecture' % (self.name(), self._arch))
			else:
				if not os.path.isdir(self.workdir()): os.makedirs(self.workdir())
				srcdir = '%s/%s' % (self.workdir(), self._meta['SRCDIR']) if 'SRCDIR' in self._meta else '%s/srcdir' % self.workdir()
				envfile = '%s/%s.env' % (cookie.layout.toolchains(), self._profile.toolchain())
				s = cookie.shell()
				s.loadenv()
				s.setenv('P_WORKDIR',   	self.workdir())
				s.setenv('P_DESTDIR',   	self.destdir())
				s.setenv('P_SYSROOT',   	self.rootfs())
				s.setenv('P_FILESDIR',   	self.filesdir())
				for k, v in self._profile.options().items(): s.setenv(k, v)
				s.run('. %s && make -C %s -f %s %s' % (envfile, srcdir if os.path.isdir(srcdir) else self.workdir(), self.makefile(), rule))

		def clean(self):
			cookie.logger.info('cleaning package workdir')
			if os.path.isdir(self.workdir()):
				cookie.logger.debug('removing old build directory %s' % self.workdir())
				shutil.rmtree(self.workdir())
			else:
				cookie.logger.debug('work does not need to be cleaned')

		def check(self):
			cookie.logger.info('checking package')
			cookie.logger.debug('required options are %s' % str(self.options()))
			cookie.logger.debug('supported archs are %s' % str(self._archs))
			if self._arch not in self._archs:
				raise Exception('architecture %s is not supported by package' % self._arch)
			opts = self._profile.options()
			for o in self.options():
				if not o in opts:
					raise Exception('option %s not defined in profile' % o)
			for i in self._files:
				rname = i[:-1] if i.endswith('?') else i
				rpath = '%s/%s/%s' % (cookie.layout.profiles(), self._profile.name(), rname)
				if not i.endswith('?') and not os.path.exists(rpath):
					raise Exception('required import "%s" not found in profile' % rname)
			cookie.logger.debug('all check passed')

		def fetch(self):
			if len(self._files) > 0 and not os.path.isdir(self.filesdir()): os.makedirs(self.filesdir())
			for i in self._files:
				name  = i[:-1] if i.endswith('?') else i # '?' means optional
				source = '%s/%s/%s' % (cookie.layout.profiles(), self._profile.name(), name)
				target = '%s/%s' % (self.filesdir(), name)
				if os.path.exists(source): shutil.copyfile(source, target)
			self.make('fetch')

		def setup(self):
			self.make('setup')

		def patch(self):
			cookie.logger.info('running patch on package')
			profile = self._target.profile() if self._target else None
			srcdir = '%s/%s' % (self.workdir(), self._meta['SRCDIR']) if 'SRCDIR' in self._meta else '%s/srcdir' % self.workdir()
			patchfile = '%s/%s/%s-%s-%s.patch' % (cookie.layout.profiles(), profile, self._overlay, self._name, self._version)
			if os.path.isdir(srcdir) and os.path.isfile(patchfile):
				cookie.shell().run('patch -d %s -p1 < %s' % (srcdir, patchfile))
			else:
				cookie.logger.debug('Package does not need patching')

		def compile(self):
			self.make('compile')

		def install(self):
			self.make('install')

		def has_binpkg(self):
			try:
				sha1file = '%s/%s-%s.sha1' % (self.archives(), self.name(), self.version())
				if not os.path.isfile(sha1file):
					return False

				lines = [ l.strip() for l in open(sha1file).readlines() ]
				entries = {}
				for l in lines:
					tokens = [ t.strip() for t in l.split() ]
					if len(tokens) not in [ 1, 2 ]:
						cookie.logger.error('Skipping invalid check sum entry "%s" for "%s"' % (l, self.name()))
					else:
						entries[tokens[0]] = tokens[1] if len(tokens) == 2 else ""

				if 'Makefile' not in entries or entries['Makefile'] != cookie.sha1.compute(self.makefile()):
					cookie.logger.debug('Rebuilding package "%s" as its Makefile changed' % self.name())
					return False

				for i in self._files:
					rname = i[:-1] if i.endswith('?') else i
					rpath = '%s/%s/%s' % (cookie.layout.profiles(), self._profile.name(), rname)
					if rname not in entries or entries[rname] != (cookie.sha1.compute(rpath) if os.path.exists(rpath) else ""):
						cookie.logger.debug('Rebuilding package "%s" as its import "%s" changed' % (self.name(), rname))
						return False

				return True

			except Exception as e:
				cookie.logger.debug('Call to has bin pkg failed: %s' % str(e))
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
				except Exception as e:
					meta = {}
				meta[self.name()] = { 'overlay':self.overlay(), 'version': self.version() }
				json.dump(meta, open('%s/packages.json' % self.installed(), 'w'))

		def mkarchive(self):
			archive = '%s-%s.tar.xz' % (self.name(), self.version())
			cookie.logger.info('creating archive %s' % archive)
			if not os.path.isdir(self.archives()): os.makedirs(self.archives())
			cookie.shell().run('tar cJf %s/%s -C %s .' % (self.archives(), archive, self.destdir()))
			with open('%s/%s-%s.sha1' % (self.archives(), self.name(), self.version()), 'w') as handle:
				handle.write('Makefile	%s\n' % cookie.sha1.compute(self.makefile()))
				for i in self._files:
					rname = i[:-1] if i.endswith('?') else i
					rpath = '%s/%s/%s' % (cookie.layout.profiles(), self._profile.name(), rname)
					handle.write('%s	%s\n' % (rname, cookie.sha1.compute(rpath) if os.path.exists(rpath) else ""))
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
	def exists(self, overlay, name, version):
		return os.path.isfile('%s/%s-%s.mk' % (cookie.layout.packages(), name, version))

	@classmethod
	def parse_selector(self, selector):
		onv		= selector
		overlay = onv.split('/')[0] if onv.find('/') != -1 else None
		nv 		= onv.split('/')[1] if onv.find('/') != -1 else onv
		name	= nv if nv.rfind('-') == -1 or not nv[nv.rfind('-')+1].isdigit() else '-'.join(nv.split('-')[0:-1])
		version	= None	if nv == name else nv[len(name)+1:]
		return (overlay, name, version)

	@classmethod
	def candidates(self, selector):
		(overlay, name, version) = self.parse_selector(selector)
		candidates = []
		if version is not None and overlay is not None and self.exists(overlay, name, version):
			candidates.append((overlay, name, version))
		else:
			ovs = [ overlay ] if overlay else os.listdir(cookie.layout.packages())
			for ov in ovs:
				all  = os.listdir('%s/%s' % (cookie.layout.packages(), ov))
				for a in all:
					candidate = self.parse_selector(ov + '/' + a.split('.mk')[0])
					if candidate[1] == name:
						candidates.append((candidate[0], candidate[1], candidate[2]))
			return candidates

	@classmethod
	def elect(self, selector):
		candidates = self.candidates(selector)
		if len(candidates) == 0:
			raise Exception('no matching package for selector %s' % selector)
		else:
			eo, en, ev = candidates[0]
			for o, n, v in candidates:
				if distutils.version.LooseVersion(ev) < distutils.version.LooseVersion(v):
					eo = o
					ev = v
			return cookie.packages.package(eo, en, ev)

	@classmethod
	def get(self, overlay, name, version):
		return self.elect('%s/%s-%s' % (overlay, name, version))
