P_NAME			= busybox
P_VERSION		= 1.26.1
P_URL			= https://busybox.net/downloads/$(P_NAME)-$(P_VERSION).tar.bz2
P_DESCRIPTION	= The Swiss Army Knife of Embedded Linux
P_LICENCES		= GPL2
P_ARCHS			= arm
P_OPTIONS		=
P_DEPENDS		= libc

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract $(P_NAME)-$(P_VERSION).tar.bz2 $(P_WORKDIR)

compile:
	cd $(P_WORKDIR)/$(P_NAME)-$(P_VERSION) \
		&& make ARCH=$(P_ARCH) CROSS_COMPILE=$(P_CROSSCOMPILE)- defconfig \
		&& make ARCH=$(P_ARCH) CROSS_COMPILE=$(P_CROSSCOMPILE)- $(P_MAKEOPTS)

install:
	cd $(P_WORKDIR)/$(P_NAME)-$(P_VERSION) \
		&& make ARCH=$(P_ARCH) CROSS_COMPILE=$(P_CROSSCOMPILE)- install CONFIG_PREFIX=$(P_DESTDIR)
