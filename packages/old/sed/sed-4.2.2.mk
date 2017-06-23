P_NAME		:= sed
P_VERSION	:= 4.2.2
P_LICENCE	:= TODO
P_DESC		:= TODO
P_DEPENDS	:=
P_DISTFILES := http://ftp.gnu.org/gnu/$(P_NAME)/$(P_NAME)-$(P_VERSION).tar.gz

clean:
	rm -rf $(WORKDIR)/$(P_NAME)-$(P_VERSION)
	rm -rf $(WORKDIR)/$(P_NAME)-$(P_VERSION).tar

setup:
	mkdir -p $(WORKDIR)
	for d in $(P_DISTFILES); do [ -e $(WORKDIR)/$${d##*/} ] || wget -c $$d -O $(WORKDIR)/$${d##*/}; done
	cd $(WORKDIR) && tar xf $(WORKDIR)/$(P_NAME)-$(P_VERSION).tar.gz

compile:
	cd $(WORKDIR)/$(P_NAME)-$(P_VERSION) && ./configure --host=$(CHOST) --prefix=/
	cd $(WORKDIR)/$(P_NAME)-$(P_VERSION) && make -j

install:
	cd $(WORKDIR)/$(P_NAME)-$(P_VERSION) && make DESTDIR=$(DESTDIR) install-strip
