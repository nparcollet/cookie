P_NAME			= rpi3b-sysroot
P_VERSION		= 0.1.0
P_DESCRIPTION	= Base sysroot imported from the toolchain
P_LICENCES		= Cookie
P_ARCHS			= arm
P_PROVIDES		= sysroot libc
P_DEPENDS		=

fetch:

setup:

compile:

install:
	mkdir -p $(P_DESTDIR)
	cp -a /opt/target/toolchain/arm-rpi-linux-gnueabihf/sysroot/* $(P_DESTDIR)/
	# NOTE: Remove these to take install sources headers instead
	#rm -rf $(P_DESTDIR)/usr/include/linux
	#rm -rf $(P_DESTDIR)/usr/include/asm
	#rm -rf $(P_DESTDIR)/usr/include/asm-generic
	#rm -rf $(P_DESTDIR)/usr/include/misc
	#rm -rf $(P_DESTDIR)/usr/include/rdma
	#rm -rf $(P_DESTDIR)/usr/include/xen
	#rm -rf $(P_DESTDIR)/usr/include/drm
	#rm -rf $(P_DESTDIR)/usr/include/sound
	#rm -rf $(P_DESTDIR)/usr/include/video
	#rm -rf $(P_DESTDIR)/usr/include/mtd
	#rm -rf $(P_DESTDIR)/usr/include/scsi
