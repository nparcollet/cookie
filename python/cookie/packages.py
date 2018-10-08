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
			self._overlay		= overlay
			self._name			= name
			self._version		= version
			self._meta			= { re.split('[:?]?=', line)[0][2:].strip(): line.split('=')[1].strip() for line in tuple(open(self.makefile(), 'r')) if line[0:2] == 'P_' }
			self._description	= self._meta['DESCRIPTION'].strip() 					if 'DESCRIPTION' in self._meta else ''
			self._depends		= [ o.strip() for o in self._meta['DEPENDS'].split() ]  if 'DEPENDS'     in self._meta else []
			self._licences		= [ o.strip() for o in self._meta['LICENCES'].split() ] if 'LICENCES'    in self._meta else []
			self._archs			= [ o.strip() for o in self._meta['ARCHS'].split() ]    if 'ARCHS'       in self._meta else []
			self._provides      = [ o.strip() for o in self._meta['PROVIDES'].split() ] if 'PROVIDES'    in self._meta else []
			self._target		= None
			self._profile		= None
			self._targetdir		= None
			self._env			= { 'ARCH':'amd64' }

		def selector(self):
			return '%s/%s-%s' % (self.overlay(), self.name(), self.version())

		def attach(self, target):
			self._target	= target
			self._targetdir	= cookie.targets.get(self._target).path() #cookie.layout.target(self._target)
			self._profile	= cookie.targets.get(self._target).profile()
			self._env		= cookie.profiles.get(self._profile).buildenv()
			self._arch		= cookie.profiles.get(self._profile).arch()

		def provides(self):
			return self._provides

		def depends(self):
			return self._depends

		def overlay(self):
			return self._overlay

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
			return '%s/%s/%s/%s-%s.mk' % (cookie.layout.packages(), self._overlay, self._name, self._name, self._version)

		def sha1(self):
			h = hashlib.sha1()
			with open(self.makefile(), 'rb') as handle:
				chunk = 0
				while chunk != b'':
					chunk = handle.read(1024)
					h.update(chunk)
			return str(h.hexdigest())

		def arch(self):
			return self._arch

		def rootfs(self):
			return '%s/rootfs' % self._targetdir

		def archives(self):
			return '%s/archives' % self._targetdir

		def installed(self):
			return '%s/installed' % self._targetdir

		def workdir(self):
			return '%s/build/%s-%s' % (self._targetdir, self.name(), self.version())

		def destdir(self):
			return '%s/staging' % self.workdir()

		def srcdir(self):
			return '%s/srcdir' % self.workdir()

		def make(self, rule):
			cookie.logger.info('running %s on package' % rule)
			if self._arch not in self.archs():
				raise Exception('package %s does not support %s architecture' % (self.name(), self._arch))
			else:
				if not os.path.isdir(self.workdir()): os.makedirs(self.workdir())
				s = cookie.shell()
				s.loadenv()
				s.addenv(self._env)
				s.setenv('P_WORKDIR', self.workdir())
				s.setenv('P_DESTDIR', self.destdir())
				s.setenv('P_SRCDIR', self.srcdir())
				s.run('make -f %s %s' % (self.makefile(), rule))

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
				sha1file  = '%s/%s-%s-%s.sha1' % (self.archives(), self.overlay(), self.name(), self.version())
				installed = str(open(sha1file).read().strip())
				packaged  = self.sha1()
				return True if packaged == installed else False
			except Exception, e:
				return False

		def merge(self):
			archive = '%s/%s-%s-%s.tar.xz' % (self.archives(), self.overlay(), self.name(), self.version())
			(status, entries, errors) = cookie.shell(quiet = True).run('tar -tf %s' % archive)
			conflicts = [ e[2:] for e in entries if os.path.isfile('%s/%s' % (self.rootfs(), e[2:])) or os.path.islink('%s/%s' % (self.rootfs(), e[2:])) ]
			if not os.path.isdir(self.rootfs()):
				os.makedirs(self.rootfs())
			elif conflicts:
				cookie.logger.abort('conflicts detected: %s' % str(conflicts))
			else:
				cookie.shell().run('cd %s && tar xJf %s/%s-%s-%s.tar.xz' % (self.rootfs(), self.archives(), self.overlay(), self.name(), self.version()))
				open('%s/%s.list' % (self.installed(), self.name()), 'w').write('\n'.join([ x[1:] for x in reversed(entries) ]))
				path = '%s/packages.json' % self.installed()
				try :
					meta = json.load(open(path)) if os.path.isfile(path) else {}
				except Exception, e:
					meta = {}
				meta[self.name()] = { 'overlay': self.overlay(), 'version': self.version() }
				json.dump(meta, open('%s/packages.json' % self.installed(), 'w'))

		def mkarchive(self):
			archive = '%s-%s-%s.tar.xz' % (self.overlay(), self.name(), self.version())
			cookie.logger.info('creating archive %s' % archive)
			if not os.path.isdir(self.archives()): os.makedirs(self.archives())
			cookie.shell().run('tar cJf %s/%s -C %s .' % (self.archives(), archive, self.destdir()))
			with open('%s/%s-%s-%s.sha1' % (self.archives(), self.overlay(), self.name(), self.version()), 'w') as handle:
				print >> handle, self.sha1()
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
		return os.path.isfile('%s/%s/%s/%s-%s.mk' % (cookie.layout.packages(), overlay, name, name, version))

	@classmethod
	def parse(self, selector):
		overlay	= None		if selector.find('/') == -1 else selector.split('/')[0]
		pnv		= selector	if overlay is None else selector.split('/')[1]
		name	= pnv		if pnv.rfind('-') == -1 or not pnv[pnv.rfind('-')+1].isdigit() else '-'.join(pnv.split('-')[0:-1])
		version	= None		if pnv == name else pnv[len(name)+1:]
		return (overlay, name, version)

	@classmethod
	def candidates(self, selector):
		(overlay, name, version) = self.parse(selector)
		candidates = []
		overlays  = [overlay] if overlay is not None else os.listdir(cookie.layout.packages())
		for o in overlays:
			if version is not None and self.exists(o, name, version):
				candidates.append((o, name, version))
			elif version is None and os.path.isdir('%s/%s/%s' % (cookie.layout.packages(), o, name)):
				for e in os.listdir('%s/%s/%s' % (cookie.layout.packages(), o, name)):
					candidates.append((o, '-'.join(e.split('-')[0:-1]), e.split('-')[-1].split('.mk')[0]))
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
