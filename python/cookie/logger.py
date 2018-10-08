import sys

class logger:

	@classmethod
	def error(self, msg):
		print '[\033[31m!\033[0m] \033[31m%s\033[0m' % msg

	@classmethod
	def abort(self, msg):
		print '[\033[31m*\033[0m] \033[31m%s\033[0m' % msg
		sys.exit(1)

	@classmethod
	def info(self, msg):
		print '[\033[32m*\033[0m] \033[32m%s\033[0m' % msg

	@classmethod
	def debug(self, msg):
		print '... \033[37m%s\033[0m' % msg
