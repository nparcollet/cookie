P_NAME		:= zlib
P_VERSION	:= 1.2.8
P_LICENCE	:= ZLIB
P_DESC		:= A Massively Spiffy Yet Delicately Unobtrusive Compression Library
P_DISTFILES	:= http://zlib.net/$(P_NAME)-$(P_VERSION).tar.gz
P_DEPENDS	:= libc
P_PROVIDES	:=
P_FLAGS		:=

clean:
	rm -rf $(STAGING)
	rm -rf $(WORKDIR)/build

setup:
	for d in $(P_DISTFILES); do [ -e $(DISTFILES)/$${d##*/} ] || wget -c $$d -O $(DISTFILES)/$${d##*/}; done
	cd $(WORKDIR)  && tar xzf $(DISTFILES)/$(P_NAME)-$(P_VERSION).tar.gz

compile:
	cp -a $(WORKDIR)/$(P_NAME)-$(P_VERSION) $(WORKDIR)/build
	cd $(WORKDIR)/build && $(WORKDIR)/$(P_NAME)-$(P_VERSION)/configure --prefix=/usr
	cd $(WORKDIR)/build && make $(PARALLEL_JOBS)

install:
	cd $(WORKDIR)/build && make DESTDIR=$(STAGING) install
	rm -rf $(STAGING)/usr/share
	strip $(STAGING)/usr/lib/libz.so.$(P_VERSION)
	strip $(STAGING)/usr/lib/libz.a
