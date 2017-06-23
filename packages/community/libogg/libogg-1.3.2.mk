P_NAME			= libogg
P_VERSION		= 1.3.2
P_URL			= http://downloads.xiph.org/releases/ogg/$(P_NAME)-$(P_VERSION).tar.xz
P_DESCRIPTION	= Library for encoding and decoding ogg formatted bit stream.
P_LICENCES		=
P_ARCHS			= arm
P_OPTIONS		=
P_DEPENDS		= libc
P_SRCDIR		= $(P_WORKDIR)/$(P_NAME)-$(P_VERSION)

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract $(P_NAME)-$(P_VERSION).tar.xz $(P_WORKDIR)

compile:
	cd $(P_SRCDIR) && ./configure --prefix=/usr --host=$(HOST)
	cd $(P_SRCDIR) && make $(P_MAKEOPTS)

install:
	cd $(P_SRCDIR) && make DESTDIR=$(P_DESTDIR) install
