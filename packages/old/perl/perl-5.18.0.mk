P_NAME		:= perl
P_VERSION	:= 5.18.0
P_LICENCE	:= TODO
P_DESC		:= TODO
P_DISTFILES := http://www.cpan.org/src/5.0/$(P_NAME)-$(P_VERSION).tar.gz
P_DEPENDS	:= libc

clean:
	rm -rf $(WORKDIR)/$(P_NAME)-$(P_VERSION)

setup:
	mkdir -p $(WORKDIR)
	for d in $(P_DISTFILES); do [ -e $(WORKDIR)/$${d##*/} ] || wget -c $$d -O $(WORKDIR)/$${d##*/}; done
	cd $(WORKDIR) && tar xzf $(P_NAME)-$(P_VERSION).tar.gz

compile:
	cd $(WORKDIR)/$(P_NAME)-$(P_VERSION) && CC=$(CHOST)-gcc ./configure.gnu --prefix=/usr
	cd $(WORKDIR)/$(P_NAME)-$(P_VERSION) && make -j
	#cd $(WORKDIR)/$(P_NAME)-$(P_VERSION) && sh Configure -des -Duse32bitall -Dcc=$(CHOST)-gcc -Dprefix=/usr -Dvendorprefix=/usr -Dman1dir=/usr/share/man/man1 -Dman3dir=/usr/share/man/man3 -Dpager="/usr/bin/less -isR" -Duseshrplib
	#cd $(WORKDIR)/$(P_NAME)-$(P_VERSION) && make -j

install:
	cd $(WORKDIR)/$(P_NAME)-$(P_VERSION) && make DESTDIR=$(DESTDIR) install-strip

