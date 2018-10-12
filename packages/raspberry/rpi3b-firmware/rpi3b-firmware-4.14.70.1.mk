P_NAME			= rpi3b-firmware
P_VERSION		= 4.14.70.1
P_DESCRIPTION	= Proprietary Binaries for Raspberry PI (Release 1.20180919.1)
P_URL   		= https://www.raspberrypi.org/documentation/firmware
P_LICENCES		= Broadcom
P_ARCHS			= arm
P_ARCHIVE       = 1.20180919.tar.gz
P_SRCDIR		= firmware-1.20180919
P_DEPENDS		=
P_PROVIDES		= firmware

fetch:
	cookie fetch https://github.com/raspberrypi/firmware/archive/$(P_ARCHIVE)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)
	cookie import config.txt $(P_SRCDIR)/config.txt
	cookie import cmdline.txt $(P_SRCDIR)/cmdline.txt

compile:

install:
	mkdir -p $(P_DESTDIR)/boot
	cp boot/bootcode.bin $(P_DESTDIR)/boot/
	cp boot/*.elf $(P_DESTDIR)/boot/
	cp boot/*.dat $(P_DESTDIR)/boot/
	cp cmdline.txt $(P_DESTDIR)/boot/
	cp config.txt $(P_DESTDIR)/boot/
	mkdir -p $(P_DESTDIR)/usr
	cp -a  hardfp/opt/vc/include $(P_DESTDIR)/usr
	cp -a  hardfp/opt/vc/lib  $(P_DESTDIR)/usr
	cp -a  hardfp/opt/vc/bin $(P_DESTDIR)/usr
	cp -a  hardfp/opt/vc/sbin $(P_DESTDIR)/usr
