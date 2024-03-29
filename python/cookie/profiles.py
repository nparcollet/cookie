#!/usr/bin/python

import os
import shutil
import re
import cookie
import json

class profiles:

	class profile:

		def __init__(self, name, board):
			self._name  	= name
			self._board		= board
			self._infos 	= json.load(open('%s/%s/profile.conf' % (cookie.layout.profiles(), name)))
			self._boards	= { b: json.load(open('%s/%s.conf' % (cookie.layout.boards(), b))) for b in self._infos['boards'] }

		def name(self):
			return self._name

		def board(self):
			return self._board

		def image(self, field):
			return self._infos['image'][field]

		def toolchain(self):
			return self._boards[self._board]["toolchain"]

		def arch(self):
			return self._boards[self._board]["arch"]

		def chipset(self):
			return self._boards[self._board]["chipset"]

		def cpu(self):
			return self._boards[self._board]["cpu"]

		def isa(self): # Instruction Set Architecture
			return self._boards[self._board]["isa"]
		
		def overlays(self):
			return self._infos['overlay']

		def options(self):
			opts = { ('P_OPTION_%s' % k.upper()): v for k,v in self._infos["options"].items() }
			for k,v in self._boards[self._board]["options"].items():
					opts['P_OPTION_%s' % k.upper()] = v
			opts['P_BOARD']		= self.board()
			opts['P_TOOLCHAIN']	= self.toolchain()
			opts['P_ARCH']		= self.arch()
			opts['P_CHIPSET']	= self.chipset()
			opts['P_CPU']		= self.cpu()
			opts['P_ISA']		= self.isa()
			return opts

		def packages(self):
			return self._infos['packages']

	@classmethod
	def boards(self, name):
		data = json.load(open('%s/%s/profile.conf' % (cookie.layout.profiles(), name)))
		return data['boards']

	@classmethod
	def list(self):
		return os.listdir(cookie.layout.profiles())

	@classmethod
	def get(self, name, board):
		return cookie.profiles.profile(name, board)
