#!/usr/bin/python

import os
import subprocess
import select
import sys
import cookie

class shell:

	def __init__(self, quiet = False):
		try:
			self._path = os.getcwd()
		except Exception as e:
			cookie.logger.abort('current directory is invalid and was probably deleted' )
		self._env	= None
		self._log	= None
		self._quiet = quiet
		self._inenv = True if os.getenv('COOKIE_ENV') == '1' else False

	def setpath(self, path):
		self._path = path

	def setenv(self, name, value):
		if self._env is None:
			self._env = {}
		self._env[name] = value

	def setquiet(self, quiet):
		self._quiet = quiet

	def setlog(self, path):
		if not os.path.exists(path[0:path.rfind('/')]):
			os.makedirs(path[0:self._log.rfind('/')])
		self._log = open(path, 'w')

	def addenv(self, data):
		for d in data:
			self.setenv(d, data[d])

	def clearenv(self):
		self._env = None

	def loadenv(self):
		self._env = dict(os.environ)

	def run(self, cmd):
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
				if not self._quiet:
					cookie.logger.debug(data)
				if self._log:
					print >> self._log, data
				(out if handle == p.stdout else err).append(data)
		status = p.wait()
		if status != 0:
			raise Exception('shell: command "%s" in "%s" failed with status %d' % (cmd, self._path, status))
		return (status, out, err)
