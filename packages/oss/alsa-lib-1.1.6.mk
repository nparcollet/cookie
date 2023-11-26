P_NAME			= alsa-lib
P_VERSION		= 1.1.6
P_DESCRIPTION	= Audio System
P_GITURL		= git://git.alsa-project.org/alsa-lib.git
P_GITREV		= 1a95a63524a761fbc184ffc5a82992e275702fee
P_LICENCES		= TODO
P_ARCHS			= arm
P_DEPENDS		=
P_SRCDIR		= alsa-lib

.PHONY: fetch setup compile install

fetch:
	cookie git clone $(P_GITURL) $(P_NAME)

setup:
	cookie git checkout $(P_NAME) $(P_GITREV) $(P_SRCDIR)

compile:
	autoreconf -if
	./configure --prefix=/usr --host=$(HOST) --with-pcm-plugins=hw
	make -j$(NPROCS)

install:
	make DESTDIR=$(P_DESTDIR) install-strip
