P_NAME			= snes9x-sdl
P_VERSION		= 1.53.1
P_DESCRIPTION	= SNes Emulator
P_GITURL		= https://github.com/domaemon/snes9x-sdl.git
P_GITREV		= 59d68a2c2ed8cb7266c689e704a1d843961ac6bc
P_LICENCES		= GPL2
P_ARCHS			= arm
P_DEPENDS		= sdl2 zlib libpng
P_SRCDIR		= sources
P_PROVIDES		= snes9x

.PHONY: fetch setup compile install


fetch:
	cookie git clone $(P_GITURL) $(P_NAME)

setup:
	cookie git checkout $(P_NAME) $(P_GITREV) $(P_SRCDIR)

compile:
	cd sdl2 && autoreconf -if
	cd sdl2 && ./configure --host=$(HOST) --prefix=/usr --disable-zip --enable-neon
	cd sdl2 && make -j$(NPROCS)

install:
	mkdir -p $(P_DESTDIR)/usr/bin
	cp sdl2/snes9x-sdl $(P_DESTDIR)/usr/bin/snes9x
	$(HOST)-strip $(P_DESTDIR)/usr/bin/snes9x
