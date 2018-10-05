#!/usr/bin/python

import os
import subprocess
import select
import sys
import cookie

class shell:

	def __init__(self):
		self._path			= os.getcwd()
		self._env			= None

	def setpath(self, path):
		self._path = path

	def setenv(self, name, value):
		if self._env is None:
			self._env = {}
		self._env[name] = value

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
				cookie.logger.debug(data)
				(out if handle == p.stdout else err).append(data)
		status = p.wait()
		if status != 0:
			raise Exception, 'shell: command "%s" in "%s" failed with status %d' % (cmd, self._path, status)
		return (status, out, err)
