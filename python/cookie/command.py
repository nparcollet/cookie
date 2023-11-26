#!/usr/bin/python

import os
import sys
import cookie
import time

class command(object):

	def __init__(self, action = 'help'):
		self._name		= os.path.basename(sys.argv[0])
		self._action    = action

	def name(self):
		return self._name

	def actions(self):
		res = []
		for e in dir(self):
			if not e.startswith('do_'): continue
			res.append(e[3:])
		return res

	def summary(self, action):
		raw = self.__getattribute__('do_%s' % action).__doc__
		if raw is None or len(raw) == 0:
			return 'no documentation available'
		elif raw.find('.'):
			return raw[0:raw.find('.')].strip()
		else:
			return raw.strip()

	def run(self):
		if cookie.layout.root() == None:
			cookie.logger.abort('The COOKIE environment variable is not defined')
			return 1
		else:
			action = sys.argv[1] if len(sys.argv) > 1 else self._action
			args   = sys.argv[2:] if len(sys.argv) > 1 else []
			exectime = False if os.getenv('COOKIE_ENV') == '1' else True

			if action in self.actions():
				try:
					start_time = time.time()
					self.__getattribute__('do_%s' % action)(args)
					if exectime: cookie.logger.debug("Command executed in %.2f seconds" % (time.time() - start_time))
					sys.exit(0)
				except Exception as e:
					if exectime: cookie.logger.abort('Failed after %.2f seconds: %s' % (time.time() - start_time, str(e)))
			else:
				self.do_help([])

	def do_help(self, args):
		print('')
		ml  = max([ len(a) for a in self.actions()])
		doc = self.__getattribute__('do_help').__doc__
		desc = '\t' + doc.strip().replace('\t', '').replace('\n', '\n\t') if doc else 'No description'
		print('\033[31mSYNTAX\033[0m')
		print('	%s %s [args]' % (self._name, '|'.join(self.actions())))
		print('')
		print('\033[31mDESCRIPTION\033[0m')
		print('\t%s' % self.__doc__.strip().replace('\t', '').replace('\n', '\n\t'))
		print('')
		for a in self.actions():
			print('\033[31mACTION: %s\033[0m' % a.upper())
			d = self.__getattribute__('do_%s' % a).__doc__
			if d is None:
				print('	No documentation available for %s' % a)
			else:
				print('%s' % '\t' + d.strip().replace('\t', '').replace('\n', '\n\t'))
			print('')
