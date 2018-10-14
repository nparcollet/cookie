P_NAME			= harfbuzz
P_VERSION		= 1.9.0
P_DESCRIPTION	= HarfBuzz is an OpenType text shaping engine.
P_ARCHIVE		= harfbuzz-1.9.0.tar.bz2
P_URL			= https://github.com/harfbuzz/harfbuzz/releases/download/1.9.0/$(P_ARCHIVE)
P_LICENCES		= MIT
P_ARCHS			= arm
P_DEPENDS		=
P_SRCDIR		= harfbuzz-1.9.0

.PHONY: fetch setup compile install

fetch:
	cookie fetch $(P_URL) $(P_ARCHIVE)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	./configure --host=$(HOST) --prefix=/usr --without-freetype --without-glib
	make -j$(P_NPROCS)

install:
	make DESTDIR=$(P_DESTDIR) install
	rm -rf $(P_DESTDIR)/usr/share
	rm -rf $(P_DESTDIR)/usr/lib/cmake
	fix-la-files $(P_DESTDIR)
