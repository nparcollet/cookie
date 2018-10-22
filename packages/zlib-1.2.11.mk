P_NAME			= zlib
P_VERSION		= 1.2.11
P_DESCRIPTION	= A Massively Spiffy Yet Delicately Unobtrusive Compression Library
P_ARCHIVE		= zlib-1.2.11.tar.gz
P_URL   		= https://zlib.net/$(P_ARCHIVE)
P_LICENCES		= ZLIB
P_ARCHS			= arm
P_DEPENDS		=
P_SRCDIR		= zlib-1.2.11

.PHONY: fetch setup compile install

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	CHOST=$(HOST) ./configure --prefix=/usr --enable-shared
	make  -j$(P_NPROCS)

install:
	make DESTDIR=$(P_DESTDIR) install
	rm -rf $(P_DESTDIR)/usr/share
