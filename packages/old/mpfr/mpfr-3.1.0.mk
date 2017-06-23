P_NAME		:= mpfr
P_VERSION	:= 3.1.0
P_LICENCE	:= LGPL
P_DESC		:= The MPFR library is a C library for multiple-precision floating-point computations with correct rounding.
P_DISTFILES	:= http://ftp.gnu.org/gnu/$(P_NAME)/$(P_NAME)-$(P_VERSION).tar.bz2
P_DEPENDS	:= gmp libc
P_PROVIDES	:=
P_FLAGS		:=

clean:
	rm -rf $(STAGING)
	rm -rf $(WORKDIR)/build

setup:
	for d in $(P_DISTFILES); do [ -e $(DISTFILES)/$${d##*/} ] || wget -c $$d -O $(DISTFILES)/$${d##*/}; done
	cd $(WORKDIR) && tar xjf $(DISTFILES)/$(P_NAME)-$(P_VERSION).tar.bz2

compile:
	mkdir -p $(WORKDIR)/build
	cd $(WORKDIR)/build && $(WORKDIR)/$(P_NAME)-$(P_VERSION)/configure --prefix=/usr --host=$(CHOST)
	cd $(WORKDIR)/build && make $(PARALLEL_JOBS)

install:
	cd $(WORKDIR)/build && make DESTDIR=$(STAGING) install-strip
	rm -rf $(STAGING)/usr/share
