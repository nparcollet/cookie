P_NAME			= evtest
P_VERSION		= 1.33
P_DESCRIPTION	= Test Input devices
P_GITURL		= git://anongit.freedesktop.org/evtest
P_GITREV		= 1b1075330198bf9efa67c9d970995aaa31df33df
P_LICENCES		=
P_ARCHS			= arm
P_DEPENDS		=
P_SRCDIR		= sources

.PHONY: fetch setup compile install

fetch:
	cookie git clone $(P_GITURL) $(P_NAME)

setup:
	cookie git checkout $(P_NAME) $(P_GITREV) $(P_SRCDIR)

compile:
	autoreconf -if
	./configure --host=$(HOST) --prefix=/usr
	make -j$(NPROCS)

install:
	make DESTDIR=$(P_DESTDIR) install
