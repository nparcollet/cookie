#!/usr/bin/python

import os
import shutil
import re
import cookie

class profiles:

	class profile:

		def __init__(self, name, board):
			self._name  = name
			self._board = board
			self._path  = '%s/%s' % (cookie.layout.profiles(), name)

		def name(self):
			return self._name

		def board(self):
			return self._board

		def path(self):
			return self._path

		def buildenv(self):
			return  { line[0:line.find('=')].strip(): line[line.find('=')+1:].strip() for line in tuple(open('%s/%s.env' % (self._path, self._board), 'r')) if len(line.strip()) > 0 and line.strip()[0] != '#' and line.find('=') > 0}

		def arch(self):
			return self.buildenv()['ARCH']

		def host(self):
			return self.buildenv()['HOST']

		def toolchain(self):
			return self.buildenv()['TOOLCHAIN']

		def packages(self):
			list = []
			path = '%s/packages.conf' % (self._path)
			with open(path, 'r') as handle:
				for l in handle.readlines():
					selector = re.split('[\t ]+', l)[0].strip()
					if len(selector) > 0: list.append(selector)
				handle.close()
			return list

	@classmethod
	def boards(self, name):
		result = []
		data = open('%s/%s/boards.conf' % (cookie.layout.profiles(), name)).read().split()
		for line in data:
			if (line != '' and line[0] != '#'):
				result.append(line.strip());
		return result;

	@classmethod
	def list(self):
		return os.listdir(cookie.layout.profiles())

	@classmethod
	def get(self, name, board):
		return cookie.profiles.profile(name, board)
