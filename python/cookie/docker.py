import os
import shutil
import cookie
import subprocess

class docker:

	@classmethod
	def run(self, args):
		cur = cookie.targets.current()
		tgt = cookie.targets.get(cur) if cur else None
		cmd = ' '.join([
			'/usr/local/bin/docker',
			'run',
			'--interactive',
			'--tty',
			'--rm',
			'--privileged',
			'--cap-add=SYS_ADMIN',
			'--cap-add=MKNOD',
			'--cap-add=SYS_PTRACE',
			'--volume=%s:/opt/cookie' % cookie.layout.root(),
			'-e COOKIE_PROFILE=%s' % tgt.profile() if tgt else '',
			'--mount=source=%s,target=%s' % (tgt.volume(), tgt.path()) if tgt else '',
			'cookie'
		]) + ' ' + args
		return subprocess.call(cmd.split())

	@classmethod
	def console(self):
		cookie.logger.info('Entering interactive console')
		return cookie.docker.run('/bin/bash')

	@classmethod
	def update(self):
		cookie.logger.info('Creating or updating cookie docker image')
		s = cookie.shell()
		(status, out, err) = s.run('docker build -t cookie %s' % cookie.layout.bootstrap())
		if status != 0:
			cookie.logger.abort(' '.join(err))
		else:
			cookie.logger.info('Cookie docker image was updated')


	@classmethod
	def remove(self):
		cookie.logger.info('Removing cookie docker image')
		s = cookie.shell()
		(status, out, err) = s.run('docker rmi -f cookie')
		if status != 0:
			cookie.logger.abort(' '.join(err))
		else:
			cookie.logger.info('Cookie docker image was removed')
