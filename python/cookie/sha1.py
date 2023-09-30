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


	@classmethod
	def load(self, path):
		"""
		Load the sha1 value stored in the file at the given path
		"""
		sha1 = None
		if os.path.isfile(path):
			with open(path, 'r') as handle:
				sha1 = handle.read().strip()
				handle.close()
		return sha1

	@classmethod
	def save(self, sha1, path):
		"""
		Save the sha1 value in the file at the given path
		"""
		with open(path, 'w') as handle:
			handle.write(sha1)
			handle.close()
