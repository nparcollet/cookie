P_NAME			= glib
P_VERSION		= 2.58.1
P_DESCRIPTION	= Core application building blocks for libraries and applications written in C
P_ARCHIVE		= glib-2.58.1.tar.xz
P_URL			= https://download.gnome.org/sources/glib/2.58/$(P_ARCHIVE)
P_LICENCES		= LGPL
P_ARCHS			= arm
P_DEPENDS		= zlib libffi pcre
P_SRCDIR		= glib-2.58.1

.PHONY: fetch setup compile install

fetch:
	cookie fetch $(P_URL) $(P_ARCHIVE)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	wget https://raw.githubusercontent.com/GNOME/gtk-doc-stub/master/gtk-doc.m4 -O gtk-doc.m4
	wget https://raw.githubusercontent.com/GNOME/gtk-doc-stub/master/gtk-doc.make -O gtk-doc.make
	autoreconf -if
	./configure --prefix=/usr --with-pcre=system --sysconfdir=/etc --host=$(HOST) --enable-libmount=no glib_cv_stack_grows=no glib_cv_uscore=no
	make -j$(NPROCS)

install:
	make DESTDIR=$(P_DESTDIR) install-strip
	fix-la-files
