P_NAME		:= less
P_VERSION	:= 451
P_LICENCE	:= TODO
P_DESC		:= TODO
P_DEPENDS	:= ncurses
P_DISTFILES := http://ftp.gnu.org/gnu/$(P_NAME)/$(P_NAME)-$(P_VERSION).tar.gz

clean:
	rm -rf $(WORKDIR)/$(P_NAME)-$(P_VERSION)
	rm -rf $(WORKDIR)/$(P_NAME)-$(P_VERSION).tar

setup:
	mkdir -p $(WORKDIR)
	for d in $(P_DISTFILES); do [ -e $(WORKDIR)/$${d##*/} ] || wget -c $$d -O $(WORKDIR)/$${d##*/}; done
	cd $(WORKDIR) && tar xzf $(WORKDIR)/$(P_NAME)-$(P_VERSION).tar.gz

compile:
	echo "ac_cv_lib_ncurses_initscr=${ac_cv_lib_ncurses_initscr=yes}"	>> $(WORKDIR)/$(P_NAME)-$(P_VERSION)/config.cache
	echo "ac_cv_lib_ncursesw_initscr=${ac_cv_lib_ncursesw_initscr=no}"	>> $(WORKDIR)/$(P_NAME)-$(P_VERSION)/config.cache
	cd $(WORKDIR)/$(P_NAME)-$(P_VERSION) && ./configure --cache-file=config.cache --host=$(CHOST) --prefix=/usr --sysconfdir=/etc
	cd $(WORKDIR)/$(P_NAME)-$(P_VERSION) && make -j

install:
	cd $(WORKDIR)/$(P_NAME)-$(P_VERSION) && make DESTDIR=$(DESTDIR) install-strip
