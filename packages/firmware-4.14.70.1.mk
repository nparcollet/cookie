P_NAME			= firmware
P_VERSION		= 4.14.70.1
P_DESCRIPTION	= Proprietary Binaries for Raspberry PI board, does not include the kernel
P_URL   		= https://www.raspberrypi.org/documentation/firmware
P_LICENCES		= Broadcom
P_ARCHS			= arm arm64
P_ARCHIVE       = 1.20180919.tar.gz
P_SRCDIR		= firmware-1.20180919
P_DEPENDS		=

fetch:
	cookie fetch https://github.com/raspberrypi/firmware/archive/$(P_ARCHIVE)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:

install:
	mkdir -p $(P_DESTDIR)/boot
	cp boot/bootcode.bin $(P_DESTDIR)/boot/
	cp boot/*.elf $(P_DESTDIR)/boot/
	cp boot/*.dat $(P_DESTDIR)/boot/
	mkdir -p $(P_DESTDIR)/usr
	cp -a  hardfp/opt/vc/include $(P_DESTDIR)/usr
	cp -a  hardfp/opt/vc/lib  $(P_DESTDIR)/usr
	cp -a  hardfp/opt/vc/bin $(P_DESTDIR)/usr
	cp -a  hardfp/opt/vc/sbin $(P_DESTDIR)/usr
	sed -e 's#/opt/vc#/usr#g' -i $(P_DESTDIR)/usr/lib/pkgconfig/*.pc
