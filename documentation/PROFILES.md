# PROFILES

## Overview

As an analogy, a Profile is like a recipe. It describes the ingredients and methodology needed prepare
a new dish. Within cookie, this disk is an actual image that can be flashed to a raspberry board. Each
profile contains a set of files needed to define various elements of the image.

## Listing

The following command allow to list all existing profile along with the application recipes that
exists:

	# cookie profiles
    
    
## Layout Organization

All profiles in the cookie environment are located in the **${COOKIE}/profiles** directory. Within this
directory, there is on directory per profile. Within the profile directory, cookie expect a certain
number of files to exists and to contain appropriate information.

## Creating a profile

The creation of a profile require a good knowledge of the elements it contain, as desribed in the page.
However, the standard way to create a new profile is to copy an existing one and to customize it as
necessary, hence limiting the risk of doing something wrong. There is no command to create a profile,
instead, one will have to manually create his new profile in the **{COOKIE}/profiles** directory.

## Configuration File

For each profile, there is **profile.conf** file that contains general information. This file is in
**json** format and must follow a predefined schema desribed here below:


    {
        "boards": {
            ...
        },
        "image": {
            ...
        }
    }



## Board Support

Each profile represent an image that is intended to run on a board. Because the same application (for
instance a media center) can be expected to run on various boards with different characteristic, cookie
provide a way to define these in the profile configuration. Theses elements are desribed in the
**profile.conf** file of the profile, within the **board** section. There are currently 2 piece of
information needed for each board that is to be supported

- toolchain: the name of the toolchain to use
- arch: the architecture of the targetted hardware

An exemple of entry would be as follow:

    "rpi3b": {
        "toolchain": "arm-rpi3b-linux-gnueabihf",
        "arch": "arm"
    }

## Toolchain

The toolchain is part of the board description, but is important enough to be detailed. The toolchain
determine the set of compilation tool (compiler, linker, ...) that need to be used to build an image
for a specific board. Because different profile can potentially target the samne board, the actual
tools are not stored directly in the profile. Instead, we simply save the name of the one to use. The
toolchain themselves are desribed in the **${COOKIE}/toolchains** directory. For each one there are
2 different files:

- toolchain-name.conf: the rules to create this toolchain
- toolchain-name.env: an env file that can be sourced to setup compilation with the toolchain


Toolchains generation is a complex matter, and it is not the role of cookie to deal with this. Instead
we use a tool called **crosstool-ng**. With it, we simply need to provide a config file, and the
program will generate everything.

Building a toolchain is a long process, however cookie will cache the result of building a toolchain
for later use. The environment will automaticaly detect changes to the toolchain configuration file and
might recreate it when appropriate.

## Packages

In addition to the profile information, each profile contains a **packages.conf** file that describe
what packages need to be installed in the target along with there version. This really is a simple
file with a list of package name and version. For instance, busybox could be added with the following
entry in the file:

    busybox-1.29.3
    
This type of entry is called a package selector. It is basically a string that aim at identifying a
package more or less precisely. For instance, it would also be possible to simple write **busybox**,
an cookie would try to find the latest version of this package. However because we target consistancy,
it is usually better to always specify the version needed.

**Limitation**: The profile will not handle dependencies automatically. It means that if you add
a package P that depends on D, and if D is not present in the profile packages, the image creation will
fail because of a missing dependency.


## Image

Another piece of information needed in profile is the specification of the image characteristics. That
is, the size of the image and the different partition that it contains. As of today, the system only
allow for images with 2 partitions, one for the **BOOT** containing the kernel and one for the **ROOTFS**
with everything else. These information are to be defiend in the **profile.conf** file in the **image**
section as follow:

    "image": {
        "size": 256,
        "boot": 32
    }

**Limitation**: The image description is currently rather limited. It will probably be modified to be
more flexible in term of partitions that can be described.

## Import

Some packages will required specific configuration files that are also expected to be located in the
directory containing the profile. It is recommended to limit this to the bare minimum, but is nonetheless
required in some circumstances. The kernel configuration file is a good example of such file.


## Patches

As for configuration files, some packages will have to be patched in the context of the profile they
are used in. As a result, it is possible to add patch files in the profile and apply those patches
when needed. The reason patches are profile dependent is simple. If a patch is not profile dependent it
means the package it apply to is faulty, and as a result, it would make more sense to actually fix it
instead of applying a patch all the time.
