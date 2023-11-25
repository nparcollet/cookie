P_NAME			= layout
P_VERSION		= 0.1.0
P_DESCRIPTION	= Base filesystem layout, configuration and services
P_LICENCES		= MIT
P_GITURL		= https://github.com/nparcollet/layout.git
P_GITREV		= HEAD
P_ARCHS			= arm arm64
P_SRCDIR		= layout
P_FILES 		= config.txt cmdline.txt

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
	cp $(P_FILESDIR)/cmdline.txt $(P_DESTDIR)/boot/cmdline.txt
	cp $(P_FILESDIR)/config.txt $(P_DESTDIR)/boot/config.txt
