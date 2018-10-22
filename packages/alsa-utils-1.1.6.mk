P_NAME			= alsa-utils
P_VERSION		= 1.1.6
P_DESCRIPTION	= Various utilities which are useful for controlling your sound card
P_ARCHIVE		= alsa-utils-1.1.6.tar.bz2
P_URL			= ftp://ftp.alsa-project.org/pub/utils/$(P_ARCHIVE)
P_LICENCES		= TODO
P_ARCHS			= arm
P_DEPENDS		= alsa-lib ncurses
P_SRCDIR		= alsa-utils-1.1.6

.PHONY: fetch setup compile install

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	./configure --prefix=/usr --host=$(HOST) --enable-alsamixer --enable-alsaconf \
		NCURSESW_CFLAGS="-I$(P_SYSROOT)/usr/include" \
		NCURSESW_LIBS="-L$(P_SYSROOT)/usr/lib -lncursesw -lpanelw -lmenuw"
	make -j$(P_NPROCS)

install:
	make DESTDIR=$(P_DESTDIR) install-strip
