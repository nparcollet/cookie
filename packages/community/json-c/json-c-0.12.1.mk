P_NAME			= json-c
P_VERSION		= 0.12.1
P_URL			= https://s3.amazonaws.com/json-c_releases/releases/$(P_NAME)-$(P_VERSION).tar.gz
P_DESCRIPTION	= C JSON Parser
P_LICENCES		=
P_ARCHS			= arm
P_OPTIONS		=
P_DEPENDS		= libc
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
