# PROFILES

## Overview

As an analogy, a Profile is like a recipe. It contains the ingredients and methodology to prepare a
new dish. In technical term, it means that it defines a list of configuration options and packages
and allow to build a new image that can be installed on a board.

## Boards

Each profile actually represent a board we want to build for. For instance, there is the rpi3b
profile that is used to create images for Raspberry 3B boards. The cookie environment is focus on
raspberry board, but nothing prevent a user to create new profile for other boards. Each board have
specificities that need to be defined in its profile.

## Toolchain

In particular, the profile will determine the toolchain that need to be used for the board it
represents. It is built using crosstool-ng and the configuration available in the following file:

	[profile]/crosstool-ng.config

Building a toolchain is a long process, however cookie will cache the result of building a toolchain
for later use. That means that reusing a profile a second time will not trigger the recompilation of
its toolchain. The toolchain itself is installed in **/opt/target/toolchain**.

**Note**: The environment will detect changes to the toolchain config file and might recreate it
when this happens.

## Configuration

Each profile, or board, need to contains a proper configuration file that defines various hardware
related parameter. For instance, the target architecture and compiler name. All this information is
contained in a specific file that defines various environment variable:

	[profile]/build.env

## Application

For each board, it is possible to further customize the image by deciding what application need to
be installed. For instance we might want to install a Web Server on a rpi3b board. Each application
is made of a list of packages that need to be installed. These recipes are also stored in the
profile:

	[profile]/webserver.conf
	[profile]/minimal.conf

## Customization

Some packages will required specific configuration files or patches that can also be added inside
the profile directory. For instance that kernel configuration. These files are expected to be named
with a prefix being the name of the package that need it. For instance:

	[profile]/kernel.config
	[profile]/kernel.patch

Within package files, the **cookie load_config** and **cookie patch** commands can be used to use
them.

## Listing

The following command allow to list all existing profile along with the application recipes that
exists:

	# cookie profiles
