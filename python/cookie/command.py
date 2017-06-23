#!/usr/bin/python

import os
import sys
import cookie

class command(object):

	"""
	Base class to be used in order to create cookie command line tools. It provide basic functions
	that are common to all of them, such as path definitions to the various files of the
	environment and sanity check functions.
	"""

	def __init__(self, action = 'help'):
		"""
		Initialize the command object. The name is saved at this time and can be further referenced
		by calling the name() function. When initializing the command it is possible to specify the
		default action to run when none is provided. This action defaults to "help" if it is not
		set.
		"""
		self._name		= os.path.basename(sys.argv[0])
		self._action    = action

	def name(self):
		"""
		Retrieve the name of this command. The name is initialized when the command object is
		created by extracting it from the command line argument (argv[0]).
		"""
		return self._name

	def actions(self):
		"""
		List the existing actions for this command. An action is a method of the command subclass
		whose name starts with the do_ prefix. This function is used when generating the help for
		the command.
		"""
		res = []
		for e in dir(self):
			if not e.startswith('do_'): continue
			res.append(e[3:])
		return res

	def summary(self, action):
		"""
		Get the first sentence within the documentation of the given action. This is used
		when displaying a summary of the commands while invoking the help menu.
		"""
		raw = self.__getattribute__('do_%s' % action).__doc__
		if raw is None or len(raw) == 0:
			return 'no documentation available'
		elif raw.find('.'):
			return raw[0:raw.find('.')].strip()
		else:
			return raw.strip()

	def run(self):
		"""
		Parse stdin an perform the action requested by the caller. Once the action is completed the
		program return a status code indicating whether it succeeded or not. Note that if the path
		to the cookie environment is not defined (COOKIE env), the execution will fail immediatly.
		If an action fail to execute, it is expected to raise an exception so that the error is
		properly forwarded to the caller and the exit status code is correct.
		"""
		if cookie.layout.root() == None:
			cookie.logger.abort('The COOKIE environment variable is not defined')
			return 1
		else:
			action = sys.argv[1] if len(sys.argv) > 1 else self._action
			args   = sys.argv[2:] if len(sys.argv) > 1 else []
			if action in self.actions():
				try:
					self.__getattribute__('do_%s' % action)(args)
					sys.exit(0)
				except Exception, e:
					cookie.logger.abort('cant run: ' + e.message)
			else:
				self.do_help([])

	def do_help(self, args):
		"""
		List of all the command actions along with their description. This menu is shown when running
		the command with no parameter where one is expected, or when the command is invoked with an
		invalid action parameter.
		"""
		print ''
		ml  = max([ len(a) for a in self.actions()])
		doc = self.__getattribute__('do_help').__doc__
		desc = '\t' + doc.strip().replace('\t', '').replace('\n', '\n\t') if doc else 'No description'
		print '\033[31mSYNTAX\033[0m'
		print '	%s %s [args]' % (self._name, '|'.join(self.actions()))
		print ''
		print '\033[31mDESCRIPTION\033[0m'
		print '\t%s' % self.__doc__.strip().replace('\t', '').replace('\n', '\n\t')
		print ''
		for a in self.actions():
			print '\033[31mACTION: %s\033[0m' % a.upper()
			d = self.__getattribute__('do_%s' % a).__doc__
			if d is None:
				print '	No documentation available for %s' % a
			else:
				print '%s' % '\t' + d.strip().replace('\t', '').replace('\n', '\n\t')
			print ''
