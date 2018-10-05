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
- logger
- layout
- gitsources

TO DOCUMENT:

- packages
- profiles
- shell
- targets

Each of these modules can be accessed using the **cookie.<module>** route within python.

# Roadmap

Before describing all the module, below is a list of changes that are to be expected on these
different modules:

- **gitsources**: Dont pull if already up to date. Do a sparse Checkout?

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

# Packages module

TODO

# Profiles module

TODO

# Shell module

TODO

# Targets module

TODO
