P_NAME			= s9xlauncher
P_VERSION		= 0.1.0
P_DESCRIPTION	= SNes Emulator
P_GITURL		= https://github.com/nparcollet/s9xlauncher.git
P_GITREV		= 4a98a2a62b1c7f0314eadf25cf5173bf2a0072ca
P_LICENCES		= MIT
P_ARCHS			= arm
P_DEPENDS		= sdl2 sdl2-ttf
P_SRCDIR		= sources

.PHONY: fetch setup compile install

fetch:
	cookie git clone $(P_GITURL) $(P_NAME)

setup:
	cookie git checkout $(P_NAME) $(P_GITREV) $(P_SRCDIR)

compile:
	autoreconf -if
	mkdir -p build
	cd build && ../configure --host=$(HOST) --prefix=/usr
	cd build && make -j$(P_NPROCS)


install:
	mkdir -p $(P_DESTDIR)/etc/init.d
	cp -a init.d/s900-s9xlauncher $(P_DESTDIR)/etc/init.d
	cd build && make DESTDIR=$(P_DESTDIR) install-strip
