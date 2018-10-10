# PRESENTATION

Cookie is a complete cross compilation environment that is host agnostic and can run on most of the
OS out there. That includes Windows, Mac OS and of course the Linux distributions. It allows to
build firmwares for various platforms.

Cookie focus on Raspberry PI boards, that are widely available out there, but can be easily adapted
to work with other platforms. The different RPI profiles can be used to generate firmwares usable
with the board in the blink of an eye. They serve both as an example to learn how to work with the
environment and a base for customization to work on more complex creations.

Cookie is not an OS, in the sense of Raspbian or OpenElec. It is not installed directly on your
board and the firmware created with Cookie does not need to have a package manager. Instead, Cookie
is the package manager, and you have full control over what make up the firmware. In this sense it
is similar to Buildroot.

Cookie approach result in custom tailored images, that does what they were designed for and are not
cluttered with additional functionalities that you don't need. In addition, the infrastructure
allows for strict version control over the different components, allowing for easy reproductibility
and firmware cohesion.

To summarize, with cookie, you choose a set of packages you want to install, you create the image
that will contains all the binaries and libraries that are needed, and you deploy this image on a
board that can then be started straight away without any additional steps on the board itself.

# PREREQUISITES

Before working with cookie, you need to ensure the necessary dependencies are installed on your
system. Note that these are kept to the bare minimum as to ensure cookie can run on a wide variety
of systems. As of today, the following are required:

- git
- python
- docker

# SETUP

The installation is pretty straight forward. First you need to clone this repository using the
following command:

	> git clone https://github.com/nparcollet/cookie.git

Secondly, some adjustment are required to your console environment:

	- Add **COOKIE=/path/to/cookie** to the environment
	- Add **$COOKIE/bin** to the **PATH** variable of the environment
	- Add **PYTHONPATH=$COOKIE/python** to the environment

Once this is done, cookie is fully functional and can be used from the console of your system.

# BOOTSTRAP

Cookie is now installed on your host environment. It does not matter whether it is Linux, Windows or
MacOS. However, to create images for the raspberry we will need a dedicated environment that will be
the same independently of your host. To do this we use Docker and a custom made image named
**cookie**. To trigger the creation of this image, one simply need to run the following command:

	> cookie bootstrap update

Under the hood this will setup the new image, which is basically a Debian distribution with all the
tools needed to work with a raspberry. Running this command might take a while (up to one hour). It
is a one time process thou. Once complete, you will have a brand new OS within your host,
specifically tailored for creating Pi images. You can actually access this environment manually
using the following command:

	> cookie shell

Cookie itself is accessible within this environment, and is bound with the host system as the
/opt/cookie directory. This shell is a complete Linux system that will behave as expected
by any Linux developer.

**IMPORTANT**: Accessing this environment is normally done for debugging purpose, as you wont be
creating a PI image manually from there. In particular, changes you make when accessing the
environment through the shell will be discarded once you exit it. This guarantee that the system
will remain sanitized, and one can freely experiment there.

# QUICKSTART

Let's get to it. Below is a sequence of command that will allow you to generate a firmware and to
install it on an sdcard:

> cookie create rpi3b webserver
> cookie merge
> cookie deploy /dev/sdb

After that, simply put the sdcard in your board and you are good to go. This is of course very
minimalist and just to give you a taste of what can be done. A more complete documentation is
available below and explain the ins and outs of the cookie environment.

# GUIDES

[Command Line Reference](docs/CMDLINE.md)
[Advanced usage information](docs/CMDLINE.md)
[Flashing an image to the board](docs/FLASHING.md)
[Managing and customizing the kernel](docs/KERNEL.md)
[Working with profiles](docs/PROFILES.md)
[The rules to create and use packages](docs/PACKAGES.md)
[Understanding cookie python module](docs/PYTHON.md)
[Targets ins and outs](docs/TARGETS.md)










# RECIPES

With a working environment at hands, that real work can now start. As stated previously, you won't
need to do anything manually in the shell in order to generate PI images. Instead, we used what is
called cookie recipes. This repository include several ready made recipes that can be used for
testing and get a taste of what can be done. Each recipe contains 2 parts:

- A list of packages that need to be installed
- Hardware specific packages and configuration

Most recipes will include basic packages that are required in any Linux system. That includes the
kernel, the boot scripts, the system drivers and so one. On top of this, one will normally just add
additional application that is expected to run, for instance a web server.

Recipes are stored in the **profile** directory of this repository. This is also where a user can
create new ones. Profiles can be listed with the following command:

	> cookie profile list

# QUICKSTART


	> cookie target create webserver rpi3b
	> cookie target build
	> cookie target deploy /dev/sdb

The operations might take a while. Once they are complete, take your SDCard, put it on your PI
board, and put the power on. You will see on the screen the IP of the PI board. Access it with
any browser. That it, a functionnal custom made webserver. It comes with a FTP server so that
you can upload content, and support both PHP and MySql.

# DOCUMENTATION

The complete documentation is accessible though this link: [documentation](documentation/README.md)
