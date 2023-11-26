P_NAME			= sdl2
P_VERSION		= 2.0.8
P_DESCRIPTION	= Framework fpr low level access to audio, keyboard, mouse, joystick, and graphics
P_ARCHIVE		= SDL2-2.0.8.tar.gz
P_URL			= https://www.libsdl.org/release/$(P_ARCHIVE)
P_LICENCES		= ZLIB
P_ARCHS			= arm
P_DEPENDS		= alsa-lib glib firmware
P_SRCDIR		= SDL2-2.0.8

.PHONY: fetch setup compile install

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	./autogen.sh
	./configure --host=$(HOST) --prefix=/usr --enable-video-rpi
	make -j$(NPROCS)

install:
	make DESTDIR=$(P_DESTDIR) install
	rm -rf $(P_DESTDIR)/usr/bin
