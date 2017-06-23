P_NAME			= alsa-lib
P_VERSION		= 1.1.2
P_URL			= ftp://ftp.alsa-project.org/pub/lib/$(P_NAME)-$(P_VERSION).tar.bz2
P_DESCRIPTION	= The ALSA Library package contains the ALSA library used by programs (including ALSA Utilities) requiring access to the ALSA sound interface.
P_LICENCES		=
P_ARCHS			= arm
P_OPTIONS		=
P_DEPENDS		= libc
P_SRCDIR		= $(P_WORKDIR)/$(P_NAME)-$(P_VERSION)

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract $(P_NAME)-$(P_VERSION).tar.bz2 $(P_WORKDIR)

compile:
	cd $(P_SRCDIR) && ./configure --prefix=/usr --host=$(HOST)
	cd $(P_SRCDIR) && make $(P_MAKEOPTS)

install:
	cd $(P_SRCDIR) && make DESTDIR=$(P_DESTDIR) install
