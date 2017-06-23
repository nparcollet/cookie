P_NAME		= opkg-utils
P_VERSION	= 0.3.4
P_URL		= http://git.yoctoproject.org/cgit/cgit.cgi/$(P_NAME)/snapshot/$(P_NAME)-$(P_VERSION).tar.bz2

setup:
	cookie fetch  $(P_URL)
	cookie extract $(P_NAME)-$(P_VERSION).tar.bz2 $(P_WORKDIR)

compile:
	cat $(P_WORKDIR)/$(P_NAME)-$(P_VERSION)/Makefile
	cd $(P_WORKDIR)/$(P_NAME)-$(P_VERSION)					\
		&& make

install:
	cd $(P_WORKDIR)/$(P_NAME)-$(P_VERSION)					\
		&& make PREFIX=/usr DESTDIR=$(P_WORKDIR)/staging install	\
		&& mv $(P_WORKDIR)/staging/usr/bin/update-alternatives $(P_WORKDIR)/staging/usr/bin/update-alternatives-opkg

