# KERNEL

## Overview

The kernel is the central component of any Raspberry Pi image. It is executed by the boot loader
when the board is started and provide the necessary interface between the use programs and libraries
and the underlying hardware. In cookie, the Kernel is provided as a standard package but have some
specificities that are worth mentioning.

## Sources

Kernel sources for the cookie environment are coming from the official raspberry kernel repository
located at the following address:

	https://github.com/raspberrypi

Because this is a huge repository of several Go, we use archives instead of cloning it directly.
These archives are less than 200Mo, which make it much more suitable for a build environment. In
addition, these archives matches official releases of the raspberry kernel, ensuring we always work
on stable and tested versions of the kernel.

## Packages

Within the environment, the package is simply identified as **kernel**, and provide enough flexibility
to build a kernel for all Raspberry PI variants. The kernel package provides the following:

- **image**: the actual kernel image
- **modules**: various modules for the kernel that can be loaded at runtime
- **dts**: dtb files that goes along the image

The follow could be provided but are not installed as we prefer getting them from another source:

- **headers**: the kernel headers needed to build components agains the kernel

## Versioning

The versioning scheme for kernel package follow the main kernel branch version along with a suffix
specific to raspberry related modifications. It does not directly match the PI Kernel versioning
scheme that is based on a calendar date. The mapping between these version is easily understood from
the (fictional) table below:

| Official Kernel Version | Raspberry Release Version        | Cookie Version   |
| ----------------------- | -------------------------------- | -----------------|
| 4.14.50                 | raspberrypi-kernel_1.20170712-2  | kernel-4.14.50.1 |
| 4.14.70                 | raspberrypi-kernel_1.20180919-1  | kernel-4.14.70.1 |
| 4.14.70                 | raspberrypi-kernel_1.20181020-1  | kernel-4.14.70.2 |

## Environment

The kernel is highly board dependent, as such, several variable must be properly set in the
environment file of toolchain used by the profile:

- **HOST**: the toolchain to use for  [arm-linux-gnueabihf]
- **ARCH**: the architecture that is targetted [arm]
- **KCONFIG**: the default configuration to load

## Customization

The provided packages are using default configuration options and stock sources based on the
**KCONFIG** information. In the event where a custom kernel is needed, one simply need to put
a **[KCONFIG].config** file in the profile and it will be loaded automatically instead of
using the stock version.

## Firmware

Some content required for operating a Raspberry board is the property of Broadcom that decided not
to share the sources needed to build it. As a result, for such content, it is only possible to
retrieve and install binary content. This is managed by a separate package named **firmware**. Each
kernel package has a matching binary package version that can be used to install such content. It
is mandatory that the version of the kernel and firmware match.
