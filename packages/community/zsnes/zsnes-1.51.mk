P_NAME			= zsnes
P_VERSION		= 1.51
P_URL			= https://www.fosshub.com/ZSNES.html/zsnes151src.tar.bz2
P_DESCRIPTION	= ZSNES is a SNES games emulator for PC
P_LICENCES		= TODO
P_ARCHS			= arm
P_OPTIONS		=
P_DEPENDS		= zlib libpng libc libao ##  sdl opengl jmalib curses

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract zsnes151src.tar.bz2 $(P_WORKDIR)

compile:
	cd $(P_WORKDIR)/zsnes-1_51/src				\
		&& xxx
	#	&& export CROSS=$(P_CROSSCOMPILE)		\
	#	&& export CC=$(P_CROSSCOMPILE)-gcc		\
	#	&& export LD=$(P_CROSSCOMPILE)-ld		\
	#	&& export AS=$(P_CROSSCOMPILE)-as		\
	#	&& ./configure --prefix=/usr			\
	#	&& make $(P_MAKEOPTS)

install:
	xxx install
	#	cd $(P_WORKDIR)/$(P_NAME)-$(P_VERSION)		\
	#		&& make DESTDIR=$(P_DESTDIR) install


http://www.fosshub.com/ZSNES.html
