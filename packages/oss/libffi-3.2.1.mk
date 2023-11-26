P_NAME			= libffi
P_VERSION		= 3.2.1
P_DESCRIPTION	= Foreign function interface library.
P_ARCHIVE		= libffi-3.2.1.tar.gz
P_URL			= ftp://sourceware.org/pub/libffi/$(P_ARCHIVE)
P_LICENCES		= MIT
P_ARCHS			= arm
P_DEPENDS		=
P_SRCDIR		= libffi-3.2.1

.PHONY: fetch setup compile install

fetch:
	cookie fetch $(P_URL) $(P_ARCHIVE)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	sed -e 's#^includesdir = .*#includesdir = $$(includedir)#' -i include/Makefile.in
	sed -e 's#^includedir=.*#includedir=$$\{prefix\}/include#' -i libffi.pc.in
	sed -e 's#^Cflags:.*#Cflags:#' -i libffi.pc.in
	./configure --host=$(HOST) --prefix=/usr
	make -j$(NPROCS)

install:
	make DESTDIR=$(P_DESTDIR) install
	rm -rf $(P_DESTDIR)/usr/share
	fix-la-files $(P_DESTDIR)
