P_NAME			= sdl2
P_VERSION		= 2.0.14
P_DESCRIPTION	= TTF Support Library for STL2
P_ARCHIVE		= SDL2_ttf-2.0.14.tar.gz
P_URL			= https://www.libsdl.org/projects/SDL_ttf/release/$(P_ARCHIVE)
P_LICENCES		= ZLIB
P_ARCHS			= arm
P_DEPENDS		= stl2 freetype
P_SRCDIR		= SDL2_ttf-2.0.14

.PHONY: fetch setup compile install

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	sed -e "s#noinst_PROGRAMS = showfont glfont#noinst_PROGRAMS =#g" -i Makefile.am
	./autogen.sh
	./configure --host=$(HOST) --prefix=/usr --without-x --with-freetype-prefix=$(P_SYSROOT)/usr SDL_VIDEODRIVER=RPI
	make -j$(P_NPROCS) libSDL2_ttf.la

install:
	make DESTDIR=$(P_DESTDIR) install
