#!/usr/bin/python

import os
import subprocess
import select
import sys
import cookie

class shell:

	def __init__(self, path = None, env = None, log = None, chroot = None, sudo = False, raise_errors = True):
		self._path		=	os.getcwd() if path is None else path
		self._env		=	env
		self._raise_errors	=	raise_errors
		self._log		=	log
		self._handle		=	None
		self._chroot		=	chroot
		self._sudo			= sudo
		if self._log:
			if not os.path.exists(self._log[0:self._log.rfind('/')]):
				os.makedirs(self._log[0:self._log.rfind('/')])
			self._handle = open(self._log, 'w')

	def setpath(self, path):
		self._path = path

	def setenv(self, name, value):
		if self._env is None:
			self._env = {}
		self._env[name] = value

	def clearenv(self):
		self._env = None

	def loadenv(self):
		self._env = dict(os.environ)

	def addenv(self, data):
		for d in data:
			self.setenv(d, data[d])

	def run(self, cmd):
		cmd = 'chroot /bin/bash -c %s %s' % (self._chroot, cmd) if self._chroot else cmd
		cmd = 'sudo %s' % cmd if self._sudo else cmd
		p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True, cwd=self._path, env=self._env)
		handles = [ p.stdout, p.stderr ]
		out = err = []
		while handles:
			for handle in select.select(handles, tuple(), tuple())[0]:
				output = handle.readline()
				if not output:
					handles.remove(handle)
					continue
				data = output.rstrip()
				cookie.logger.debug(data)
				if self._handle: print >> self._handle, data
				(out if handle == p.stdout else err).append(data)
		status = p.wait()
		if status != 0 and self._raise_errors:
			raise Exception, 'shell: command "%s" in "%s" failed with status %d' % (cmd, self._path, status)
		return (status, out, err)
