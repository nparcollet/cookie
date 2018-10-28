P_NAME			= layout
P_VERSION		= 0.1.0
P_DESCRIPTION	= Base roofs fs layout and configuration files
P_LICENCES		= ASIS
P_ARCHS			= arm
P_SRCDIR		= layout

.PHONY: fetch setup compile install

fetch:
	cookie import layout.tgz layout.tgz
	tar xzf layout.tgz
	rm layout.tgz

setup:
	@echo "nothing to setup"

compile:
	@echo "nothing to compile"

install:
	mkdir -p $(P_DESTDIR)
	cp -a . $(P_DESTDIR)/
	mkdir -p $(P_DESTDIR)/boot
	cookie import cmdline.txt $(P_DESTDIR)/boot/
	cookie import config.txt $(P_DESTDIR)/boot/
