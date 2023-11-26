P_NAME			= zlib
P_VERSION		= 1.3
P_DESCRIPTION	= A Massively Spiffy Yet Delicately Unobtrusive Compression Library
P_ARCHIVE		= $(P_NAME)-$(P_VERSION).tar.gz
P_URL   		= https://zlib.net/$(P_ARCHIVE)
P_LICENCES		= ZLIB
P_ARCHS			= arm arm64
P_DEPENDS		= libc kernel
P_SRCDIR		= zlib-1.3

.PHONY: fetch setup compile install

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	CHOST=$(HOST) ./configure --prefix=/usr --enable-shared
	make  -j$(NPROCS)

install:
	make DESTDIR=$(P_DESTDIR) install
	rm -rf $(P_DESTDIR)/usr/share
