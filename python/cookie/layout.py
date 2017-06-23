import os

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
	def profiles(self):
		return '%s/profiles' % self.root()

	@classmethod
	def profile(self, name):
		return '%s/%s' % (self.profiles(), name)

	@classmethod
	def packages(self):
		return '%s/packages' % self.root()

	@classmethod
	def distfiles(self):
		return '%s/cache/distfiles' % self.root()

	@classmethod
	def gitsources(self):
		return '%s/cache/gitsources' % self.root()
