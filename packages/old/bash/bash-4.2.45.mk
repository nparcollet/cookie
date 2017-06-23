P_NAME		:= bash
P_VERSION	:= 4.2.45
P_LICENCE	:= GPL3
P_DESC		:= Bash is the shell, or command language interpreter, that will appear in the GNU operating system.
P_DISTFILES	:= http://ftp.gnu.org/gnu/bash/$(P_NAME)-4.2.tar.gz $(shell seq -f http://ftp.gnu.org/gnu/bash/bash-4.2-patches/bash42-%03g -s' ' 1 45)
P_DEPENDS	:= ncurses libc
P_PROVIDES	:=
P_FLAGS		:=

clean:
	rm -rf $(STAGING)
	rm -rf $(WORKDIR)/build

setup:
	for d in $(P_DISTFILES); do [ -e $(DISTFILES)/$${d##*/} ] || wget -c $$d -O $(DISTFILES)/$${d##*/}; done
	cd $(WORKDIR) && tar xzf $(DISTFILES)/$(P_NAME)-4.2.tar.gz
	cd $(WORKDIR)/$(P_NAME)-4.2 && for p in $$(seq -f %03g 1 45); do patch -p0 < $(DISTFILES)/bash42-$$p; done

compile:
	mkdir -p $(WORKDIR)/build
	cd $(WORKDIR)/build && $(WORKDIR)/$(P_NAME)-4.2/configure --host=$(CHOST) --prefix=/ --host=$(CHOST) --disable-nls --without-installed-readline --with-curses
	cd $(WORKDIR)/build && make $(PARALLEL_JOBS)

install:
	cd $(WORKDIR)/build && make DESTDIR=$(STAGING) install-strip
	ln -sv bash $(STAGING)/bin/sh
	rm -rf $(STAGING)/share
