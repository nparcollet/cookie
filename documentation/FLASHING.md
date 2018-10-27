# Flashing

## Overview

The creation of the image and its installation on an SDCard is the last step of the functionnalities
provided by cookie. It is actually a 3 step process that will be described in detail in this 
documents:

- creating a clean rootfs
- creating the image
- flashing it to the board

## Cleaning the Rootfs

The rootfs of the target, that is, the location where cookie put the result of building packages,
contains a lot of artifacts that are not necessary for actually running the image. For instance,
include files and static libraries. As a result, and before creating an image, cookie uses an
internal tool called **mkredist** that aim at creating the final rootfs, as it will be on the
image. This tools does not need to be called manually, but the result of its execution is visible
in the **/opt/target/redist** directory.

**Note**: As for other tools, mkredist work on the current target

## Creating the Image

The creation of the image use yet another tool of the cookie environment called **mkimage**. This
tools will internally clean the rootfs and then prepare a new image as specified by the profile.
For now, the information is limited to the size of the image and the size of the boot partition
and will result in an image with 2 partitions.

**Note**: As for other tools, mkredist work on the current target

## Wrapper

Because cookie is expected to be the single tool used when working with this environment, a
command wrapper is made available and will build the image automatically based on the current
target and the image description of the matching profile. It is call simply with:

    > cookie mkimage


## Flashing to the SDCard

The last step consist in flashing the generated image to an actual SDCard. This is out of scope
of the cookie environment itself. The reason behind this being that it is highly platform
dependent and would require a lot of development whereas there are already tools out there that
does just that. Cookie recommend the use of **etcher**, a battle tested flasher that works on
all the platforms supported by cooki.

## Booting the board

With the image flashed on the SDCard, what remain is simply putting it in the Raspberry board
and booting it. The result will of course depends on the profile that was choosen.

