P_NAME			= snes9x-sdl
P_VERSION		= 1.53.1
P_DESCRIPTION	= SNes Emulator
P_GITURL		= https://github.com/domaemon/snes9x-sdl.git
P_GITREV		= 59d68a2c2ed8cb7266c689e704a1d843961ac6bc
P_LICENCES		= GPL2
P_ARCHS			= arm
P_DEPENDS		= sdl zlib libpng
P_SRCDIR		= snes9x-sdl

.PHONY: fetch setup compile install

fetch:
	cookie git clone $(P_GITURL) snes9x-sdl

setup:
	cookie git checkout snes9x-sdl HEAD $(P_SRCDIR)
	cd $(P_SRCDIR) && patch -p1 < $(P_PATCH)

compile:
	cd sdl && autoreconf -if
	cd sdl && ./configure --host=$(HOST) --prefix=/usr
	cd sdl && make -j$(P_NPROCS)

install:
	mkdir -p $(P_DESTDIR)/usr/bin
	cp sdl/snes9x-sdl $(P_DESTDIR)/usr/bin/snes9x
	$(HOST)-strip $(P_DESTDIR)/usr/bin/snes9x