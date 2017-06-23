P_NAME		:= libtool
P_VERSION	:= 2.4.2
P_LICENCE	:= TODO
P_DESC		:= TODO
P_DEPENDS	:= sed
P_DISTFILES := http://ftp.gnu.org/gnu/$(P_NAME)/$(P_NAME)-$(P_VERSION).tar.xz

clean:
	rm -rf $(WORKDIR)/$(P_NAME)-$(P_VERSION)
	rm -rf $(WORKDIR)/$(P_NAME)-$(P_VERSION).tar

setup:
	mkdir -p $(WORKDIR)
	for d in $(P_DISTFILES); do [ -e $(WORKDIR)/$${d##*/} ] || wget -c $$d -O $(WORKDIR)/$${d##*/}; done
	cd $(WORKDIR) && xz --keep -d $(WORKDIR)/$(P_NAME)-$(P_VERSION).tar.xz
	cd $(WORKDIR) && tar xf $(WORKDIR)/$(P_NAME)-$(P_VERSION).tar

compile:
	cd $(WORKDIR)/$(P_NAME)-$(P_VERSION) && ./configure --host=$(CHOST) --prefix=/usr
	cd $(WORKDIR)/$(P_NAME)-$(P_VERSION) && make -j

install:
	cd $(WORKDIR)/$(P_NAME)-$(P_VERSION) && make DESTDIR=$(DESTDIR) install-strip
