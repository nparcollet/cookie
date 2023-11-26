P_NAME			= libpng
P_VERSION		= 1.6.35
P_DESCRIPTION	= libpng is the official PNG reference library.
P_ARCHIVE		= libpng-1.6.35.tar.xz
P_URL			= https://download.sourceforge.net/libpng/$(P_ARCHIVE)
P_LICENCES		= Libpng
P_ARCHS			= arm
P_DEPENDS		= zlib
P_SRCDIR		= libpng-1.6.35

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
