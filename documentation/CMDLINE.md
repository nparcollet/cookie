# USAGE

## Operational Workflow

Let start with a simple analogy that I like to make. Creating a firmware for a board is similar to
cooking. It seems complicated when you look at the result, but in the end it is just a matter of
following a recipe.

In the embedded world, it is the same. You define a profile (a recipe), that contains the list of
build tools (cutting board, knifes, pans, ...) and packages (ingredients) that are needed. You
bring all of these together in a target (kitchen) and build them (you cook). Once everything is
built you generate one or more images (plates) that can be deployed on the board.

## One program to rules them all

In order to achieve all of this, Cookie revolve around a single binary called **cookie** that is
available in the bin directory of your cookie installation. If you properly followed the setup
instructions, it should accessible from your terminal independently of your current directory.
Cookie is a command line tool, and allow easily manage the creation of a new image ready to be
deployed on your target target device. This goes from configuring an isolated cross compilation
build environment to generating kernel images or boot loader binaries. In order to do so, cookie
provide a set of command that are described here after. This section is organized logically so
that you will have a good understanding of the process of creating a binary for your PI device.

## Cross Compilation Environment

	> cookie bootstrap [update|delete]

In order to be platform agnostic, Cookie rely on a separated and isolated environment to perform
most of the operations. This environment is created using **docker** and a **debian** image,
completed with several packages related to building and cross compiling. The maintainance of this
environment is done using the **cookie bootstrap** command. It is a command intended to run on your
host machine (on linux, windows or mac)

After the installation of cookie, it is necessary to generate this docker image. It is done simply
using the **update** command. In the event some changes are required, for instance adding a package
necessary to build something, one need to modify the configuration files located in the
**${COOKIE}/bootstrap/DockerFile** and rerun the same command.

If for any reason your image become unstable or broken, you will need to recreate it from scratch.
To do soo you will to delete it with the **delete** action before calling **update** again.

Finaly, you might have noticed that there are no way to version the different packages in the
docker image. This is a limitation due to the fact that we use a standard debian distribution as a
base. For day to day development and prototyping this is fine. However, if you are working on a
project with several releases, this can become problematic if you ever want to rebuild an old
version several month later. The solution is to store the docker image used to generate
important releases so that they can be reused in the event of a rebuild.



## Custom Host Packages

	> cookie dpkg [add name version|rm name]

The way docker is design allow to easily install standard debian packages in the cross compilation
environment, however, for more advance control it can become problematic. For instance, some
packages are not available in debian. This is the case of several toolchains needed by the
environment.

To circumvey this limitation, cookie provide the **dpkg** command. This function can be run either
from the Dockerfile using **RUN cookie dpkg ...**, or from the cross compilation shell.

It can be used to compile standard Cookie packages, pack them as a debian (.deb) package, and
install it in the cross compile environment. Doing so allow to have custom packages properly
integrated with **dpkg**, the debian package manager. This operation is done by using the
**dpkg add package_name package_version** function.

Packages installed this way in the image have there name prefixed with **cookie-** to avoid
collisions with official debian packages. In addition, such packages can be removed using
**cookie dpkg remove package_name**. Under the hood this will simply use **apt-get** since the
package was installed as a standard debian element.

## Profiles Managment

## Targets Managment

## Packages Repository

## Cross Compilation Shell

	> cookie shell

Having you docker image ready, you have the possibility to start a shell in it and start doing
experiments using the **cookie shell** command. Doing so, you will have access to the build
environment as seen by the cookie. You will be able to perform any operation that cookie does,
and in the same condition they are executed.

When you enter the shell you will notice that you have a **/opt/cookie** directory. This directory
is actual bound to your cookie directory on your host. It means you could modify package on
your host, and the changes will be directly reflected in the shell.

This is a very important tool that has many purpose. It can be used to test and fix the compilation
of a package, to modify your target manually before commiting the changes to the profile, etc ...

One important thing to note is that aside from the shared directory, any changes you make in the
environment  are temporary, that is, once you leave the shell, these change will be reverted.

## Other build commands

	> cookie fetch url

The **fetch** command allow to retrieve an archive from internet. Instead of blindly downloading
it like wget or curl would, the cookie version of the fetch command maintain a cache of all
resources that were retrieve. This is very importat as when working on firmware generation, you
will often find yourself working on the same package, and thus downloading it each time would be
a waste of time. The fetch command is used in cookie packages to retrieve archives when they
need some.

	> cookie extract archive destination

Once an archive is fetched, it might be hard to find where it is since the cache managment is an
internal feature. As such, cookie offer another command called **extract** that allow to
transparently find the archive location and unpack it un the requested folder. In addition, the
extract command is able to transparently extract different type of archives (zip, tar, xz, ...).
This command is also used on cookie packages.

## Key Concepts

- Host Agnostic
- Minimal Dependencies
- Isolated Cross Compilation Environment
- Toolchains Managment
- Cross Compilation Shell
- Profiles Based Firmware Generation
- Targets and Package Versions Managment
- Snapshoting of Profiles
- Open Source
- Hardened firmwares (Coming Soon)



# CONTENT

## Bin

	Directory containing the **cookie** binary. This command line tool is the entry point to the
	framework and allow to perform all the operations. The binary is available both on the host (for
	managing the bootstrap environment and launcher the shell) and in the docker image (for performing
	various build operations). It is a python program, making it platform agnostic.

## Bootstrap

	A directory that contains a set of scripts and files that are used to generate the actual cookie
	build environment. The result of the bootstrap execution is a docker image that is installed on
	the host and allow to perform further target creation operations.

## Cache

	Directory containins all the remote content needed by the environment to generate target images. It
	allow to cache the following types of resources:

	- Distfiles (archives)
	- Git Repositories
	- HG Repositories
	- SVN Repositories

## Packages

	Directory that contains all the packages that cookie can use to generate targets. Package are
	organized in different overlays. Each overlay contains a list of package name, which in turn
	contains the makefile describing how a package need to be built.

## Python

	Cookie comes along with a set of python scripts that made up the core of this environment.

## Profiles

## Targets

	A directory that contains all the target that were instanciated from profiles. These targets
	comes from profiles, and are built while in the cookie bootstrap environment. From the host
	point of view, the meaning full part contains the different images that were generated and can
	be installed on the targeted devices. There is one directory per target, which contains the
	following subfolders:

	- rootfs
	- redist
	- images
	- staging
