P_NAME			= s9xlauncher
P_VERSION		= 0.1.0
P_DESCRIPTION	= SNes Emulator
P_GITURL		= https://github.com/nparcollet/s9xlauncher.git
P_GITREV		= b6ca61e38a79247963b024d25309a20d7b0208c2
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
	cd build && make DESTDIR=$(P_DESTDIR) install-strip
