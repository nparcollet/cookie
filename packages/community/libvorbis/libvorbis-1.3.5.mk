P_NAME			= libvorbis
P_VERSION		= 1.3.5
P_URL			= http://downloads.xiph.org/releases/vorbis/$(P_NAME)-$(P_VERSION).tar.xz
P_DESCRIPTION	= Library for encoding and decoding VORBIS formatted bit stream.
P_LICENCES		=
P_ARCHS			= arm
P_OPTIONS		=
P_DEPENDS		= libogg libc
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
