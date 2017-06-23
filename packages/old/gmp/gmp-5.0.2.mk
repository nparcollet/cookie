P_NAME		:= gmp
P_VERSION	:= 5.0.2
P_LICENCE	:= LGPL
P_DESC		:= Library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating point numbers.
P_DISTFILES	:= http://ftp.gnu.org/gnu/$(P_NAME)/$(P_NAME)-$(P_VERSION).tar.bz2
P_DEPENDS	:= libc
P_PROVIDES	:= 
P_FLAGS		:=

clean:
	rm -rf $(STAGING)
	rm -rf $(WORKDIR)/build

setup:
	for d in $(P_DISTFILES); do [ -e $(DISTFILES)/$${d##*/} ] || wget -c $$d -O $(DISTFILES)/$${d##*/}; done
	[ -e $(WORKDIR)/$(P_NAME)-$(P_VERSION) ] || cd $(WORKDIR) && tar xjf $(DISTFILES)/$(P_NAME)-$(P_VERSION).tar.bz2

compile:
	mkdir -p $(WORKDIR)/build
	cd $(WORKDIR)/build && $(WORKDIR)/$(P_NAME)-$(P_VERSION)/configure \
		--prefix=/usr \
		--host=$(CHOST) \
		--enable-fft \
		--enable-mpbsd \
		--enable-cxx
	cd $(WORKDIR)/build && make $(PARALLEL_JOBS)

install:
	cd $(WORKDIR)/build && make DESTDIR=$(STAGING) install-strip
	rm -rf $(STAGING)/usr/share
