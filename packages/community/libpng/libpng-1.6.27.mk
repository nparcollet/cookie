P_NAME			= libpng
P_VERSION		= 1.6.27
P_URL			= ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/$(P_NAME)-$(P_VERSION).tar.gz
P_DESCRIPTION	= Official PNG reference library
P_LICENCES		=
P_ARCHS			= arm
P_OPTIONS		=
P_DEPENDS		= zlib libc
P_SRCDIR		= $(P_WORKDIR)/$(P_NAME)-$(P_VERSION)

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract $(P_NAME)-$(P_VERSION).tar.gz $(P_WORKDIR)

compile:
	cd $(P_SRCDIR) && ./configure --prefix=/usr --host=$(HOST)
	cd $(P_SRCDIR) && make $(P_MAKEOPTS)

install:
	cd $(P_SRCDIR) && make DESTDIR=$(P_DESTDIR) install
