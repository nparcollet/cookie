import os
import shutil
import cookie
import subprocess

class docker:

	@classmethod
	def run(self, args):
		cur = cookie.targets.current()
		tgt = cookie.targets.get(cur) if cur else None
		prf = cookie.profiles.get(tgt.profile(), tgt.board()) if tgt else None
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
			'-e COOKIE_TOOLCHAIN=%s' % prf.toolchain() if prf else '',
			'-e COOKIE_BOARD=%s' % tgt.board() if tgt else '',
			'--mount=source=%s,target=%s' % (tgt.volume(), tgt.path()) if tgt else '',
			'cookie'
		]) + ' ' + args
		subprocess.check_call(cmd.split())

	@classmethod
	def console(self):
		cookie.logger.info('Entering interactive console')
		cookie.docker.run('/bin/bash')

	@classmethod
	def update(self):
		cookie.logger.info('Creating or updating cookie docker image')
		cookie.shell().run('docker build -t cookie %s' % cookie.layout.bootstrap())

	@classmethod
	def remove(self):
		cookie.logger.info('Removing cookie docker image')
		cookie.shell().run('docker rmi -f cookie')
