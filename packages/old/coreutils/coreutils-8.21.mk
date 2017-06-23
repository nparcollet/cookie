P_NAME		:= coreutils
P_VERSION	:= 8.21
P_LICENCE	:= GPL3
P_DESC		:= The GNU Core Utilities are the basic file, shell and text manipulation utilities of the GNU operating system.
P_DISTFILES	:= http://ftp.gnu.org/gnu/coreutils/$(P_NAME)-$(P_VERSION).tar.xz
P_DEPENDS	:= libc
P_PROVIDES	:=
P_FLAGS		:=

clean:
	rm -rf $(STAGING)
	rm -rf $(WORKDIR)/build
	rm -rf $(WORKDIR)/$(P_NAME)-$(P_VERSION)

setup:
	for d in $(P_DISTFILES); do [ -e $(DISTFILES)/$${d##*/} ] || wget -c $$d -O $(DISTFILES)/$${d##*/}; done
	cd $(WORKDIR) && tar xJf $(DISTFILES)/$(P_NAME)-$(P_VERSION).tar.xz

compile:
	mkdir -p $(WORKDIR)/build
	cd $(WORKDIR)/build && $(WORKDIR)/$(P_NAME)-$(P_VERSION)/configure --host=$(CHOST) --prefix=/usr --enable-hostname --disable-nls --without-gmp
	cd $(WORKDIR)/build && make -j1

install:
	cd $(WORKDIR)/build && make DESTDIR=$(STAGING) install-strip
	rm -rf $(STAGING)/usr/share
