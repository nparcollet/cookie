P_NAME		= opkg
P_VERSION	= 0.3.4
P_URL		= http://git.yoctoproject.org/cgit/cgit.cgi/$(P_NAME)/snapshot/$(P_NAME)-$(P_VERSION).tar.bz2

setup:
	cookie fetch  $(P_URL)
	cookie extract $(P_NAME)-$(P_VERSION).tar.bz2 $(P_WORKDIR)

compile:
	cd $(P_WORKDIR)/$(P_NAME)-$(P_VERSION)							\
		&& autoreconf -if								\
		&& ./configure --prefix=/usr --disable-curl --disable-openssl --disable-gpg	\
		&& make $(P_MAKEOPTS)

install:
	cd $(P_WORKDIR)/$(P_NAME)-$(P_VERSION)							\
		 && make DESTDIR=$(P_WORKDIR)/staging install

