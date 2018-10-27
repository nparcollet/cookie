# TARGETS
## Overview

As a programmation analogy, if the Profile is a class, the Target is an instance of this
class. Concretely, the target is basically a directory where cookie will work and install
the various packages defined in the profile before building the final image. The target is
accessible throu the **/opt/target** directory within the build environment. It is also
bound to the profile it originate from with the **COOKIE_PROFILE** and **COOKIE_BOARD**
environment variables.

## Volume
Within cookie, you can create as many targets as you wish. Each one as a unique name used
to reference it. The directory of a target is actually a volume (in the docker sense). This
volume is created at the same time as the target, and destroyed when the target is deleted.
When using the build environment, the target volume is mounted in **/opt/target** and
accessible as a writable location. This apply both when using cookie commands to manipulate
the environment, or when working the the **shell** of the build environment.

## Listing targets
The list of targets can be obtained very easily with the following command:

    > cookie list

## Active target

It is possible to maintain several targets, however, at any given time, on one target is
active. This active target is the one cookie will work on when using the different target
related commands listed in this page. The active target is marked as such when listing all
targets. It is possible to change the active target with the following command:

    > cookie select [target_name]

## Creating target

Creating a new target is done using the create command. It takes the name of a profile along
with a board to build for as parameters:

    > cookie create demo rpi3b [target_name]


The creation involve several steps.

- Choose a name (if not provided as argument)
- A docker volume is created
- The toolchain defined in the target profile is built/installed
- The target is mapped to its profile
- The target is made current

## Destroying targets

Because targets are where all build operation take place, they can rapidly use a lot of disk
space. It is possible to destroy targets (and there associated volume) with the following
command:

    > cookie destroy target_name

## Merging packages

Once a target is created, the natural operation is to **merge** it. This means looking for
the packages defined in the profile and installing them in the target. Note that merging will
reinstall those package whose version as change, and remove the one installed but not defined
in the profile. The merge operation basically allow to ensure the different packages are
installed a defined in the profile. Merge can be a long operation, and is called with the
following command:

    > cookie merge


## Adding Custom Packages

In addition to the packages that are defined in the profile and that are simply installed
with the merge command, users can also add packages manually using the following command:

    > cookie add package_selector

## Removing Packages

Independently of whether a package was added from the profile or manually using the add
command, the user can remove package using the following command:

    > cookie remove package_name

## Package List

At any time, it is possible to list the packages that are currently in the current target
using the following command:

    > cookie packages

## Organization

The target directory, or volume, contains various subdurectories listed below:

**archives**: binary package that are already built are located here
**buid**: the base directory where build operation for the target occur
**installed**: a database of what package are currently installed along with there files
**redist**: the final rootfs, stripped down of built artifact present in rootfs (for instance static libraries)
**rootfs**: this is where the packages, once built, are installed and grouped together
**toolchain**: the toolchain binaries for this target

