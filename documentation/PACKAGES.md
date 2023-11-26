# Packages

## Overview

Packages are the core of the cookie environment. They are individual piece of information that desribe how
to build components that are to be made part of an image. Packages can be used in various way, however, this
section aim at explaining the internals of packages rather than how packages are used.

## Organization

Each package is actually a makefile. All packages are located in the **{COOKIE}/packages** directory and
must follow a strict naming convention defined as:

    package-name-x.y.z.mk
    
## Package Selector

Within cookie, packages are identified using package selectors. That is, one can refer to a package using
**package-name**, or with **package-name-x.y.z**. However, independently of the selector, cookie will
resolve it to an actual package name including it's name and version.

**Limitation**: As of today, selectors does not support version limitation, a in "any package named
package-name with a version lower than x".

## Searching Packages

Using a package selector and the search command, one can list the existing version for a given
package as follow:

    > cookie search package_selector

**Note**: Because selector does not currently handle version comparaison, the usefullness of this
command is limited.

## Building a package

Each package need to define how it is built. This is done using simple make rules with fixed names
and an expected behavior. Some of those rules are common to all packages and does not need to be
written in the package file, some are required. There are listed below:

**clean (auto)**: expected to clean the build directory at ${P_WORKDIR}
**fetch**: expected to retrieve the sources, also automatically import extra files in P_FILESDIR
**setup**: expected to extract and patch the soures
**compile**: expected to build the component
**install**: expected to install the component in ${P_DESTDIR}
**mkarchive (auto)**: expected to create an archive from the result of install
**merge (auto)**: expected to install the archive content in ${P_SYSROOT}
**unmerge (auto)**: expected to remove the archive content from ${P_SYSROOT}

Within the environment, it is possible to call these rules individually using the build command,
given that one understand that it might fail because previous operation where not performed. In
any case, executing the operation in this way ensure that it is done with the same context as if
the package was installed automatically, and is very usefull for debugging:

    > cookie build package_selector rule

## Package Dependencies

The dependencies of a package are listed in the P_DEPENDS field of the Makefile. It is currently
only used when calling the merge command and will check that other packages are present before
adding the new one. The depends can work in conjunction with the P_PROVIDES field that packages
can define. This is usefull when having custom packages installing standard component we wish
to depend on. For instance, let's image we have a package P the depends on kernel, but that our
kernel package is named my-kernel. The latest simply needs to add a P_PROVIDES=kernel to ensure
dependencies can be properly checked. From the console, one can check the dependencies of a
package using the following command:

    > cookie depends package_selector

## Build Environment

In order to behave properly, the packages expect the environment to be properly defined. This include
having the environment variable setup properly and matching the required toolchain lie **HOST** or **CC**,
and passing additionnal information like the location where packages need to be built or installed. Cookie
will ensure all this, in particular each package Makefile will always be called with the following
information:

    P_WORKDIR: the directory where the build operation take place
    P_DESTDIR: define where the package MUST install the result of a build
    P_SYSROOT: the location of the rootfs where all packages are installed
    P_FILESDIR: the location of additionnal package configuration files
    P_NPROCS: the number of CPU available for build operations
    P_TOOLCHAIN: the toolchain to use to build the package
    P_ARCH: the architecture to build for
    
## Identification

In addition to the Makefile rules, each package is required to define a set of information that aim at
identifying the package properly. They are listed below:

    P_NAME: the name of the package
    P_VERSION: the version of the package
    P_DESCRIPTION: a short description of the package
    P_LICENCES: a list of licences that apply to this package
    P_ARCHS: the list of architectures this package can be built for
    P_DEPENDS: a list of other package names this package depends on
    P_PROVIDES: a "name" that other package can depends on instead of the actual package name (virtual)
    P_FILES: a list of extra files that are needed

## Working with source archives

Cookie provide a set of tool command that must be used in package **Makefile** in order to perform
source archives related operations. This is to ensure a smooth integration within the environment.

When downloading an archive, the following command need to be used, as to ensure the package is
integrated with the cache mechanism of cookie:

    > cookie fetch [url] [archive_name]

Once the archive is downlaoded, it is to be extracted with:

    > cookie unpack [archive_name] [destdir]

## Working with git repositories

Cookie provide a set of tool command that must be used in package **Makefile** in order to perform
git repositories related operations. This is to ensure a smooth integration within the environment.

When cloning a repository, the following command need to be used, as to ensure the repository
is integrated with the cache mechanism of cookie:

    > cookie git clone [url] [repository_name]

Once clone, the required version can be checked out with:

    > cookie git checkout [repository_name] [destdir]

## Configuration files

A package may rely on additionnal files located in the profile directory. These need to be
defined using the **P_FILES** variable. This variable contains one or more files that the
packages will need. They will be copied in the **P_FILESDIR** directory as part of the build
process and can be accessed there from the Makefile.

**Note**: Each file in the P_FILES variable may be suffixed with a **?**, indicating that the
package can build with or without the file, makjing it enterily optional.

## Dependencies managment

Within packages, the dependencies are managed throu the **P_DEPENDS** variable. The following
are guideline to ensure smooth integration:

* A package that build sources and does not have any apparent dependencies must depends on **libc** and **kernel**
* A package that is not build may have en empty list of dependencies
* A package that has dependencies to other built packages does not need to depend on  **libc** and **kernel**
* **libc** and **kernel** are the only build package that does not need to depend on anything

Following these guideline will ensure that when merging a target, no dependencies issues will occurs

## Package provider

Sometime, a package will be specific to a particular profile but will result in a common package. The
best example of this is the **kernel**. The kernel package is a wellknown dependency from other
packages but is never provided by the kernel.mk package. Instead, each board has its own provider,
for raspberry pi boar we use the **rpi-kernel** package. It contains a special instruction indicating
that is exists in place of the **kernel** package:

```
P_PROVIDES = kernel
```

**Note**: P_PROVIDES allow to specify a list, so a single package may provide on or more dependencies

## Binary Packages

As part of the cookie environment, there is a cache mechanism that allow to reuse packages that
are already built directly. The means that add a component A will first build it. But then, in
the event it is removed and readded, since it is already built it will simply be installed. This
allow to save a lot of time when debugging. Aside from the binary archive, there is a signature
file of the Makefile that is used to determine if the archive is still valid in regard to the
Makefile.

The following is taken into account to determine if a package need to be rebuild:

* The hash of the package makefile
* The hash of the package **P_FILES**

**Note**: That means that changing other things like the toolchain or the cookie scripts will
note trigger a rebuild. In such cases, clear the cache manually or simply restart with a fresh
target.