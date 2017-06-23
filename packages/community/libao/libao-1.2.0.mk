P_NAME			= libao
P_VERSION		= 1.2.0
P_URL			= http://downloads.xiph.org/releases/ao/$(P_NAME)-$(P_VERSION).tar.gz
P_DESCRIPTION	= Cross-platform audio library
P_LICENCES		=
P_ARCHS			= arm
P_OPTIONS		= (wmm, esd, alsa, alsa-mmap, broken-oss, arts, nas, pulse, roar-default-slp
P_DEPENDS		= libc
# DEPENDS: KERNEL HEADERS, ALSA, PULSE
P_SRCDIR		= $(P_WORKDIR)/$(P_NAME)-$(P_VERSION)

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract $(P_NAME)-$(P_VERSION).tar.gz $(P_WORKDIR)

compile:
	cd $(P_SRCDIR) && ./configure --prefix=/usr --host=$(HOST)
	cd $(P_SRCDIR) && make $(P_MAKEOPTS)

install:
	cd $(P_SRCDIR) && make DESTDIR=$(P_DESTDIR) install
