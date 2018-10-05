import os
import sys
import errno
import cookie

class distfiles:

	@classmethod
	def path(self):
		return cookie.layout.distfiles()

	@classmethod
	def fetch(self, url, name):
		name = url.split('/')[-1] if name is None else name
		dest = cookie.layout.distfile(name)
		cookie.logger.info('retrieving %s from %s' % (name, url))
		try:
			if not os.path.isdir(cookie.layout.distfiles()):
				os.makedirs(cookie.layout.distfiles())
			if not os.path.isfile(dest):
				(status, out, err) = cookie.shell().run('wget -c %s -O %s.t' % (url, dest))
				if status != 0:
					raise Exception('failed to download from "%s", got HTTP status %d' % (url, status))
				else:
					os.rename('%s.t' % (dest), '%s' % (dest,))
			else:
				cookie.logger.debug('already downloaded this archive')
		except Exception, e:
			os.unlink('%s.t' % (dest))
			raise

	@classmethod
	def archive(self, name):
		path = cookie.layout.distfile(name)
		if os.path.isfile(path):
			return path
		raise Exception('archive %s was not found in the cache' % name)

	@classmethod
	def extract(self, name, dest):
		try:
			s = cookie.shell()
			if not os.path.isdir(dest): os.makedirs(dest)
			if name.endswith('.tar.bz2') or name.endswith('.tbz2'):
				s.run('cd %s && tar -xvjf %s' % (dest, self.archive(name)))
			elif name.endswith('.tar.gz') or name.endswith('.tgz'):
				s.run('cd %s && tar -xvzf %s' % (dest, self.archive(name)))
			elif name.endswith('.zip'):
				s.run('cd %s && unzip %s' % (dest, self.archive(name)))
			elif name.endswith('.xz'):
				s.run('cd %s && tar -xvf %s' % (dest, self.archive(name)))
			else:
				raise Exception('unsupported %s format' % name.split('.')[-1])
		except Exception, e:
			raise Exception('could not extract %s: %s' % (name, str(e)))

	@classmethod
	def list(self):
		res = []
		if os.path.isdir(cookie.layout.distfiles()):
			for e in os.listdir(cookie.layout.distfiles()):
				res.append(e)
		return res

	@classmethod
	def remove(self, name):
		if os.path.isfile(cookie.layout.distfile(name)):
			os.unlink(cookie.layout.distfile(name))

	@classmethod
	def clear(self):
		if os.path.isdir(cookie.layout.distfiles()):
			for e in os.listdir(cookie.layout.distfiles()):
				self.remove(e)
