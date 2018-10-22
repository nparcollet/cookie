P_NAME			= snes9x-sdl
P_VERSION		= 1.53.1
P_DESCRIPTION	= SNes Emulator
P_GITURL		= https://github.com/domaemon/snes9x-sdl.git
P_GITREV		= 59d68a2c2ed8cb7266c689e704a1d843961ac6bc
P_LICENCES		= GPL2
P_ARCHS			= arm
P_DEPENDS		= sdl zlib libpng
P_SRCDIR		= sources
P_PROVIDES		= snes9x

.PHONY: fetch setup compile install

fetch:
	cookie git clone $(P_GITURL) $(P_NAME)

setup:
	cookie git checkout $(P_NAME) $(P_GITREV) $(P_SRCDIR)
	cookie patch $(P_SRCDIR) snes9x-sdl-1.53.1-crosscompile.patch
	cookie patch $(P_SRCDIR) snes9x-sdl-1.53.1-joystick-support.patch

compile:
	cd sdl && autoreconf -if
	cd sdl && ./configure --host=$(HOST) --prefix=/usr
	cd sdl && make -j$(P_NPROCS)

install:
	mkdir -p $(P_DESTDIR)/usr/bin
	cp sdl/snes9x-sdl $(P_DESTDIR)/usr/bin/snes9x
	$(HOST)-strip $(P_DESTDIR)/usr/bin/snes9x
