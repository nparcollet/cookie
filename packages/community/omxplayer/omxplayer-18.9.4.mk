P_NAME			= omxplayer
P_VERSION		= 18.9.4
P_DESCRIPTION	= HW Accelerated video player
P_GITURL		= https://github.com/popcornmix/omxplayer.git
P_GITREV		= 7f3faf6cadac913013248de759462bcff92f0102
P_LICENCES		= GPL2
P_ARCHS			= arm
P_SRCDIR		= omxplayer
P_DEPENDS		= alsa-lib pcre ffmpeg zlib dbus freetype

FT_CFLAGS     = $(shell $(HOST)-pkg-config --cflags freetype2)
DBUS_CFLAGS   = $(shell $(HOST)-pkg-config --cflags dbus-1)
ALSA_CFLAGS   = $(shell $(HOST)-pkg-config --cflags alsa)
PCRE_CFLAGS   = $(shell $(HOST)-pkg-config --cflags libpcre)
ALL_CFLAGS	  = $(FT_CFLAGS) $(DBUS_CFLAGS) $(PCRE_CFLAGS) $(ALSA_CFLAGS)

FT_LIBS     = $(shell $(HOST)-pkg-config --libs freetype2)
DBUS_LIBS   = $(shell $(HOST)-pkg-config --libs dbus-1)
ALSA_LIBS   = $(shell $(HOST)-pkg-config --libs alsa)
PCRE_LIBS   = $(shell $(HOST)-pkg-config --libs libpcre)
ALL_LIBS	  = $(FT_LIBS) $(DBUS_LIBS) $(PCRE_LIBS) $(ALSA_LIBS)

fetch:
	cookie git clone $(P_GITURL) $(P_NAME)

setup:
	cookie git checkout $(P_NAME) $(P_GITREV) $(P_SRCDIR)

compile:
	sed -e "s%CFLAGS=%CFLAGS+= $(ALL_CFLAGS) %" -i Makefile
	sed -e "s%LDFLAGS=%LDFLAGS+= $(ALL_LIBS) %" -i Makefile
	CC=$(HOST)-cc SDKSTAGE=$(P_SYSROOT) STRIP=$(HOST)-strip make -j$(P_NPROCS) omxplayer.bin

install:
	mkdir -p $(P_DESTDIR)/usr/bin
	cp omxplayer $(P_DESTDIR)/usr/bin/
	cp omxplayer.bin $(P_DESTDIR)/usr/bin/
