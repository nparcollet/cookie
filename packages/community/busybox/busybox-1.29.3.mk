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
	mkdir -p $(P_DESTDIR)/dev
	mkdir -p $(P_DESTDIR)/proc
	mkdir -p $(P_DESTDIR)/sys
	mkdir -p $(P_DESTDIR)/tmp
	mkdir -p $(P_DESTDIR)/bin
	mkdir -p $(P_DESTDIR)/etc/init.d
	cookie import busybox.fstab $(P_DESTDIR)/etc/fstab
	cookie import busybox.inittab $(P_DESTDIR)/etc/inittab
	cookie import busybox.rcS $(P_DESTDIR)/etc/init.d/rcS
	chmod +x $(P_DESTDIR)/etc/init.d/rcS
	echo "$(COOKIE_BOARD)-$(COOKIE_APP)" > $(P_DESTDIR)/etc/hostname
	rm $(P_DESTDIR)/usr/bin/bzip2 $(P_DESTDIR)/usr/bin/bunzip2 $(P_DESTDIR)/usr/bin/bzcat
	#cp examples/depmod.pl $(P_DESTDIR)/bin
