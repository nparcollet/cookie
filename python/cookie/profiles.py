#!/usr/bin/python

import os
import shutil
import re
import cookie
import json

class profiles:

	class profile:

		def __init__(self, name, board):
			self._name  = name
			self._board = board
			self._infos = json.load(open('%s/%s/profile.conf' % (cookie.layout.profiles(), name)))

		def name(self):
			return self._name

		def board(self):
			return self._board

		def image(self, field):
			return self._infos['image'][field]

		def toolchain(self):
			return self._infos['boards'][self._board]["toolchain"]

		def arch(self):
			return self._infos['boards'][self._board]["arch"]

		def env(self):
			return { ('P_%s' % k): v for k, v in self._infos['env'].items() }

		def board_env(self):
			return { ('P_BOARD_%s' % k): v for k, v in self._infos['boards'][self._board]["env"].items() }

		def packages(self):
			list = []
			path = '%s/%s/packages.conf' % (cookie.layout.profiles(), self._name)
			with open(path, 'r') as handle:
				for l in handle.readlines():
					selector = re.split('[\t ]+', l)[0].strip()
					if len(selector) > 0: list.append(selector)
				handle.close()
			return list

	@classmethod
	def boards(self, name):
		data = json.load(open('%s/%s/profile.conf' % (cookie.layout.profiles(), name)))
		return [ k for k, v in data['boards'].items() ]

	@classmethod
	def list(self):
		return os.listdir(cookie.layout.profiles())

	@classmethod
	def get(self, name, board):
		return cookie.profiles.profile(name, board)
