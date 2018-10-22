P_NAME			= layout
P_VERSION		= 0.1.0
P_DESCRIPTION	= Base roofs fs layout and configuration files
P_LICENCES		= ASIS
P_ARCHS			= arm

.PHONY: fetch setup compile install

# TODO: MAKE A REPOSITORY WITH THE FILES INSTEAD

fetch:
	@echo "nothing to fetch"

setup:
	@echo "nothing to setup"

compile:
	@echo "nothing to compile"

install:

	mkdir -p $(P_DESTDIR)/dev
	mkdir -p $(P_DESTDIR)/proc
	mkdir -p $(P_DESTDIR)/root
	mkdir -p $(P_DESTDIR)/run
	mkdir -p $(P_DESTDIR)/sys
	mkdir -p $(P_DESTDIR)/tmp
	mkdir -p $(P_DESTDIR)/var
	mkdir -p $(P_DESTDIR)/var/log
	mkdir -p $(P_DESTDIR)/var/snes9x
	mkdir -p $(P_DESTDIR)/media
	mkdir -p $(P_DESTDIR)/usr
	mkdir -p $(P_DESTDIR)/usr/bin
	mkdir -p $(P_DESTDIR)/etc
	mkdir -p $(P_DESTDIR)/etc/init.d

	cookie import fstab			$(P_DESTDIR)/etc/fstab
	cookie import inittab		$(P_DESTDIR)/etc/inittab
	cookie import rcS			$(P_DESTDIR)/etc/init.d/rcS
	cookie import hostname		$(P_DESTDIR)/etc/hostname.conf
	cookie import passwd		$(P_DESTDIR)/etc/passwd
	cookie import group			$(P_DESTDIR)/etc/group
	cookie import shells		$(P_DESTDIR)/etc/shells
	cookie import fb.modes		$(P_DESTDIR)/etc/fb.modes
	cookie import asound.conf	$(P_DESTDIR)/etc/asound.conf
	cookie import mdev.conf		$(P_DESTDIR)/etc/mdev.conf
	cookie import automount.sh	$(P_DESTDIR)/usr/bin/automount.sh
