import os
import cookie

class gitsources:

	"""
	TODO: Dont pull if already up to date
	TODO: Sparse Checkout ?
	"""

	def __init__(self):
		pass

	def clone(self, url, reponame):
		try:
			shell = cookie.shell()
			path = '%s/%s' % (cookie.layout.gitsources(), reponame)
			if os.path.isdir(path):
				cookie.logger.debug('repository %s already exists' % reponame)
			else:
				cookie.logger.debug('cloning repository %s from %s' % (reponame, url))
				cookie.shell().run('git clone --bare %s %s' % (url, path))
		except Exception, e:
			raise Exception('could not clone or update %s: %s' % (reponame, e.message))

	def checkout(self, reponame, revision, destdir):
		try:
			shell = cookie.shell()
			local = '%s/%s' % (cookie.layout.gitsources(), reponame)
			shell.run('mkdir -p %s' % destdir)
			try:
				(status, out, err) = shell.run('cd %s && git cat-file -t %s' % (local, revision))
				cookie.logger.debug('revision is present in the repository')
			except Exception, e:
				cookie.logger.debug('revision not found, updating first')
				cookie.shell().run('cd %s && git fetch -v' % local)
			cookie.logger.debug('cloning from the local repository')
			shell.run('git clone --shared --no-checkout %s %s' % (local, destdir))
			cookie.logger.debug('resetting to revision %s' % revision)
			shell.run('cd %s && git reset --hard %s' % (destdir, revision))
		except Exception, e:
			raise Exception('could not checkout repositoriy %s: %s' % (reponame, e.message))

	def remove(self, name):
		raise Exception('not implemented')
