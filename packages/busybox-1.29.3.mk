P_NAME			= busybox
P_VERSION		= 1.29.3
P_DESCRIPTION	= The Swiss Army Knife of Embedded Linux
P_URL   		= https://busybox.net/downloads/busybox-1.29.3.tar.bz2
P_ARCHIVE		= busybox-1.29.3.tar.bz2
P_LICENCES		= GPLv2
P_ARCHS			= arm
P_SRCDIR		= busybox-1.29.3

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	cookie import busybox.config .config || make ARCH=$(ARCH) CROSS_COMPILE=$(HOST)- defconfig
	make CFLAGS=$(CFLAGS) ARCH=$(ARCH) CROSS_COMPILE=$(HOST)- -j$(P_NPROCS) busybox

install:
	make ARCH=$(ARCH) CROSS_COMPILE=$(HOST)- -j$(P_NPROCS) install CONFIG_PREFIX=$(P_DESTDIR)
	$(HOST)-strip $(P_DESTDIR)/bin/busybox
