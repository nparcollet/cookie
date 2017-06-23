# PRESENTATION

Cookie is a complete cross compilation environment that is host agnostic and can run on most of the
OS out there. That includes Windows, Mac OS and of course the Linux distributions. It allows to
build firmwares for various platforms.

Cookie focus on Raspberry PI boards, that are widely available out there, but can be easily adapted
to work with other platforms. The different RPI profiles can be used to generate firmwares usable
with the board in the blink of an eye. They serve both as an example to learn how to work with the
environment and a base for customization and to work on more complex creations.

Cookie is not an OS, in the sense of Raspbian or OpenElec. It is not installed directly on your
board and the firmware created with Cookie does not need to have a package manager. Instead, Cookie
is the package manager, and you have full control over what make up the firmware. In this sense it
is similar to buildroot.

Cookie approach result in custom tailored images, that does what they were designed for and are not
cluttered with additionnal functionnalities that you dont need. In addition, the infrastructure
allows for strict version control over the different components, allowing for easy reproductibility
and firmware cohesion.

# PREREQUISITES

Before working with cookie, you need to ensure the necessary dependencies are installed on your
system. Note that these are kept to the bare minimum as to ensure cookie can run on a wide variety
of systems. As of today, the following are required:

- git
- python
- docker

Regarding docker, you must ensure that the cookie root directory is added to the file sharing
preferences of the docker installation. This is because this directory is used as an exchange
area between the host system and the docker image. It also make it easy to work on your host
machine and have changes immediatly available in the build environment.

# INSTALLATION

The installation is pretty straight forward. First you need to clone this repository using the
following command:

	> git clone https://github.com/nparcollet/cookie.git

Once this is done, simply run:

	> /path/to/cloned/repository/bin/cookie setup

Under the hood, the command does the following operations:

	> echo 'export COOKIE="/path/to/cookie"' >> ~/.bashrc
	> echo 'export PATH="$PATH:$COOKIE/bin"' >> ~/.bashrc
	> echo 'export PYTHONPATH="$PYTHONPATH:$COOKIE/python"' >> ~/.bashrc
	> source ~/.bashrc

# QUICKSTART

Let's get to it. Below is a sequence of command that will allow you to generate a firmware and to
run it on a RPI 3 Board

	> cookie bootstrap update
	> cookie target create webserver rpi3b
	> cookie target build
	> cookie target deploy /dev/sdb

The operations might take a while. Once they are complete, take your SDCard, put it on your PI
board, and put the power on. You will see on the screen the IP of the PI board. Access it with
any browser. That it, a functionnal custom made webserver. It comes with a FTP server so that
you can upload content, and support both PHP and MySql.

# DOCUMENTATION

The complete documentation is accessible though this link: [documentation](documentation/README.md)
