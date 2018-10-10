#!/usr/bin/python

import os
import shutil
import re
import cookie

class profiles:

	class profile:

		def __init__(self, board, app):
			self._board = board
			self._app   = app
			self._path  = cookie.layout.profile(board)
			self._apps  = [ x[:-5] for x in os.listdir(self._path) if x.endswith('.conf') ]

		def board(self):
			return self._board

		def app(self):
			return self._app

		def apps(self):
			return self._apps

		def path(self):
			return self._path

		def buildenv(self):
			return  { line[0:line.find('=')].strip(): line[line.find('=')+1:].strip() for line in tuple(open('%s/build.env' % self._path, 'r')) if len(line.strip()) > 0 and line.strip()[0] != '#' and line.find('=') > 0}

		def arch(self):
			return self.buildenv()['ARCH']

		def host(self):
			return self.buildenv()['HOST']

		def packages(self):
			list = []
			if self._app:
				path = '%s/%s.conf' % (self._path, self._app)
				with open(path, 'r') as handle:
					for l in handle.readlines():
						selector = re.split('[\t ]+', l)[0].strip()
						if len(selector) > 0: list.append(selector)
					handle.close()
			return list

	@classmethod
	def list(self):
		return os.listdir(cookie.layout.profiles())

	@classmethod
	def get(self, board, app):
		return cookie.profiles.profile(board, app)
