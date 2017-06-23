P_NAME		:= make
P_VERSION	:= 3.82
P_LICENCE	:= GPL3
P_DESC		:= Tool which controls the generation of executables and other non-source files from as set of rules.
P_DEPENDS	:= libc
P_DISTFILES := http://ftp.gnu.org/gnu/make/$(P_NAME)-$(P_VERSION).tar.bz2

clean:
	rm -rf $(WORKDIR)/$(P_NAME)-$(P_VERSION)

setup:
	mkdir -p $(WORKDIR)
	for d in $(P_DISTFILES); do [ -e $(WORKDIR)/$${d##*/} ] || wget -c $$d -O $(WORKDIR)/$${d##*/}; done
	cd $(WORKDIR) && tar xjf $(P_NAME)-$(P_VERSION).tar.bz2

compile:
	cd $(WORKDIR)/$(P_NAME)-$(P_VERSION) && ./configure --host=$(CHOST) --prefix=/usr --disable-nls
	cd $(WORKDIR)/$(P_NAME)-$(P_VERSION) && make -j

install:
	mkdir -p $(DESTDIR)/usr/bin
	cp $(WORKDIR)/$(P_NAME)-$(P_VERSION)/make $(DESTDIR)/usr/bin
	$(CHOST)-strip $(DESTDIR)/usr/bin/make
