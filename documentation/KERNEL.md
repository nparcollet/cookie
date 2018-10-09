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

Different packages make use of the sources. For instance for Raspberry 3 B boards, the package is
named **raspberry/rpi3b-sources**. All these board specific packages will build kernel components
and make them available to others to depend on under the name **kernel**. The following elements
are provided by the kernel:

- **image**: the actual kernel image
- **headers**: the kernel headers needed to build components agains the kernel
- **modules**: various modules for the kernel that can be loaded at runtime
- **dts**: dtb files that goes along the image

## Versioning

The versioning scheme for kernel package follow the main kernel branch version along with a suffix
specific to raspberry related modifications. It does not directly match the PI Kernel versioning
scheme that is based on a calendar date. The mapping between these version is easily understood from
the (fictional) table below:

| Official Kernel Version | Raspberry Release Version        | Cookie Version                    |
| ----------------------- | -------------------------------- | ----------------------------------|
| 4.14.50                 | raspberrypi-kernel_1.20170712-2  | raspberry/rpi3b-sources-4.14.50.1 |
| 4.14.70                 | raspberrypi-kernel_1.20180919-1  | raspberry/rpi3b-sources-4.14.70.1 |
| 4.14.70                 | raspberrypi-kernel_1.20181020-1  | raspberry/rpi3b-sources-4.14.70.2 |

## Environment

The kernel is highly board dependent, as such, several variable must be properly set in the
environment file (build.env) of the profile:

- **HOST**: the toolchain to use for  [arm-linux-gnueabihf]
- **ARCH**: the architecture that is targetted [arm]
- **BOARD**: the board the kernel will run on [rpi0, rpi0w, rpi1, rpi2, rpi3, rpi3b]

## Customization

The provided packages are using default configuration options and stock sources. In the event where
a custom kernel is needed, one will have to create his own package. The convention is to name them
in the form **[board]-[custom]-sources**. It is recommended to use a standard kernel package as
example and modifying to fit the specific needs. In particular, the 2 following commands are of
interest and can be used in the package:

- **cookie load_config [name]**: load a .config file from the profile into the package sources
- **cookie patch [name]**: apply a patch from the profile into the package sources

## Firmware

Some content required for operating a Raspberry board is the property of Broadcom that decided not
to share the sources needed to build it. As a result, for such content, it is only possible to
retrieve and install binary content. This is managed by a separate package named
**raspberry/[board]-firmware**. Each kernel package as a matching binary package version that can be
used to install such content.
 
