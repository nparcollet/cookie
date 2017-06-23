P_NAME			= libsndfile
P_VERSION		= 1.0.27
P_URL			= http://www.mega-nerd.com/libsndfile/files/$(P_NAME)-$(P_VERSION).tar.gz
P_DESCRIPTION	= C routines for reading and writing files containing sampled audio data
P_LICENCES		=
P_ARCHS			= arm
P_OPTIONS		=
P_DEPENDS		= alsa-lib flac libogg libvorbis sqlite
P_SRCDIR		= $(P_WORKDIR)/$(P_NAME)-$(P_VERSION)

# NO EXTERNAL LIBS DETECTED ...

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract $(P_NAME)-$(P_VERSION).tar.gz $(P_WORKDIR)

compile:
	cd $(P_SRCDIR) && ./configure --prefix=/usr --host=$(HOST)
	cd $(P_SRCDIR) && make $(P_MAKEOPTS)

install:
	cd $(P_SRCDIR) && make DESTDIR=$(P_DESTDIR) install
