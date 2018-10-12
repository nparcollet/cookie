# DEBUG

# Overview

Once an image is ready for deployment, one would normally simply distribute it and user will flash
it on an SDCard without further ado. However, while the development is in progress, it is necessary
to have additional tools an way to interact with the board in order to test or solve problems that
might occur. This section describe the various element of the cookie environment that are in place
to help in this regard.

# Flashing

# SSH Access

# Serial Console

# NFS Sysroot

Even thou flashing a new version of the software to an SDCard is relatively easy, having to do it
over and over again during development / testing can quickly become a burden. To solve this we use
NFS (Network Filesystem). In this configuration the board does not use a sysroot from an SDCard, but
instead access a remote location on the development machine that contains the same files. These
files being on the dev PC, it is easy to customize or make changes and see them applied directly.
Doing so will require 2 steps.

First, on the development machine, we need to install a file server that will allow remote machines
to access the target rootfs. This done by simply running the **nfsd** command from within the cookie
shell. At this point one should also note the IP of his or her environment.

Secondly, in order to tell the board that it needs to use a network rootfs instead of the one that
is flashed on the sdcard it is necessary to modify the kernel command line used when booting the
system. This is simply modified in the **cmdline.txt** file. The following parameters replace the
normal **root** parameters:

- **root=/dev/nfs**: tell the board to mount a remove sysroot
- **nfsroot=[pc_ip]:/opt/target/rootfs**: tell the board where to mount from
- **ip=dhcp**: tell the board of to configure its own ip address for accessing the network
