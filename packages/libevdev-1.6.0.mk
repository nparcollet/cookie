P_NAME			= libevdev
P_VERSION		= 1.6.0
P_DESCRIPTION	= Wrapper library for evdev devices
P_GITURL		= git://anongit.freedesktop.org/libevdev
P_GITREV		= f293c11fecd2d786f7742cb6768863d498b9d31b
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
	make -j$(P_NPROCS)

install:
	make DESTDIR=$(P_DESTDIR) install
	rm -rf $(P_DESTDIR)/usr/share
