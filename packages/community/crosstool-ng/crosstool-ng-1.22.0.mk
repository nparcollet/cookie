P_NAME			= crosstool-ng
P_VERSION		= 1.22.0
P_URL			= http://crosstool-ng.org/download/crosstool-ng/$(P_NAME)-$(P_VERSION).tar.bz2
P_DESCRIPTION	= Tools used for the creation of cross compilation toolchains
P_LICENCES		= MULTI
P_DEPENDS		=
P_ARCHS			= x86 amd64
P_OPTIONS		=

fetch:
	cookie fetch  $(P_URL)

setup:
	cookie extract $(P_NAME)-$(P_VERSION).tar.bz2 $(P_WORKDIR)

compile:
	cd $(P_WORKDIR)/crosstool-ng && ./configure --prefix=/usr
	cd $(P_WORKDIR)/crosstool-ng && MAKELEVEL=0 make $(P_MAKEOPTS)

install:
	cd $(P_WORKDIR)/crosstool-ng && MAKELEVEL=0 make DESTDIR=$(P_DESTDIR) install
