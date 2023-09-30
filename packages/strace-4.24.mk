P_NAME			= strace
P_VERSION		= 4.24
P_DESCRIPTION	= Diagnostic, debugging and instructional userspace utility for Linux
P_GITURL		= https://github.com/strace/strace.git
P_GITREV		= v4.24
P_LICENCES		= Berkeley
P_ARCHS			= arm
P_DEPENDS		=
P_SRCDIR		= sources

.PHONY: fetch setup compile install

fetch:
	cookie git clone $(P_GITURL) $(P_NAME)

setup:
	cookie git checkout $(P_NAME) $(P_GITREV) $(P_SRCDIR)

compile:
	./bootstrap
	./configure --host=$(HOST) --prefix=/usr
	make -j$(NPROCS)

install:
	make DESTDIR=$(P_DESTDIR) install-strip
	rm -rf $(P_DESTDIR)/usr/share
