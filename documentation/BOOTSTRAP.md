# Overview

The build environment, or Bootstrap is the name of the cross compilation environment that cookie
uses in order to perform the various build operations leading to the generation of images for the
different devices that are supported. It is basically a custom made linux distribution that contains
the build tools that are needed. This environment is created using **Docker**, and is completly
independent from the host system. Using this approach allow for cookie to run on must work station,
be it Linux, Mac or Window.

# Docker configuration

This environment is created and maintained using the cookie program. To do so, a collection of files
are located in the **bootstrap** directory. It contains rules and configuration files used to create
a docker image. The most important file in this directory is the actual **Dockerfile** that defines
everything that need to be installed in the environment.

# Creating / Updating the environment

Creating, as well as updating, is done automatically using the cookie update command. This first time
it is called the docker image will be created. Subsequent calls will lead to an update if the bootstrap
configuration was changed. Note that the environment rarely update as most packages out there use a
small set of well known standard tools. In any case, the build environment is created or updated with
the following command:

	> cookie bootstrap update

# Removing the environment

It is possible to remove the docker image if it become corrupted and beyond repair using the
following cookie command:

	> cookie bootstrap remove

# Interactive shell
As stated previously, the build environment is a complete linux system. The main application of
this system is a standard **bash** shell, and it can be accessed if one so desire so with the
command below:

    > cookie shell


It is important to keep in mind that any modification made to the environment in this context are
not persistant. As soon as the shell exit, any modification made previously is reverted. This allow
to keep a clean build environment while retaining the ability to debug or to simply try out things.

As an exception to this rule, there are two locations where change will remain persistant:

- /opt/cookie: this directory is bound to the host cookie directory
- /opt/target: an internal volume used for cookie operations

The purpose of these 2 directories will be detailed in another document.

# Environment Variables

In addition to the tools that are provided by the build environment, a set of variable are
predefined. These variables are used to link the environment with the target being build. For
instance the **HOST** variable is set to the cross compilation toolchain that is needed by the
profile. These environment variable are used by cookie itself when doing build operation, and
also set when accessing the **shell**.

# Extending the environment

The docker image used by cookie is based on debian. As such, they use **dpkg** as their package
manager. Adding new standard packages is therefore quite straight forward. The **Dockerfile** that
is located in the **bootstrap** directory need to be modified to add the new standard packages.
There is no need to update the apt sources first, as this is already part of the image generation
rules. To add a new package, a new line need to be added using the following syntax:

	RUN apt-get install -y --no-install-recommends <package_name>

# Toolchain

The toolchain itself **is not part** of the base compilation environment. Afaik, the toolchain that
is needed depends on the targetted hardware and thus we can't know in advance what toolchain to use.
The environment being read only, another mechanism is used to manage toolchains.
