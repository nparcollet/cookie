# TOOLCHAIN

The toolchain is a critical part when building embedded systems. In cookie, toolchain are created
based on config files. There is no binary toolchain. Thus, understanding how toolchain can be
created and customized is very important eventhou it is a complex matter. This page will provide
some pointers

## Cross Tool NG

Creating toolchain is a complex task, and it is not really the goal of cookie. As such, this part
is realized using crosstool ng, a tool dedicated to generating toolchain. Basically, ctng read a
configuration file (similar to the kernel config) and generate the toolchain based on this. Cookie
simply integrate ctng in standard command and use it when needed.

   COOKIE      <---\
|         |        |
v         v        |
CONFIG > CTNG > TOOLCHAIN

## Toolchain content

A toolchain contains several important elements use to create the target image:

* Cross Build tools like gcc or g++
* Debug tools like gdb and strace
* Headers for the kernel the toolchain was built against
* Function sysroot including stardard libraries and includes

All these are package in an archive that can be reused by cookie targets. Everything is located in
the **/opt/target/toolchain** directory when entering the development shell.

## Environment file

Within cookie, each toolchain come with it own environment file. This file set some variable
that simplify the use of building tools. For instance, it set a proper CFLAGS and LDFLAGS that 
will be used whenever building sources. The env file is sourced automaticalled when executing
command and when entering the shell (this is possible because a target always uses a specific
toolchain).

Once the toolchain is created, it uses default option in regards to CPU customization. Since the
amount of combinaison is very large, it is impossible to create a different toolchain for each.
Instead, on create a toolchain for a CPU family, let say ARM, and then use specific GCC option to
further specify the target capabilities. These option are part of the environment definition. For
instance, the **CFLAG** variable is used to tune the toolchain behavior:

* **fpu**: Floating Point Unit, set using -mfpu=<value> (ex: -mfpu=neon)
* **cpu**: Compute Processing Unit, set using the -mcpu=<value> (ex: -mcpu=cortex-a53)
* **arch**: Architecture variant, set usung the -march=<value> (ex: -march=armv7)
* **float-abi**: How to process floating point, set using the -mfloat-abi=<value> (ex: -float-abi=hard)

These options are CPU specific. For ARM for instance, this page can be used to review them and
decide what to use for the different CPP:

**https://developer.arm.com/documentation/dui0774/k/Compiler-Command-line-Options/-mfpu**

**Limitation**: This approach means that creating one toolchain with two or more environment is
not possible. Instead, another toolchain need to be created. This might change in the futur.
