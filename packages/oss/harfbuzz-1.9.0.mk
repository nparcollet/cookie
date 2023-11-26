P_NAME			= harfbuzz
P_VERSION		= 1.9.0
P_DESCRIPTION	= HarfBuzz is an OpenType text shaping engine.
P_ARCHIVE		= harfbuzz-1.9.0.tar.bz2
P_URL			= https://github.com/harfbuzz/harfbuzz/releases/download/1.9.0/$(P_ARCHIVE)
P_LICENCES		= MIT
P_ARCHS			= arm
P_DEPENDS		= glib zlib bzip2 libpng freetype
P_SRCDIR		= harfbuzz-1.9.0

.PHONY: fetch setup compile install

fetch:
	cookie fetch $(P_URL) $(P_ARCHIVE)
	cookie fetch https://download.savannah.gnu.org/releases/freetype/freetype-2.9.1.tar.bz2

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)
	cookie extract freetype-2.9.1.tar.bz2 $(P_WORKDIR)

compile:
	./configure --host=$(HOST) --prefix=/usr
	make -j$(NPROCS)

install:
	make DESTDIR=$(P_DESTDIR) install
	rm -rf $(P_DESTDIR)/usr/share
	fix-la-files $(P_DESTDIR)
