P_NAME			= sdl
P_VERSION		= 2.0.8
P_DESCRIPTION	= libpng is the official PNG reference library.
P_ARCHIVE		= SDL2-2.0.8.tar.gz
P_URL			= https://www.libsdl.org/release/$(P_ARCHIVE)
P_LICENCES		=
P_ARCHS			= arm
P_DEPENDS		= alsa-lib glib
P_SRCDIR		= SDL2-2.0.8

.PHONY: fetch setup compile install

fetch:
	cookie fetch $(P_URL)


setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	./configure --host=$(HOST) --prefix=/usr
	make -j$(P_NPROCS)

install:
	make DESTDIR=$(P_DESTDIR) install
