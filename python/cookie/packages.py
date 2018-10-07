import os
import shutil
import cookie
import re
import distutils.version
import hashlib

class packages:

	"""
	TODO: Check package dependencies before building
	TODO: Handle Provides/Virtual Packages
	"""

	class package:

		def __init__(self, overlay, name, version):
			self._overlay		= overlay
			self._name			= name
			self._version		= version
			self._meta			= { re.split('[:?]?=', line)[0][2:].strip(): line.split('=')[1].strip() for line in tuple(open(self.makefile(), 'r')) if line[0:2] == 'P_' }
			self._description	= self._meta['DESCRIPTION'].strip()
			self._depends		= [ o.strip() for o in self._meta['DEPENDS'].split() ]
			self._licences		= [ o.strip() for o in self._meta['LICENCES'].split() ]
			self._archs			= [ o.strip() for o in self._meta['ARCHS'].split() ]
			self._target		= None
			self._profile		= None
			self._targetdir		= None
			self._env			= { 'ARCH':'amd64' }

		def selector(self):
			return '%s/%s-%s' % (self.overlay(), self.name(), self.version())

		def attach(self, target):
			self._target	= target
			self._profile	= cookie.targets.get(self._target).profile()
			self._env		= cookie.profiles.get(self._profile).buildenv()
			self._arch		= cookie.profiles.get(self._profile).arch()
			self._targetdir	= cookie.layout.target(self._target)

		def depends(self):
			return self._depends

		def depends_r(self):
			all = {}
			for d in self.depends():
				p = cookie.packages.elect(d)
				all[p.selector()] = p.depends_r()
			return all

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

		def debian(self):
			return '%s/debian' % self._targetdir

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
			sha1file = '%s/%s-%s.sha1' % (self.debian(), self.name(), self.version())
			try:
				with open(path, 'r') as handle:
					data = handle.read().strip()
					handle.close()
				return self.sha1() == data
			except Exception, e:
				return False

		def mkdeb(self):
			debfile = '%s/%s-%s.deb' % (self.debian(), self.name(), self.version())
			if not os.path.isdir('%s/DEBIAN' % self.destdir()):
				os.makedirs('%s/DEBIAN' % self.destdir())
			with open('%s/DEBIAN/control' % self.destdir(), 'w') as handle:
				print >> handle, 'Package: %s' % self.name()
				print >> handle, 'Version: %s' % self.version()
				print >> handle, 'Depends: %s' % ', '.join(self.depends())
				print >> handle, 'Description: %s' % self.description()
				print >> handle, 'Section: cookie'
				print >> handle, 'Priority: optional'
				print >> handle, 'Architecture: %s' % self._arch
				print >> handle, 'Maintainer: Cookie Environment'
				handle.close()
			cookie.shell().run('mkdir -p %s && dpkg-deb --build %s %s' % (self.debian(), self.destdir(), debfile))
			with open('%s/%s-%s.sha1' % (self.debian(), self.name(), self.version()), 'w') as handle:
				print >> handle, self.sha1()
				handle.close()

		def merge(self):
			cookie.logger.info('merging package')
			shell = cookie.shell()
			shell.run('mkdir -p %s/var/lib/dpkg' % self.rootfs())
			shell.run('mkdir -p %s/var/lib/dpkg/updates' % self.rootfs())
			shell.run('mkdir -p %s/var/lib/dpkg/info' % self.rootfs())
			shell.run('touch %s/var/lib/dpkg/status' % self.rootfs())
			shell.run('dpkg --root=%s --force-architecture -i %s/%s-%s.deb' % (self.rootfs(), self.debian(), self.name(), self.version()))

		def unmerge(self):
			cookie.logger.info('uninstalling package')
			cookie.shell().run('dpkg --root=%s -P %s' % (self.rootfs(), self._name))

		def installed_version(self):
			try:
				shell = cookie.shell()
				shell.setquiet(True)
				(s, o, e) = shell.run('dpkg --root=%s --force-architecture  -l | awk \'$2=="%s" { print $3 }\'' % (self.rootfs(), self.name()))
				return o[0] if len(o) == 1 else None
			except Exception, e:
				return None

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
