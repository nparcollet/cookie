P_NAME		:= readline
P_VERSION	:= 6.2.4
P_LICENCE	:= GPL3
P_DESC		:= The GNU Readline library provides a set of functions for use by applications that allow users to edit command lines as they are typed in.
P_DISTFILES := http://ftp.gnu.org/gnu/readline/readline-6.2.tar.gz $(shell seq -f http://ftp.gnu.org/gnu/readline/readline-6.2-patches/readline62-%03g -s' ' 1 4)
P_DEPENDS	:= ncurses
P_PROVIDES	:=

clean:
	rm -rf $(WORKDIR)/$(P_NAME)-6.2
	rm -rf $(STAGING)

setup:
	mkdir -p $(WORKDIR)
	for d in $(P_DISTFILES); do [ -e $(WORKDIR)/$${d##*/} ] || wget -c $$d -O $(WORKDIR)/$${d##*/}; done
	cd $(WORKDIR) && tar xzf $(P_NAME)-6.2.tar.gz
	cd $(WORKDIR)/$(P_NAME)-6.2 && for p in $$(seq -f %03g 1 4); do patch -p0 < $(WORKDIR)/readline62-$$p; done

compile:
	cd $(WORKDIR)/$(P_NAME)-6.2 && ./configure --host=$(CHOST) SHLIB_LIBS=-lncurses --prefix=/usr --disable-nls
	cd $(WORKDIR)/$(P_NAME)-6.2 && make -j

install:
	cd $(WORKDIR)/$(P_NAME)-6.2 && make DESTDIR=$(STAGING) install-static
	cd $(WORKDIR)/$(P_NAME)-6.2 && make DESTDIR=$(STAGING) install-shared
	cd $(WORKDIR)/$(P_NAME)-6.2 && make DESTDIR=$(STAGING) install-headers
