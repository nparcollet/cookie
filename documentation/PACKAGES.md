# Generalities


## Principle

- Using the cookie target/host to work on packages
- Preload the correct environment (host or target)
- Create the package object from the selector
- Run the package command (one of "clean, fetch, setup, compile, install, merge, unmerge, add")

## Foreword

## Organization

The packages of the cookie environment are located in the **$COOKIE/packages** directory. This
directory contains several sub directories each representing a group of package. Each group then
contains one directory per package. Each package is defined by a Makefile and can have several
versions.

## Content

## Usage

Packages can be used in two different way. The most natural way is to use the cookie **host** and
**target** commands for transparently work on packages. Doing so will ensure that the environment
is properly setup depending how the operation being done and is the recommended approach when
possible. It is also possible to use the package makefile directly, but in this case the
environment first need to be configured manually. Working on package manually is useful during the
package creation phase, or when debugging/experimenting on a package.

## Environment

In order to behave properly, the packages expect the environment to be properly defined. When the
cookie command line is used, this is automatically handled. However when using the package Makefile
directly, the user as the responsibility to make sure it is properly configured. This is done using
2 different env file that need to be source accordingly

	/opt/cookie/profiles/<name>/build.env
	When building package for targets, it is important to first source the profile build
	environment in order to set the different build options like the compiler prefix. This is
	mutualy exclusive with the host.env defined below.

	/opt/cookie/targets/<name>/target.env
	Each target defines several path that are needed to know where to build and install packages
	within the filesystem. These path can be source from the target.env file. They include for
	instance the rootfs location, where to put debian packages, and where to perform build
	operations when working on packages. This is mutually exclusive ot the host.env defiend below.

	/root/host.env
	When building package for the host, it is important to first source the host environment in
	order to set the different build options like the compiler prefix and the different location
	in the filesystem involved in the operation. Unlike target environment, a single file allow
	to properly setup for host build. This is exclusive with the build.env and target.env defined
	previously

# Package variables

## Defined in the package Makefile

Package Makefile contains a list of defines used to further identify the package. Some of these
are mandatory, other are recommended depending on how the package is created.

	P_NAME [Mandatory]
	This variable must be equal to the name of the package. It should be derived from the package
	selector, but might be different in certain cases. For instance, a package matching the
	selector overlay/foo-1.0 will have a P_NAME set to foo.

	P_VERSION [Mandatory]
	This variable must be equal to the version of the package. It must be derived from the package
	selector. For instance, a package matching the selector overlay/foo-1.0 will have a P_VERSION
	set to 1.0.

	P_DEPENDS [Mandatory]
	A space separated list of other package name that this package depends on in order to build or
	run properly. This list can be empty. It is considered that all packages depend on the libc
	package, thus this dependency does not need to be added.

	P_DESCRIPTION [Mandatory]
	A User Readable string that briefly describe the package purpose. For instance, what a library
	provides, or what a program does.

	P_ARCHS [Mandatory]
	A space separated list of architectures that this package can be built for. Valid values includes
	x86, amd64, arm, mips.

	P_OPTIONS [Mandatory]
	A space separated list of options that can be used to build this package. The name of the
	options depends on the package itself.

	P_LICENCES [Mandatory]
	A space separated list of licences that apply to the package. This allow for exclusion of some
	packages when a profile declare what can of licences it can accept or not. This is important
	for legal issues, ie, if cookie is used as a commercial build environment.

	P_SRCDIR [Mandatory]
	The subdirectory, relative to the work directory, where the source that will be compiled need
	to be made available. Convention expect it to be set to $(P_WORKDIR)/srcdir

	P_STAGING [Mandatory]
	The subdirectory, relative to the work directory, where the source are to be installed once
	they have been built. Convention expect it to be set to $(P_WORKDIR)/staging

	P_URL
	An url that point to a remote archive containing the sources that are used to build the
	package. It should be used by all packages that work on archives.

	P_GITURL
	An url that point to a remote git repository containing the sources that are used to build the
	package. It should be used by all packages that work on git repositories.

	P_GITREV
	A git revision indicating the exact commit to use when working on a git repository. It should
	be used by all packages that work on git repositories.

## Passed over when running make

In order to be complete, some environment is set when calling make on the package Makefile. Some of
these comes from the target build environment (or host), some are computed automatically by cookie.

	CC, GCC, ...
	All standard compilation enviromnent is set according to the profile the package is built for
	when make is called

	ARCH
	The arch to build the package for. The is set according to the profile the package is built for
	when make is called.

	PKG_CONFIG_PATH / PKG_CONFIG_SYSROOT
	Package Config environment is set to match the current build environment, be it the host or a
	specific target

	MAKEOPTS
	A variable that contains extra option that are generally passed to make when using the
	**compile** command of packages. It is mainly used for handling the **-jX** option in order to
	optimize build times.

	WORKDIR
	The root directory where build operation will take place. This is computed and set
	automatically by cookie before calling make.

# Package rules

## make check

The check command role is to verify all is ok before doing any further operation. This include for
instance checking all dependencies of the package are properly installed, or that the environment
is properly setup. Cookie provide several helper command to check this:

- cookie check depends <pname> >= <pversion>: for dependency check
- cookie check arch <parch>: to check the architecture is supported
- cookie check env: to check the environment is valid

Package must at least have the following defined:

	check:
		cookie check env
		cookie check arch $(P_ARCH) $(P_ARCHS)

## make clean

The clean command role is to remove any build artifact from the work directory of the package so
that new operation wont be impacted by those. Most packages use a clean rule defined as follow:

	clean:
		[ -d $(P_WORKDIR) ] && rm -rf $(P_WORKDIR)

## make fetch

The goal of the fetch command is to retrieve any resource that is needed in order to build the
package. For instance, downloading archives or clone repository. The step can be accelerated by
using the cookie cache. In order for the cache to be used, specific command need to be used to
fetch such content:

- cookie fetch: for downloading archives
- cookie git clone: for cloning git repositories

## make setup

Custom rule whose goal is to prepare the package for building. The rule will basically copy the
resources that where fecthed in the $(P_SRCDIR) directory.

## make compile

Custom rule whose goal is to compile the package. This rule expect the sources to be located in the
$(P_SRCDIR) directory.

## make install

Custom rule whose goal is to install the package once it has been built. The package is expected
to install all the content in the $(P_STAGING) directory so that other operations can be performed.

## make mkdeb

The mkdeb rule is used in order to create a .deb package from the containt of the staging directory
after a package has been installed. All package uses the same rule as defined below:

## make merge

The action of merge consist in installing the package in the actual rootfs of the target being
worked on. It is done simply by using the debian package that was previously created. All packages
use the same rule as defined below:

	merge:
		dpkg --root=$(P_ROOTFS) --force-architecture -i $(P_DEBIAN)/$(P_NAME)-$(P_VERSION).deb

## make unmerge

Similarly to the merge action, unmerge allow to remove a package from the rootfs of the target that
is being worked on. Again, all packages use the same rule as defined below:

	unmerge:
		dpkg --root=$(P_ROOTFS) -P $(P_NAME)
