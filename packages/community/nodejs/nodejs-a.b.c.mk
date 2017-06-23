P_NAME			= nodejs
P_VERSION		= a.b.c
P_GITURL		=
P_GITREV		=
P_DESCRIPTION	=
P_LICENCES		=
P_ARCHS			= arm
P_OPTIONS		=
P_DEPENDS		= zlib libuv http-parser c-ares openssl v8
P_SRCDIR		= $(P_WORKDIR)/$(P_NAME)-$(P_VERSION)

fetch:
	cookie git clone $(P_GITURL) $(P_NAME)-$(P_VERSION)

setup:
	cookie git checkout $(P_NAME)-$(P_VERSION) $(P_GITREV) $(P_SRCDIR)

compile:
	cd $(P_SRCDIR) && make $(P_MAKEOPTS) PREFIX=$(P_DESTDIR)/usr library

install:
	cd $(P_SRCDIR) && make PREFIX=$(P_DESTDIR)/usr install
