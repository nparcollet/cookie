P_NAME			= sdl
P_VERSION		= 1.2.15
P_DESCRIPTION	= Framework fpr low level access to audio, keyboard, mouse, joystick, and graphics
P_ARCHIVE		= SDL-1.2.15.tar.gz
P_URL			= https://www.libsdl.org/release/$(P_ARCHIVE)
P_LICENCES		= ZLIB
P_ARCHS			= arm
P_DEPENDS		= alsa-lib
P_SRCDIR		= SDL-1.2.15

.PHONY: fetch setup compile install

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	./configure --host=$(HOST) --prefix=/usr --without-dbus
	make -j$(P_NPROCS)

install:
	make DESTDIR=$(P_DESTDIR) install
