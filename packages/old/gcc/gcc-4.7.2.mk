P_NAME		:= gcc
P_VERSION	:= 4.7.2
P_LICENCE	:= LGPL
P_DESC		:=
P_DISTFILES	:= http://ftp.gnu.org/gnu/$(P_NAME)/$(P_NAME)-$(P_VERSION)/$(P_NAME)-$(P_VERSION).tar.bz2
P_DEPENDS	:= gmp mpfr mpc libc zlib
P_PROVIDES	:= 
P_FLAGS		:=

clean:
	rm -rf $(STAGING)
	rm -rf $(WORKDIR)/build
	rm -rf $(WORKDIR)/$(P_NAME)-$(P_VERSION)

setup:
	for d in $(P_DISTFILES); do [ -e $(DISTFILES)/$${d##*/} ] || wget -c $$d -O $(DISTFILES)/$${d##*/}; done
	cd $(WORKDIR) && tar xjf $(DISTFILES)/$(P_NAME)-$(P_VERSION).tar.bz2

compile:
	mkdir -p $(WORKDIR)/build	
	cd $(WORKDIR)/build && $(WORKDIR)/$(P_NAME)-$(P_VERSION)/configure \
		--prefix=/usr \
		--host=$(CHOST) \
		--target=$(CHOST) \
		--libexecdir=/usr/lib \
		--enable-shared \
		--enable-threads=posix \
		--enable-__cxa_atexit \
		--disable-nls \
		--enable-languages=c,c++ \
		--disable-multilib \
		--disable-bootstrap \
		--with-build-sysroot=$(SYSROOT) \
		--with-system-zlib
	cd $(WORKDIR)/build && make $(PARALLEL_JOBS)

install:
	cd $(WORKDIR)/build && make $(PARALLEL_JOBS) DESTDIR=$(STAGING) install-strip
	ln -sfv gcc $(STAGING)/usr/bin/cc
	rm -rf $(STAGING)/usr/share/info
	rm -rf $(STAGING)/usr/share/man
