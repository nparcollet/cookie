#!/usr/bin/python

import os
import hashlib
import sys
import cookie

class sha1:

	@classmethod
	def compute(self, path):
		"""
		Compute the sha1 value of the file at the given path. The result is then returned as an hex
		value.
		"""
		h = hashlib.sha1()
		with open(path, 'rb') as handle:
			chunk = 0
			while chunk != b'':
				chunk = handle.read(1024)
				h.update(chunk)
		return str(h.hexdigest())
