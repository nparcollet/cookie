# Using cookie python module

## Foreword

The section below is mostly informative. As a normal user, the **cookie** binary is normaly the
entry point to the environment. The binary is a wrapper around the underlying cookie python module
that allow for easy manipulation without knowledge of python. However, it might be of interrest
to understand how things are organized under the hood, either for bugfixing, extending the
framework, or simply out of curiosity.

## Sources

The sources needed to use cookie python module are located under $(COOKIE)/python/cookie. This
directory contains a list of files that made up the framework. In order to use them within python,
it is required to add this location to the ones python look at when being loaded. This can be done
easily using the **PYTHONPATH** environment variable. Note that this is automatically setup when
using the **cookie shell** command. Otherwise, on the host the following command can be added to
the shell startup script:

	export PYTHONPATH=/path/to/cookie/python

## Python version

As of the time of writing of this document, cookie python environment run with python **2.7.9**. It
has not been tested with python 3, but should behave similarly in such environment.

## Importing

Before being usable, the cookie python module need to be made available to the python interpreter
using the below simple command:

	import cookie

## Organization

The module is organized in several sub module. Each module is standalone and can be used without
and instance. Some of the submodules allow to create instances, like the targets module. The
complete list of modules is provided below:

- targets
- profiles
- gitsources
- distfiles
- layout
- logger
- bootstrap
- shell

Each of these modules can be accessed using the **cookie.<module>** route.

# In depth modules description

## Targets module

As its name says, this module allow to manipulate targets. It is accessible using the following
route:

	cookie.targets

The base API of the module allow to manage the targets currently available in the cookie
environment using several functions:

- list: retrieve a list of all the existing targets
- current: retrieve the name of the target that is currently active
- get: retrieve a target object, for target specific operations
- delete: delete a target a select a new one as current
- create: create a new target given a profile name
- select: choose which target is currently active

Using the **get** function, it is possible to access a target object, which allow for further
operations on a single target. These operations are described below:

- add: build and install a new package on the target
- remove: remove a package from the target
- packages: list all packages currently installed on the target


