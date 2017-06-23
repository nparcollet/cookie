P_NAME		:= perl
P_VERSION	:= 5.16.3
P_LICENCE	:= GPL1 || ARTISTIC
P_DESC		:= Perl 5 is a highly capable, feature-rich programming language with over 25 years of development.
P_DISTFILES := http://www.cpan.org/src/5.0/$(P_NAME)-$(P_VERSION).tar.gz http://prdownload.berlios.de/perlcross/perl-$(P_VERSION)-cross-0.7.4.tar.gz
P_DEPENDS	:= libc

clean:
	rm -rf $(WORKDIR)/$(P_NAME)-$(P_VERSION)
	rm -rf $(STAGING)

setup:
	mkdir -p $(WORKDIR)
	for d in $(P_DISTFILES); do [ -e $(WORKDIR)/$${d##*/} ] || wget -c $$d -O $(WORKDIR)/$${d##*/}; done
	cd $(WORKDIR) && tar xzf $(P_NAME)-$(P_VERSION).tar.gz
	cd $(WORKDIR)/$(P_NAME)-$(P_VERSION) && tar xzf $(WORKDIR)/perl-$(P_VERSION)-cross-0.7.4.tar.gz --strip-components=1

compile:
	cd $(WORKDIR)/$(P_NAME)-$(P_VERSION) && ./configure --prefix=/ --target=$(CHOST)
	cd $(WORKDIR)/$(P_NAME)-$(P_VERSION) && make -j1

install:
	cd $(WORKDIR)/$(P_NAME)-$(P_VERSION) && make DESTDIR=$(STAGING) install
	rm -rf $(STAGING)/usr/share
	for a in $$(find $(STAGING) -executable -type f); chmod u+w $$a; $(CHOST)-strip $$a; chmod u-w $$a; done
