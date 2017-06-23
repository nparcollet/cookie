P_NAME		:= mpc
P_VERSION	:= 1.0.1
P_LICENCE	:= LGPL
P_DESC		:= Gnu Mpc is a C library for the arithmetic of complex numbers with arbitrarily high precision and correct rounding of the resul
P_DISTFILES	:= http://ftp.gnu.org/gnu/$(P_NAME)/$(P_NAME)-$(P_VERSION).tar.gz
P_DEPENDS	:= gmp mpfr
P_PROVIDES	:=
P_FLAGS		:=

clean:
	rm -rf $(STAGING)
	rm -rf $(WORKDIR)/build

setup:
	for d in $(P_DISTFILES); do [ -e $(DISTFILES)/$${d##*/} ] || wget -c $$d -O $(DISTFILES)/$${d##*/}; done
	cd $(WORKDIR) && tar xzf $(DISTFILES)/$(P_NAME)-$(P_VERSION).tar.gz
compile:
	mkdir -p $(WORKDIR)/build
	cd $(WORKDIR)/build && $(WORKDIR)/$(P_NAME)-$(P_VERSION)/configure --prefix=/usr --host=$(CHOST)
	cd $(WORKDIR)/build && make $(PARALLEL_JOBS)

install:
	cd $(WORKDIR)/build && make DESTDIR=$(STAGING) install-strip
	rm -rf $(STAGING)/usr/share

