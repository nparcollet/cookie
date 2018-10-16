P_NAME			= freetype
P_VERSION		= 2.9.1
P_DESCRIPTION	= FreeType is a freely available software library to render fonts.
P_ARCHIVE		= freetype-2.9.1.tar.bz2
P_URL			= https://download.savannah.gnu.org/releases/freetype/$(P_ARCHIVE)
P_LICENCES		= FTL
P_ARCHS			= arm
P_DEPENDS		= zlib bzip2 libpng glib
P_SRCDIR		= freetype-2.9.1
P_PROVIDES		= harfbuzz

.PHONY: fetch setup compile install

fetch:
	cookie fetch $(P_URL) $(P_ARCHIVE)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:

	./configure --host=$(HOST) --prefix=/usr --with-png=yes --with-zlib=yes --with-bzip2=yes --with-harfbuzz=no
	make -j$(P_NPROCS)
	make DESTDIR=$(P_WORKDIR)/staging_freetype install

install:
	make DESTDIR=$(P_DESTDIR) install
