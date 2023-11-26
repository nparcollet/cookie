P_NAME			= expat
P_VERSION		= 2.2.6
P_DESCRIPTION	= Fast streaming XML parser written in C
P_ARCHIVE		= expat-2.2.6.tar.bz2
P_URL			= https://github.com/libexpat/libexpat/releases/download/R_2_2_6/$(P_ARCHIVE)
P_LICENCES		= MIT
P_ARCHS			= arm
P_DEPENDS		=
P_SRCDIR		= expat-2.2.6

.PHONY: fetch setup compile install

fetch:
	cookie fetch $(P_URL) $(P_ARCHIVE)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	./configure --prefix=/usr --host=$(HOST)
	make -j$(NPROCS)

install:
	make DESTDIR=$(P_DESTDIR) install
	rm -rf $(P_DESTDIR)/usr/share
	fix-la-files $(P_DESTDIR)
