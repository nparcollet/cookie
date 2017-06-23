P_NAME		:= flex
P_VERSION	:= 2.5.37
P_LICENCE	:= BSD
P_DESC		:= Fast lexical analyzer
P_DEPENDS	:= libc
P_DISTFILES := http://downloads.sourceforge.net/project/$(P_NAME)/$(P_NAME)-$(P_VERSION).tar.bz2

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
	cd $(WORKDIR)/$(P_NAME)-$(P_VERSION) && make DESTDIR=$(DESTDIR) install-strip
	rm -rf $(DESTDIR)/usr/share
