# PROFILES

## Overview

As an analogy, a Profile is like a recipe. It describes the ingredients and methodology needed
prepare a new dish. Within cookie, this disk is an actual image that can be flashed to a raspberry
board. Each profile contains a set of files needed to define various elements of the image. In
cookie, profile allow the creation of images that tend to follow the below philosophy:

* Custom linux kernel
* Busybox for basic tools
* MDev for hotplug managment
* Inittab for services managment
* Direct Framebuffer integration (no X)
* Basic layout with automount & autoip scripts
* Single user (root)
* Telnet & Ssh service

This is of course not limited to this, but it was designed and tested to be used this way.

## Listing

The following command allow to list all existing profile along with the application recipes that
exists:

	# cookie profiles
   
## Layout Organization

All profiles in the cookie environment are located in the **${COOKIE}/profiles** directory. Within this
directory, there is on directory per profile. Within the profile directory, cookie expect a certain
number of files to exists and to contain appropriate information.

## Creating a profile

The creation of a profile require a good knowledge of the elements it contain, and if the cookie 
environment. It is recommended, at least at first, to copy an existing profile that have similarity
with the new profile and to customize it. There is no command to create a profile, instead, one
will have to manually create the different files in the **{COOKIE}/profiles** directory.

## Configuration File

For each profile, there is mandatory **profile.conf** file that contains general information. This
file is in **json** format and must follow a predefined schema desribed here below:


    {
        "options": {
            "defconfig": null
        },
        "boards": {
            "rpi-nano-2w": {
                "toolchain" : "aarch64-rpi3-linux-gnu",
                "arch"      : "bcm2710a1",
			    "cpu"	    : "cortex-a53",
			    "isa"		: "armv8-a",
			    "options"	: { "defconfig": "bcm2711" }
            }
        },
        "image": {
		    "size"		: 64,
		    "boot"		: 16,
		    "rootfs"	: 48
	    },
    }

**options**
Package may require build options (as defined in the P_OPTIONS field). These options are defined
per profile. Each of them is made available to the package. An option named **foo** will be named
**P_OPTION_FOO** in the package.

**boards**
Each profile represent an image that is intended to run on a board. Because the same application
(for instance a media center) can be expected to run on various boards with different
characteristic, cookie provide a way to define these in the profile configuration. A board
represent an actual HW target. The profile allow to define what boards are supported. The board
description allow to determine what tools to use (for instance the toolchain) and define some
useful information that may be used by packages. Additionnaly, it allow to overload options that
may be defined at profile level in the **options**.

**image**
Simple definition of the target image, that is, the iso that will need to be flased on an SD card
thus allowing to boot the board with the software built by the profile. As of today, the system
only allow for images with 2 partitions, one for the **BOOT** containing the kernel and one for
the **ROOTFS** with everything else. 

**Limitation**: The image description is currently rather limited. It will probably be modified to be
more flexible in term of partitions that can be described.

## Toolchain

The toolchain is part of the board description, but is important enough to be detailed. The toolchain
determine the set of compilation tool (compiler, linker, ...) that need to be used to build an image
for a specific board. Because different profile can potentially target the samne board, the actual
tools are not stored directly in the profile. Instead, we simply save the name of the one to use. The
toolchain themselves are desribed in the **${COOKIE}/toolchains** directory. For each one there are
2 different files:

- toolchain-name.conf: the rules to create this toolchain
- toolchain-name.env: an env file that is source by cookie when needed

Toolchain are described more in detail in [Toolchain Reference](documentation/TOOLCHAIN.md)

## Packages

In addition to the profile information, each profile contains a **packages.conf** file that describe
what packages need to be installed in the target along with there version. This really is a simple
file with a list of package name and version. Below is the package file of the demo profile:

    dropbear-2022.83
    busybox-1.36.1
    zlib-1.3
    libxcrypt-4.4.36
    sysroot-1.0.1
    layout-0.1.0
    firmware-4.14.70.1
    kernel-6.1.54

Each line is an entry called a package selector. It is basically a string that aim at identifying a
package more or less precisely. For instance, it would also be possible to simple write **busybox**
withotu a version and cookie would try to find the latest version of this package. However because
we target consistancy, it is usually better to always specify the version needed.

**Note**: The profile will not handle dependencies automatically. It means that if you add a
package P that depends on D, and if D is not present in the profile packages, the image creation
will fail because of a missing dependency. This is a design choice more than a limitation.

## Configuration files

Some packages will required specific configuration files that are also expected to be located in
the directory containing the profile. It is recommended to limit this to the bare minimum, but is
nonetheless required in some circumstances. The kernel configuration file is a good example of a
file that could be provided from the profile. The demo profile contains **busybox.config**, a file
that will be used when building busybox.

**Limitation**: Changes to such file will not be detected automatically, thus, package that depends
on them will not be rebuilt when merging the target.

## Patches

As for configuration files, some packages will have to be patched in the context of the profile they
are used in. As a result, it is possible to add patch files in the profile and apply those patches
when needed. The reason patches are profile dependent is simple. If a patch is not profile dependent it
means the package it apply to is faulty, and as a result, it would make more sense to actually fix it
instead of applying a patch all the time. Patches need to be named as **<pkgname>-<pkgversion>.patch**
and will be applied automatically when found

**Limitation**: Changes to such file will not be detected automatically, thus, package that depends
on them will not be rebuilt when merging the target.
