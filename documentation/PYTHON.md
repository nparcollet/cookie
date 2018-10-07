# Using cookie python module

## TODO

## Foreword

The section below is mostly informative. As a normal user, the **cookie** binary is normaly the
entry point to the environment. The binary is a wrapper around the underlying cookie python module
that allow for easy manipulation without knowledge of python. However, it might be of interrest
to understand how things are organized under the hood, either for bugfixing, extending the
framework, or simply out of curiosity.

## Sources

The sources needed to use cookie python module are located under **$(COOKIE)/python/cookie**. This
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

The module is organized in several sub module. Each module is standalone and can be used without.
Some of the submodules allow to create instances, like the targets module, other can be used
directly without an object. The complete list of modules is provided below:

- command
- distfiles
- gitsources
- layout
- logger
- profiles
- shell
- docker

TO DOCUMENT:

- packages
- targets

Each of these modules can be accessed using the **cookie.<module>** route within python.

# Command module

The command module is a template used to easily create command line tools. It is used as a parent of
the **cookie** executable. It is a class that need to be inherited to be useful. It provides basic
methods common to all command line tools, provided that they are properly written. This include:

- **name**: the name of the tool, defined as the filename
- **actions**: retrieve the list of actions the tool provides
- **summary**: retrieve the description of an action
- **help**: display an help menu to the user
- **run**: parse argument and run the command

To create a new command, one simply need to add one or more **do_action** method. Each of these
methods will be identified as an action. Each of them can have a comment at the start of the
function enclosed in a """ """ block. This block will be used as the command summary.

# Distfiles module

The distfiles module is in charge of managing all the remote archives that are used by the cookie
environment. This is mainly made of source archives that are then compiled either for the host part
or for the different targets. This object does not need an instance as it does not have any context
and is always accessed using the **cookie.distfiles** prefix. It provides the following methods:

- **path**: retrieve the location where all archive are stored.
- **fetch**: fetch an archive at the given url an rename it as required.
- **archives**: return the path to an archive given its full name.
- **extract**: extract an archive in the given destination (accept bz2, tgz, zip, xz).
- **list**: list retrieved archives
- **clear**: clear the cache of distfiles

# Gitsources module

The gitsources module is in charge of managing all the remove git repositories that are used by
the cookie environment. This repositories are the core of most packages and contains sources that
are then compiled into binaries within one or more targets. This object does not need an instance
as it does not have any context and is always accessed using the **cookie.gitsources** prefix. It
provides the following methods:

- **path**: retrieve the path where all git repositories are cached.
- **clone**: clone a git repository given an url and a repository name.
- **checkout**: checkout a specific version of a repository in the given directory.
- **remove**: remove a previously cloned repository.
- **clear**: remove all cached repositories

# Layout module

The layout module allow to retrieve the different path on the file system that contains data needed
for the execution of cookie. They provide a safe way to always ensure the correct path is retrieve,
even if the whole system is somehow moved around. To do so, all method of this class make use of
the **COOKIE** environment variable, that defines where the cookie environment is located. This
class can be accessed without an instance using the **cookie.layout** prefix and provided the
following class methods:

- **root**: the root directory of the environment (defined by the COOKIE environment variable)
- **targets**: the directory that contains the different targets of the system
- **target(name)**: the directory of a target given its name
- **profiles**: the directory that contains the different profiles that exist
- **profile(name)**: the directory of a profile given its name
- **packages**: the directory that contains the different package files
- **distfiles**: the directory that contains the remote files
- **distfile(name)**: the path of a given distfile
- **gitsources**: the directory that contains the remote remote repositories
- **gitsource(name)**: the path of a given git repository
- **bootstrap**: the directory that contains information needed to create the bootstrap environment

Note: it is mandatory to use these function to determine pass information to ensure global coherence
over the system.

# Logger module

The logger module allow to display various information to the user using various flags acting as an
indicator of the importance of the message. There is no need to create instances of the Logger class
and it is always accessed directly using the **cookie.logger** prefix. It contains the following
class methods:

- **debug**: debugging information with no impact on the execution flow. Can be disabled
- **info**: important information about the execution flow.
- **error**: an error condition in the execution flow that does not interrupt the process
- **abort**: a fatal error in the execution flow, the process is stopped immediately

Note: it is recommended to avoid using the **abort** method and properly cleanup in the execution
flow once an error is encountered.

# Shell module

The shell module provide a way to conveniently execute shell commands. Objects will automatically
detect if they are run from the host system or from the build environment. This is done by checking
for the presence of COOKIE_ENV environment variable. Shell object are created from the
**cookie.shell** constructor that returns a shell instance. Various configuration methods are
available on the object as listed below:

- **setpath**: update the working directory
- **setenv**: add a new environment variable
- **clearenv**: clear all environment variable
- **loadenv**: load the current environment into the shell one
- **addenv**: add several environment variable from the given dict

Once the configuration is complete, implementers then call the **shell.run(cmd)** function to start
the execution. An exception will be raised in case of error. A successful call to run will return a
tuple with (status, output, error_output). Status will be 0 since exception are raise in case of
errors. output and error_output are 2 array containing the command output that can be used for
further processing.

# Profiles module

The profile module is in charge of managing the different profile of the cookie environment. It is
a static module with 2 class methods accessible throu the **cookie.profiles** prefix:

- **list**: list all profiles
- **get**: access a single profile

When using the **get** method, a profile object is returned providing additional means to control
the profile that was accessed:

- **name**: retrieve the name of the profile
- **path**: retrieve the path to the profile
- **buildenv**: retrieve a dict of the build environment for the profile
- **arch**: retrieve the architecture of a profile, as defined in its env
- **packages**: retrieve the list of package and version that made up a profile

# Targets module

The targets module is in charge of managing the different target of the cookie environment. It is
a static module that can be accessed trough the **cookie.targets** prefix and provides the following
methods:

- **list**: retrieve a list of all existing targets
- **current**: retrieve the name of the currently active target
- **get**: access a single target object
- **delete**: delete a target given its name
- **select**: select a new target as the current one
- **create**: create a new target from the given profile and name

When using the **get** method, a target object is returned providing additional means to control the
target that was accessed:

- **name**: retrieve the name of the target (not the profile name)
- **manifest**: retrieve the target manifest (dict with profile and creation date)
- **profile**: retrieve the name of the profile bound to this target
- **package**: given a selector, retrieve a package object bound to this target
- **add**: given a selector, install a new package in the target
- **remove**: given a package name, uninstall it from the target
- **merge**: merge all package described in the bound profile into the target

# Docker module

The docker module is in charge of handling the interaction between the host system and the docker
image used by the cookie environment. This goes from the setup of this environment to the execution
of command within it. It is a static module that can be accessed with the **cookie.docker** prefix
and provides the following apis:

- **update**: create or update the environment
- **remove**: remove the image, allowing to start fresh if something goes wrong
- **console**: start an interactive console within the environment (changes are not persistant)
- **exec**: execute a command within the environment.

**NOTE**: using **console** or **exec**, any changes that are not within the writable area will be
discarded once the execution is complete. To simplify, only the **/opt/cookie** directory can be
modified in a persistent manner.

# Packages module

TODO
