P_NAME			= layout
P_VERSION		= 0.1.0
P_DESCRIPTION	= Base filesystem layout, configuration and services
P_LICENCES		= MIT
P_GITURL		= https://github.com/nparcollet/layout.git
P_GITREV		= HEAD
P_ARCHS			= arm
P_SRCDIR		= layout

.PHONY: fetch setup compile install

fetch:
	cookie git clone $(P_GITURL) $(P_NAME)

setup:
	cookie git checkout $(P_NAME) $(P_GITREV) $(P_SRCDIR)

compile:
	@echo "nothing to compile"

install:
	mkdir -p $(P_DESTDIR)
	cp -a . $(P_DESTDIR)/
	find $(P_DESTDIR) -name '*.keep' | xargs rm
	rm -rf $(P_DESTDIR)/.git
	rm $(P_DESTDIR)/README.md
	mkdir -p $(P_DESTDIR)/boot
	cookie import cmdline.txt $(P_DESTDIR)/boot/cmdline.txt
	cookie import config.txt $(P_DESTDIR)/boot/config.txt
