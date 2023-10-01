import os
from os.path import expanduser

class layout:

	@classmethod
	def root(self):
		try:
			return os.getenv('COOKIE')
		except Exception as e:
			return None

	@classmethod
	def profiles(self):
		d = '%s/profiles' % self.root()
		if not os.path.isdir(d):
			os.makedirs(d)
		return d

	@classmethod
	def packages(self):
		d = '%s/packages' % self.root()
		if not os.path.isdir(d):
			os.makedirs(d)
		return d

	@classmethod
	def bootstrap(self):
		d = '%s/bootstrap' % self.root()
		if not os.path.isdir(d):
			os.makedirs(d)
		return d

	@classmethod
	def toolchains(self):
		d = '%s/toolchains' % self.root()
		if not os.path.isdir(d):
			os.makedirs(d)
		return d

	@classmethod
	def cache(self):
		d = '%s/cache' % self.root()
		if not os.path.isdir(d):
			os.makedirs(d)
		return d

	@classmethod
	def distfiles(self):
		d = '%s/distfiles' % self.cache()
		if not os.path.isdir(d):
			os.makedirs(d)
		return d

	@classmethod
	def gitsources(self):
		d = '%s/gitsources' % self.cache()
		if not os.path.isdir(d):
			os.makedirs(d)
		return d

	@classmethod
	def images(self):
		d = '%s/images' % self.cache()
		if not os.path.isdir(d):
			os.makedirs(d)
		return d

	@classmethod
	def distfile(self, name):
		return '%s/%s' % (self.distfiles(), name)

	@classmethod
	def gitsource(self, name):
		return '%s/%s' % (self.gitsources(), name)
