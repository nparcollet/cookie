P_NAME		:= bison
P_VERSION	:= 2.7.1
P_LICENCE	:= TODO
P_DESC		:= Bison is a general-purpose parser generator that converts an annotated context-free grammar into a deterministic LR or generalized LR (GLR) parser employing LALR(1) parser tables.
P_DEPENDS	:=
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
