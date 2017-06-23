#!/usr/bin/python

import os
import shutil
import cookie
import re

class profiles:

	class profile:

		def __init__(self, name):
			self._name = name
			self._path = cookie.layout.profile(self._name)

		def name(self):
			return self._name

		def path(self):
			return self._path

		def buildenv(self):
			return  { line[0:line.find('=')].strip(): line[line.find('=')+1:].strip() for line in tuple(open('%s/build.env' % self._path, 'r')) if len(line.strip()) > 0 and line.strip()[0] != '#' and line.find('=') > 0}

		def arch(self):
			return self.buildenv()['ARCH']

		def packages(self):
			path = '%s/packages.conf' % (self._path)
			list = []
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
	def get(self, name):
		return cookie.profiles.profile(name)
