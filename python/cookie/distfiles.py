import os
import sys
import errno
import cookie

class distfiles:

	def __init__(self):
		self._path = cookie.layout.distfiles()
		if not os.path.isdir(self.path()):
			os.makedirs(self.path())

	def path(self):
		return self._path

	def fetch(self, url, name):
		name = url.split('/')[-1] if name is None else name
		dest = '%s/%s' % (self.path(), name)
		cookie.logger.info('retrieving %s from %s' % (name, url))
		try:
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

	def archive(self, name):
		path = '%s/%s' % (self.path(), name)
		if os.path.isfile(path):
			return path
		raise Exception('archive %s was not found in the cache' % name)

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

	def list(self):
		raise Exception('list is not implemented')

	def clear(self):
		raise Exception('clear is not implemented')
