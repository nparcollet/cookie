import os
from os.path import expanduser

class layout:

	@classmethod
	def root(self):
		try:
			return os.getenv('COOKIE')
		except Exception, e:
			return None

	@classmethod
	def targets(self):
		return '%s/targets' % self.root()

	@classmethod
	def target(self, name):
		return '%s/%s' % (self.targets(), name)

	@classmethod
	def patches(self):
		return '%s/patches' % self.root()

	@classmethod
	def profiles(self):
		return '%s/profiles' % self.root()

	@classmethod
	def packages(self):
		return '%s/packages' % self.root()

	@classmethod
	def cache(self):
		# HOME: expanduser("~")
		return '%s/cache' % self.root()

	@classmethod
	def distfiles(self):
		return '%s/distfiles' % self.cache()

	@classmethod
	def gitsources(self):
		return '%s/gitsources' % self.cache()

	@classmethod
	def distfile(self, name):
		return '%s/%s' % (self.distfiles(), name)

	@classmethod
	def gitsource(self, name):
		return '%s/%s' % (self.gitsources(), name)

	@classmethod
	def bootstrap(self):
		return '%s/bootstrap' % self.root()
