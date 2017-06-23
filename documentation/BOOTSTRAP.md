# Overview

Bootstrap is the name of the cross compilation environment that cookie uses in order to perform the
various build operations leading to the generation of images for the different devices that are
supported devices. It is basically a custom made linux distribution that contains all the
toolchains and other build tools that are needed. This environment is built using docker, and is
completly independent from the host system. Using this approach allow for cookie to run on must
work station, be it Linux, Mac or Window.

# Docker configuration

The environment is created and maintained using the cookie program. To do so, a collection of files
are located in the **bootstrap** directory. It contains rules and packages, that are used to create
a docker image. Below is a summary of these files:

- Dockerfile: the docker image receipe
- packages.deb: a collection of extra package specially created for cookie
- .bashrc: customization of the image shell

# Creating / Updating the environment

Creating, as well as updating, is done using the cookie update command. This first time it is
called the docker image will be created. Subsequent calls will lead to an update if the bootstrap
configuration was change. The syntax is straightforward:

	cookie bootstrap update

# Removing the environment

It is possible to remove the docker image if it become corrupted and beyond repair using the
following cookie command:

	cooke bootstrap remove

# Interactive shell

In order to avoid conflict between the host system and the build environment, most operations when
working with cookie are done from an interactive shell, which is simply a bash prompt that is
started in the docker image.

It is important to keep in mind that any modification made to the environment in this context are
not persistant. As soon as the shell exit, any modification made previously is reverted. The
exception to this rule concern everythin located un **/opt/cookie**, which is a shared directory
between the host and the build environment.

This allow to keep a clean host while working on targets as they are located in this persistant
shared directory. It also allows to modify packages or other cookie files from any editor on the
host and have changes reflected immediatly in the shell.

Access to this shell is done using the following command:

	cookie shell

# Adding standard packages

The docker image used by cookie is based on debian. As such, they use **dpkg** as there package
manager. Adding new standard packages is therefore quite straight forward. The **Dockerfile** that
is located in the **bootstrap** directory need to be modified to add the new standard packages.
There is no need to update the apt sources first, as this is already part of the image generation
rules. To add a new package, a new line need to be added using the following syntax:

	RUN apt-get install -y --no-install-recommends <package_name>

# Adding custom packages

In the event the debian image that cookie uses does not have a particular package needed in the
environment, it is still possible to add it, eventhou it is a little more complex. The basic idea
is to use cookie packages, build them, create a debian package from the result, and install them in
the environment using a simple **dpkg** command. This ensure that the same package manager is used
for both standard and custom packages, thus leaving dependency managment and conflict handling to
the system. The following guide explain how to do this:

(Add a Custom Package to the Host Environment)[documentation/ADDHOSTPKG.md]

# Exporting the environment

For day to day operations, the previously described workflow is sufficiant. However, when reaching
important milestone in the development of a project, it is important to be able to take a picture
of the environment and to save it, in order to reuse it to build tagged versions profiles. These
snapshots ensure that the creation of an image from a profile defined several month ago is using
the environment defined at this time, and not the head version of this environment. It is done
simply using the following cookie command:

	cookie bootstrap export <X.Y.Z>
