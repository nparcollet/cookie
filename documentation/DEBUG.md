# DEBUG

## Overview

Once an image is ready for deployment, one would normally simply distribute it and user will flash
it on an SDCard without further ado. However, while the development is in progress, it is necessary
to have additional tools an way to interact with the board in order to test or solve problems that
might occur. This section describe the various approaches that can be used to help in this regards

## Console Access

### Connected Screen

Depending on the configuration of the profile, that is, if it does not start any graphical
application, it is possible to connect a screen and keyboard to the board and have access to the
running image. From there, and because busybox is normaly part of the profile, various maintainance
operation can be performed directly on the box.

### Serial Console

Using a serial console is the standard way when working on embedded devices as it allow to get a
terminal without modifying the image itself. It require however a properly configured kernel and
command line, along with potentially some adjustment on the GPIO of the Raspberry board. It also
require specific serial device (RS232). As a result, this approach was not tested and is not
recommended except for people who knows how thi works.

### Telnet

Another approach that does not require a screen and keyboard is to use a network protocol, in this
case Telnet. Telnetd, the telnet server, is part of busybox and should be part of your profile. To
make this work, the board need to be connected to the network and have an IP. Once again, the base
profile in cookie all use **ifplugd** for the network configuration, and the helper program
**/usr/sbin/ifplugd_handler** can be modified to set a fix IP address. In addition, the following
line need to be added in **/etc/inittab** to start the actual server:

    ::respawn:/usr/sbin/telnetd -F

### SSH Access

More modern and standard than Telnet is SSH. It does not come from busybox, but can be provided
by a package named **bearbox**. As for telnet, the network need to be properly setup and the
following need to be set in **/etc/inittab** (default for all base profiles):

    ::respawn:/usr/sbin/dropbear -R -F -B -E
    
**Note**: It is also possible to use the actual openssh server, but this might require additional
configuration steps that were not tested so far.

## NFS Sysroot

**WARNING**: This is a work in progress within cookie

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


## Debugging with GDB

The toolchain built with cookie come with GDB Server, a client server version of GDB. The
server, expected to run on the board, is part of the base file installed by the **sysroot**
package and can be run directly on the board to start debugging program. The syntax is:

    # gbserver <ip>:<port> <path/to/bin>
    
Once the host side, within the cookie shell, it is possible to connect remotely to the server
and start debugging:

    # $(HOST)-gdb
    > target remote <ip>:<port>
    > set solib-absolute-prefix /opt/target/rootfs
    > c (to start the program)
    > ...
