P_NAME		:= pkg-config
P_VERSION	:= 0.28
P_LICENCE	:= GPL2
P_DESC		:= pkg-config is a helper tool used when compiling applications and libraries.
P_DEPENDS	:=
P_DISTFILES := http://pkgconfig.freedesktop.org/releases/$(P_NAME)-$(P_VERSION).tar.gz

clean:
	rm -rf $(WORKDIR)/$(P_NAME)-$(P_VERSION)

setup:
	mkdir -p $(WORKDIR)
	for d in $(P_DISTFILES); do [ -e $(WORKDIR)/$${d##*/} ] || wget -c $$d -O $(WORKDIR)/$${d##*/}; done
	cd $(WORKDIR) && tar xzf $(P_NAME)-$(P_VERSION).tar.gz

compile:
	cd $(WORKDIR)/$(P_NAME)-$(P_VERSION) && ./configure --host=$(CHOST) --prefix=/usr --with-internal-glib --disable-host-tool --disable-doc --disable-nls
	cd $(WORKDIR)/$(P_NAME)-$(P_VERSION) && make -j

install:
	cd $(WORKDIR)/$(P_NAME)-$(P_VERSION) && make DESTDIR=$(DESTDIR) install-strip
	rm -rf $(DESTDIR)/usr/share/doc
	rm -rf $(DESTDIR)/usr/share/man
