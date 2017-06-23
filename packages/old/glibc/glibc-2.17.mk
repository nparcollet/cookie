P_NAME		:= glibc
P_VERSION	:= 2.17
P_LICENCE	:= LGPL
P_DESC		:= GNU Project's implementation of the C standard library
P_DISTFILES	:= http://ftp.gnu.org/gnu/$(P_NAME)/$(P_NAME)-$(P_VERSION).tar.bz2
P_DEPENDS	:= linux-headers
P_PROVIDES	:= libc
P_FLAGS		:=

clean:
	rm -rf $(STAGING)
	rm -rf $(WORKDIR)/build

setup:
	for d in $(P_DISTFILES); do [ -e $(DISTFILES)/$${d##*/} ] || wget -c $$d -O $(DISTFILES)/$${d##*/}; done
	cd $(WORKDIR) && tar xjf $(DISTFILES)/$(P_NAME)-$(P_VERSION).tar.bz2

compile:
	echo $(CFLAGS)
	mkdir -p $(WORKDIR)/build
	cd $(WORKDIR)/build && CFLAGS="-O2" $(WORKDIR)/$(P_NAME)-$(P_VERSION)/configure \
		--host=$(CHOST) \
		--prefix=/usr \
		--disable-profile \
		--enable-kernel=2.6.32 \
		--enable-add-ons=nptl \
		--disable-nls \
		--with-headers=$(SYSROOT)/usr/include \
		--enable-shared \
		--disable-static
	cd $(WORKDIR)/build && make $(PARALLEL_JOBS)

install:
	mkdir -p $(STAGING)/etc
	touch $(STAGING)/etc/ld.so.conf
	cd $(WORKDIR)/build && make $(PARALLEL_JOBS) install_root=$(STAGING) install
	cp -v $(WORKDIR)/$(P_NAME)-$(P_VERSION)/sunrpc/rpc/*.h $(STAGING)/usr/include/rpc
	cp -v $(WORKDIR)/$(P_NAME)-$(P_VERSION)/sunrpc/rpcsvc/*.h $(STAGING)/usr/include/rpcsvc
	cp -v $(WORKDIR)/$(P_NAME)-$(P_VERSION)/nis/rpcsvc/*.h $(STAGING)/usr/include/rpcsvc
