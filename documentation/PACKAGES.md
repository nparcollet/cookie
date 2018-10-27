# Packages

## Overview

Packages are the core of the cookie environment. They are individual piece of information that desribe how
to build components that are to be made part of an image. Packages can be used in various way, however, this
section aim at explaining the internals of packages rather than how packages are used.

## Organization

Each package is actually a makefile. All packages are located in the **{COOKIE}/packages** directory and
must follow a strict naming convention defined as:

    package-name-x.y.z.mk
    
## Selector

Within cookie, packages are identified using package selectors. That is, one can refer to a package using
**package-name**, or with **package-name-x.y.z**. However, independently of the selector, cookie will
resolve it to an actual package name including it's name and version.

**Limitation**: As of today, selectors does not support version limitation, a in "any package named
package-name with a version lower than x".

## Environment

In order to behave properly, the packages expect the environment to be properly defined. This include
having the environment variable setup properly and matching the required toolchain lie **HOST** or **CC**,
and passing additionnal information like the location where packages need to be built or installed. Cookie
will ensure all this, in particular each package Makefile will always be called with the following
information:

    P_WORKDIR: the directory where the build operation take place
    P_DESTDIR: define where the package MUST install the result of a build
    P_SYSROOT: the location of the rootfs where all packages are installed
    P_NPROCS: the number of CPU available for build operations
    P_TOOLCHAIN: the toolchain to use to build the package
    P_ARCH: the architecture to build for

## Identification

At the top of each package, a set of attribute must be defined and help with the identification of
the package. These are listed below:

    P_NAME: the name of the package
    P_VERSION: the version of the package
    P_DESCRIPTION: a short description of the package
    P_LICENCES: a list of licences that apply to this package
    P_ARCHS: the list of architectures this package can be built for
    P_DEPENDS: a list of other package names this package depends on
    P_PROVIDES: a "name" that other package can depends on instead of the actual package name (virtual)

## Rules

After the identification, each package need to define how it is build. This is done using simple
make rules with fixed names and an expected behavior. Those rules are defined below:

- clean: expected to clean the build directory at ${P_WORKDIR}
- fetch: expected to retrieve the sources
- setup: expected to extract and patch the soures
- compile: expected to build the component
- install: expected to install the component in ${P_DESTDIR}
- mkarchive: expected to create an archive from the result of install
- merge: expected to install the archive content in ${P_SYSROOT}
- unmerge: expected to remove the archive content from ${P_SYSROOT}

**Note**: The **clean**, **mkarchive**, **merge** and **unmerge** command are implicit and do
not need to be defined in the package. In fact, doing so might result in a broken package.

## Tools

Cookie provide a set of tool command that are expected to be used in makefile for performing
certain operation. This is requried to ensure a smooth integration within the environment.

**Cookie Fetch**
    This command is to be used in the FETCH rule to retrieve remote archive. It will take care
    of caching the result in ${COOKIE}}/cache for later use, avoiding having to downlad several
    time the same thing.

**Cookie Unpack**
    This command is to be used in the SETUP rule to unpack an archive. It is used in conjunction
    with cookie fetch since it will only look in the cache.

**Cookie Git**
    This command is to be used in the FETCH phase to clone a repository (with cookie git clone)
    and in the SETUP phase (with cookie git checkout) to checkout the proper version. It is
    similar to fetch/unpack in the sense that repositories are cached locally.

**Cookie Import**
    This command is to be used when importing configuration files from the profile.

**Cookie Patch**
    This command is to be used when patching sources using a patch located in the profile.

