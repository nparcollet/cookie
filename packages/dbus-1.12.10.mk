P_NAME			= dbus
P_VERSION		= 1.12.10
P_DESCRIPTION	= D-Bus is a message bus system, a simple way for applications to talk to one another.
P_ARCHIVE		= dbus-1.12.10.tar.gz
P_URL			= https://dbus.freedesktop.org/releases/dbus/$(P_ARCHIVE)
P_LICENCES		= MIT
P_ARCHS			= arm
P_DEPENDS		= expat
P_SRCDIR		= dbus-1.12.10

.PHONY: fetch setup compile install

fetch:
	cookie fetch $(P_URL) $(P_ARCHIVE)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	./configure 				\
		--prefix=/usr 			\
		--sysconfdir=/etc		\
		--localstatedir=/var	\
		--disable-doxygen-docs	\
		--disable-xml-docs		\
		--with-dbus-user=root	\
		--host=$(HOST)
	make -j$(NPROCS)

install:
	make DESTDIR=$(P_DESTDIR) install
	rm -rf $(P_DESTDIR)/usr/share/doc
	rm -rf $(P_DESTDIR)/etc/dbus-1
	fix-la-files $(P_DESTDIR)
