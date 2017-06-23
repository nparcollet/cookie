P_NAME			= openssl
P_VERSION		= 1.0.2j
P_URL			= https://openssl.org/source/$(P_NAME)-$(P_VERSION).tar.gz
P_DESCRIPTION	= management tools and libraries relating to cryptography
P_LICENCES		=
P_ARCHS			= arm
P_OPTIONS		=
P_DEPENDS		=
P_SRCDIR		= $(P_WORKDIR)/$(P_NAME)-$(P_VERSION)

# TODO: LOTS OF WARNING WHILE RUNNING MAKEDEPENDS. FIX THEM
# TODO: PATENTS on some libs of openssl, make them optional
# TODO: linux-generic32 should be an option somehow

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract $(P_NAME)-$(P_VERSION).tar.gz $(P_WORKDIR)

compile:
	cd $(P_SRCDIR) && ./Configure linux-generic32 shared --prefix=/usr --openssldir=/etc/ssl
	cd $(P_SRCDIR) && make depend $(P_MAKEOPTS)
	cd $(P_SRCDIR) && make $(P_MAKEOPTS)

install:
	cd $(P_SRCDIR) && make DESTDIR=$(P_DESTDIR) install
