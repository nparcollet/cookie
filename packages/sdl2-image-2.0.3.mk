P_NAME			= sdl2-image
P_VERSION		= 2.0.3
P_DESCRIPTION	= Image Support Library for SDL2
P_ARCHIVE		= SDL2_image-2.0.3.tar.gz
P_URL			= https://www.libsdl.org/projects/SDL_image/release/$(P_ARCHIVE)
P_LICENCES		= ZLIB
P_ARCHS			= arm
P_DEPENDS		= sdl2 libpng libjpg
P_SRCDIR		= SDL2_image-2.0.3
# TODO: webp, tiff formats

.PHONY: fetch setup compile install

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	#sed -e "s#noinst_PROGRAMS = showfont glfont#noinst_PROGRAMS =#g" -i Makefile.am
	./autogen.sh
	./configure --host=$(HOST) --prefix=/usr SDL_VIDEODRIVER=RPI
	make -j$(P_NPROCS) libSDL2_image.la

install:
	make DESTDIR=$(P_DESTDIR) install
