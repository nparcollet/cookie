P_NAME		:= binutils
P_VERSION	:= 2.22
P_LICENCE	:= TODO
P_DESC		:= TODO
P_DISTFILES	:= http://ftp.gnu.org/gnu/$(P_NAME)/$(P_NAME)-$(P_VERSION).tar.bz2
P_DEPENDS	:= libc zlib mpc mpfr gmp
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
	cd $(WORKDIR)/build && CFLAGS="-O2 -isystem $(SYSROOT)/usr/include" $(WORKDIR)/$(P_NAME)-$(P_VERSION)/configure \
		--host=$(CHOST) \
		--target=$(CHOST) \
		--enable-shared \
		--disable-multilib \
		--disable-nls \
		--prefix=/usr \
		--disable-werror \
		--with-build-sysroot=$(SYSROOT)

	cd $(WORKDIR)/build && make tooldir=/usr $(PARALLEL_JOBS) all

install:
	cd $(WORKDIR)/build && make tooldir=/usr $(PARALLEL_JOBS) DESTDIR=$(STAGING) install-strip
	rm -rf $(STAGING)/usr/share
	rm  $(STAGING)/usr/lib/libiberty.a
