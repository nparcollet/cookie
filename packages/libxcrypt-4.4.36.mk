

P_NAME			= libxcrypt
P_VERSION		= 4.4.36
P_DESCRIPTION	= Crypto stuffs
P_ARCHIVE		= v4.4.36.tar.gz
P_URL			= https://github.com/besser82/libxcrypt/archive/refs/tags/v4.4.36.tar.gz
P_LICENCES		= JPEG
P_ARCHS			= arm arm64
P_DEPENDS		= zlib
P_SRCDIR		= libxcrypt-4.4.36

.PHONY: fetch setup compile install

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	./autogen.sh
	./configure --host=$(HOST) --prefix=/usr
	make -j$(NPROCS)

install:
	make DESTDIR=$(P_DESTDIR) install
	rm -rf $(P_DESTDIR)/usr/share
	fix-la-files $(P_DESTDIR)

