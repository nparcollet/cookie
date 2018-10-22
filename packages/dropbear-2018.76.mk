P_NAME			= dropbear
P_VERSION		= 2018.76
P_DESCRIPTION	= Dropbear is a relatively small SSH server and client
P_URL   		= http://matt.ucc.asn.au/dropbear/$(P_ARCHIVE)
P_ARCHIVE		= dropbear-2018.76.tar.bz2
P_LICENCES		= MIT
P_ARCHS			= arm
P_SRCDIR		= dropbear-2018.76
P_DEPENDS		= zlib

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	autoreconf -if
	./configure --prefix=/usr CC=$(HOST)-gcc --host=$(HOST)
	make -j$(P_NPROCS)
	make -j$(P_NPROCS) scp

install:
	make DESTDIR=$(P_DESTDIR) install
	cp scp $(P_DESTDIR)/usr/bin/
	rm -rf $(P_DESTDIR)/usr/share
	mkdir -p $(P_DESTDIR)/etc/dropbear
