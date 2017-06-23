P_NAME			= zlib
P_VERSION		= 1.2.10
P_URL			= http://www.zlib.net/$(P_NAME)-$(P_VERSION).tar.gz
P_DESCRIPTION	= A Massively Spiffy Yet Delicately Unobtrusive Compression Library
P_LICENCES		= ZLIB
P_ARCHS			= arm
P_OPTIONS		=
P_DEPENDS		=

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract $(P_NAME)-$(P_VERSION).tar.gz $(P_WORKDIR)
	mv $(P_WORKDIR)/$(P_NAME)-$(P_VERSION) $(P_SRCDIR)

compile:
	cd $(P_SRCDIR) && ./configure --prefix=/usr
	cd $(P_SRCDIR) && make $(P_MAKEOPTS)

install:
	cd $(P_SRCDIR) && make DESTDIR=$(P_DESTDIR) install
