P_NAME		:= ncurses
P_VERSION	:= 5.9
P_LICENCE	:= NCURSES
P_DESC		:= API which allows the programmer to write text-based user interfaces in a terminal-independent manner.
P_DEPENDS	:= libc
P_DISTFILES	:= http://ftp.gnu.org/gnu/$(P_NAME)/$(P_NAME)-$(P_VERSION).tar.gz
P_PROVIDES	:=

clean:
	rm -rf $(STAGING)
	rm -rf $(WORKDIR)/build


setup:
	for d in $(P_DISTFILES); do [ -e $(DISTFILES)/$${d##*/} ] || wget -c $$d -O $(DISTFILES)/$${d##*/}; done
	cd $(WORKDIR) && tar xzf $(DISTFILES)/$(P_NAME)-$(P_VERSION).tar.gz

compile:
	mkdir -p $(WORKDIR)/build
	cd $(WORKDIR)/build && $(WORKDIR)/$(P_NAME)-$(P_VERSION)/configure --host=$(CHOST) --prefix=/usr --without-debug --enable-pc-files --enable-widec --enable-pc-files --without-manpages --without-tests
	cd $(WORKDIR)/build && make $(PARALLEL_JOBS)

install:
	cd $(WORKDIR)/build && make DESTDIR=$(STAGING) install
	for lib in ncurses form panel menu ; do rm -vf $(STAGING)/usr/lib/lib$${lib}.so ; echo "INPUT(-l$${lib}w)" > $(STAGING)/usr/lib/lib$${lib}.so ; ln -sfv lib$${lib}w.a $(STAGING)/usr/lib/lib$${lib}.a ; done
	ln -sfv libncurses++w.a $(STAGING)/usr/lib/libncurses++.a
	rm -vf $(STAGING)/usr/lib/libcursesw.so
	echo "INPUT(-lncursesw)" > $(STAGING)/usr/lib/libcursesw.so
	ln -sfv libncurses.so $(STAGING)/usr/lib/libcurses.so
	ln -sfv libncursesw.a $(STAGING)/usr/lib/libcursesw.a
	ln -sfv libncurses.a $(STAGING)/usr/lib/libcurses.a
