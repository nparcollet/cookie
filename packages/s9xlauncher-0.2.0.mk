P_NAME			= s9xlauncher
P_VERSION		= 0.2.0
P_DESCRIPTION	= Snes Emulator
P_GITURL		= https://github.com/nparcollet/s9xlauncher.git
P_GITREV		= 6318b38e5403c66877374ae4bd1b97df62334bdd
P_LICENCES		= MIT
P_ARCHS			= arm
P_DEPENDS		= sdl2 sdl2-ttf sdl2-image
P_SRCDIR		= sources

.PHONY: fetch setup compile install

fetch:
	cookie git clone $(P_GITURL) $(P_NAME)

setup:
	cookie git checkout $(P_NAME) $(P_GITREV) $(P_SRCDIR)

compile:
	make -j$(NPROCS)

install:
	make DESTDIR=$(P_DESTDIR) install
