P_NAME			= libjpg
P_VERSION		= 9
P_DESCRIPTION	= Functions for handling the JPEG image data format
P_ARCHIVE		= jpegsrc.v9c.tar.gz
P_URL			= https://www.ijg.org/files/$(P_ARCHIVE)
P_LICENCES		= JPEG
P_ARCHS			= arm
P_DEPENDS		= zlib
P_SRCDIR		= jpeg-9c

.PHONY: fetch setup compile install

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	./configure --host=$(HOST) --prefix=/usr
	make -j$(NPROCS)

install:
	make DESTDIR=$(P_DESTDIR) install
	rm -rf $(P_DESTDIR)/usr/share
	fix-la-files $(P_DESTDIR)
