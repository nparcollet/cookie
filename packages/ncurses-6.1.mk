P_NAME			= ncurses
P_VERSION		= 6.1
P_DESCRIPTION	= Text based user interfaces
P_ARCHIVE		= ncurses-6.1.tar.gz
P_URL			= https://invisible-mirror.net/archives/ncurses/$(P_ARCHIVE)
P_LICENCES		= X11
P_ARCHS			= arm
P_DEPENDS		=
P_SRCDIR		= ncurses-6.1

.PHONY: fetch setup compile install

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	./configure --prefix=/usr --with-shared --disable-stripping --enable-pc-file --enable-widec --host=$(HOST)
	make -j$(P_NPROCS)

install:
	STRIP=$(HOST)-strip make DESTDIR=$(P_DESTDIR) install
	rm -rf $(P_DESTDIR)/usr/bin # Do not install binaries (use busybox instead)
	rm -rf $(P_DESTDIR)/usr/share
