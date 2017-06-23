P_NAME			= flac
P_VERSION		= 1.3.1
P_URL			= http://downloads.xiph.org/releases/flac/$(P_NAME)-$(P_VERSION).tar.xz
P_DESCRIPTION	= FLAC is an audio CODEC similar to MP3, but lossless, meaning that audio is compressed without losing any information.
P_LICENCES		=
P_ARCHS			= arm
P_OPTIONS		=
P_DEPENDS		= libc libogg
P_SRCDIR		= $(P_WORKDIR)/$(P_NAME)-$(P_VERSION)
# xmms?

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract $(P_NAME)-$(P_VERSION).tar.xz $(P_WORKDIR)

compile:
	cd $(P_SRCDIR) && ./configure --disable-thorough-tests --prefix=/usr --host=$(HOST)
	cd $(P_SRCDIR) && make $(P_MAKEOPTS)

install:
	cd $(P_SRCDIR) && make DESTDIR=$(P_DESTDIR) install
