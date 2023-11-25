P_NAME			= firmware
P_VERSION		= 1.20230405
P_DESCRIPTION	= Proprietary Binaries for Raspberry PI board, does not include the kernel
P_URL   		= https://github.com/raspberrypi/firmware
P_LICENCES		= Broadcom
P_ARCHS			= arm arm64
P_ARCHIVE       = 1.20230405.tar.gz
P_SRCDIR		= firmware-1.20230405
P_DEPENDS		=

fetch:
	cookie fetch https://github.com/raspberrypi/firmware/archive/refs/tags/$(P_ARCHIVE)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	#Expected to be build after install of firmwarre ...
	#CPPFLAGS="$CPPFLAGS -Iopt/vc/include" make -C opt/vc/src/hello_pi 

install:

	# From boot we only take what we cannot build (ie, bootcoode and BCM binary stuffs)
	mkdir -p $(P_DESTDIR)/boot
	cp boot/bootcode.bin $(P_DESTDIR)/boot/
	cp boot/*.elf $(P_DESTDIR)/boot/
	cp boot/*.dat $(P_DESTDIR)/boot/

	# Note: hardfp/opt/vc is for armv6, branch if ever needed
	mkdir -p $(P_DESTDIR)/usr
	cp -a  opt/vc/include $(P_DESTDIR)/usr
	cp -a  opt/vc/lib  $(P_DESTDIR)/usr
	cp -a  opt/vc/bin $(P_DESTDIR)/usr
	sed -e 's#/opt/vc#/usr#g' -i $(P_DESTDIR)/usr/lib/pkgconfig/*.pc

