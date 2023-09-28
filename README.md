# PRESENTATION

Cookie is a complete cross compilation environment that is host agnostic and can run on most of the
OS out there. That includes **Windows**, **Mac OS** and of course the **Linux** distributions. It allows
to build firmware images for various platforms.

Currently Cookie focus on **Raspberry PI boards**, that are widely available out there, but can be easily
adapted to work with other platforms. It provides different **profiles** that define what an image contains
and how to build it. These profiles serve both as an example to learn how to work with the environment
and as a base for customization to work on more complex creations.

Cookie is not an OS, in the sense of Raspbian or OpenElec. It is not installed directly on your board and
the image created with Cookie does not need to have a package manager. Instead, Cookie is the package
manager, and you have full control over what make up the firmware. In this sense it is similar to Buildroot.

Cookie approach result in custom tailored images, that does what they were designed for and are not
cluttered with additional functionalities that you don't need. In addition, the infrastructure allows for
strict version control over the different components, allowing for easy reproductibility and firmware
cohesion.

To summarize, with cookie, you choose a set of packages you want to install, you create the image that will
contains all the binaries and libraries that are needed, and you deploy this image on a board that can then
be started straight away without any additional steps on the resulting image or the board itself.

# PREREQUISITES

Before working with cookie, you need to ensure the necessary dependencies are installed on your system and
properly setup. Note that these are kept to the bare minimum as to ensure cookie can run on a wide variety
of systems. As of today, the following are required:

- git
- python
- docker
- any console (window: wsl, powershell, linux: console, ...)

These tools are available on most OS and are relatively easy to install and setup. Simply check
online for these component as they all come with simple installation guides.

# SETUP

With all the dependencies in place, the setup of cookie itself is also pretty straight forward. It 
is a one time operation. Once complete, the **cookie** command will be available from the **console**
of your system.

**Retrieve cookie source code**

The first step of setup consist in cloning this repository. Assuming you want to install the code in
the **/path/to/cookie** directory, the following command can be issued:

	> git clone https://github.com/nparcollet/cookie.git /path/to/cookie

**Setup the console environment**

The second and last step is about setting up the environment so that the **cookie** command is
accessible easily from anywhere in the console. Because the way to define these variables depends on
your host system, there is no universal command that can be used. For instance on Linux and Mac you
are more likely to have to add some **export** entries in the **~/.bash_profile** file. On Windows,
this is done throu the system settings applet. Following is the list of changes that are expected on
the environment:

**COOKIE=/path/to/cookie** is to point the location where the repository was cloned
**${COOKIE}/bin** is to be added to the **PATH** variable of the environment
**PYTHONPATH=$COOKIE/python** is to be defined so that cookie python modules can be loaded

# QUICKSTART

The process of going from the description of an image to actually generating this image and flashing
it onto the board is long and complex, however it can be summarized with the following simple diagram:

![Overview](documentation/overview.png)

Keep this diagram in mind, and with the following commands, create your first image:

	> cookie bootstrap update
	> cookie create demo rpi3b
	> cookie merge
	> cookie mkredist

The result of these 4 commands is a brand new image named **demo-rpi3b.img** located in the
**${COOKIE}/cache/images** directory. Please note that cookie job stop at the generation of the
image. There are already tools out there that can be used to put this image on an SDCard so that
it can be loaded by the PI board. I recomment the use of **etcher** (https://etcher.io), an easy to
use multiplatform tool used to flash images to SD cards.

This image is of course very limited. Basically, it contains a kernel and busybox. It has a single
**root** user defined and use the password **password**. There is a network service that will
connect using DHCP, and it automatically detect when USB Keys are connected/disconnected. You can
open a terminal on the board using the following mechanisms:

- Connecting a Screen and Keyboard to the board
- Using Telnet (If you know the board IP)
- Using SSH (If you know the board IP)

**Important**: The execution of these commands might take a while, especially the first time. After
all, we are compiling everything from scratch, including the toolchain. In cookie, a lot of elements
are cached for reuse and will only be rebuilt if there description changes. For instance, you will
rarely need to recreate the build environment, or the toolchain.

## Under the hood

**Bootstrap**
The first step allow to create a separate environment from your host where all the needed tools are
installed at a known version. This is basically another linux distro based on Debian. Doing so, cookie
will always be able to find the host tools it needs, and these tools will be at the expected version
with a compliant API.

**Create**
Using the various information in cookie, create the recipe that you want to build. This include choosing
the toolchain, the kernel configuration and the package to include. All of this put together is called
a target, basically the instanciation of a profile. This is a quick operation, simply consisting of
creating directories and copying files around.

**Merge**
Merging in cookie is the process that consist of ensure the end game image (the one that will be flashed
on your device) is up to date in regards with the rules to build it. First time you build a target it will
be long since nothing exists. However, once build, if you modify part of the recipe, the merge will only
consist in rebuilding the components that were updated, or taking into account the new options that were
selected.

**MkRedist**
The last step consist in packaging the result of the merge as needed so that images can be flashed into
the target device. Often, this means generating a disk image with several partition that can be directly
copied on the device drive.

# DOCUMENTATION

There is a lot more to cookie than just following the quick start. It is highly recommended to read
the following documents in order to get a good grasp of what can be done and how. These documents
are ordered in a logical order and will drive you throu this journey:

- [Build Environment](documentation/BOOTSTRAP.md)
- [Working with Profiles](documentation/PROFILES.md)
- [Target ins and outs](documentation/TARGETS.md)
- [Package Managment](documentation/PACKAGES.md)
- [Flashing an image](documentation/FLASHING.md)

# GUIDES

- [Command Line Reference](documentation/CMDLINE.md)
- [Managing and customizing the kernel](documentation/KERNEL.md)
- [Understanding cookie python module](documentation/PYTHON.md)
- [Debugging the Image](documentation/DEBUG.md)
- [Known Issues](documentation/TROUBLESHOOTING.md)
