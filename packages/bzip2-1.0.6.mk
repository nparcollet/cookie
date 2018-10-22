P_NAME			= bzip2
P_VERSION		= 1.0.6
P_DESCRIPTION	= Compression Library
P_ARCHIVE		= bzip2-1.0.6.tar.gz
P_URL			= http://anduin.linuxfromscratch.org/LFS/$(P_ARCHIVE)
P_LICENCES		= bzip2-1.0.6
P_ARCHS			= arm
P_DEPENDS		=
P_SRCDIR		= bzip2-1.0.6

.PHONY: fetch setup compile install

fetch:
	cookie fetch $(P_URL) $(P_ARCHIVE)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	make -j$(P_NPROCS) CC=$(HOST)-gcc -f Makefile-libbz2_so

install:
	make CC=$(HOST)-gcc PREFIX=$(P_DESTDIR)/usr install
	cp -av libbz2.so* $(P_DESTDIR)/usr/lib
	rm -rf $(P_DESTDIR)/usr/bin
	rm -rf $(P_DESTDIR)/usr/man
