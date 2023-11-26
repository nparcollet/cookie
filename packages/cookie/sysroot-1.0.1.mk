P_NAME			= sysroot
P_VERSION		= 1.0.1
P_DESCRIPTION	= Base sysroot imported from the target toolchain
P_LICENCES		=
P_ARCHS			= arm arm64
P_PROVIDES		= libc
P_DEPENDS		=

fetch:
	echo "No fetch phase"

setup:
	echo "No setup phase"

compile:
	echo "No compile phase"

install:
	mkdir -p $(P_DESTDIR)
	cp -a /opt/target/toolchain/$(P_TOOLCHAIN)/sysroot/* $(P_DESTDIR)/
	cp -a /opt/target/toolchain/$(P_TOOLCHAIN)/debug-root/usr/bin/*  $(P_DESTDIR)/usr/bin/
	cp -a /opt/target/toolchain/$(P_TOOLCHAIN)/debug-root/usr/lib/*  $(P_DESTDIR)/usr/lib/

	# These will re installed by the kernel, which obviously is needed anyway
	rm -rf $(P_DESTDIR)/usr/include/asm
	rm -rf $(P_DESTDIR)/usr/include/asm-generic
	rm -rf $(P_DESTDIR)/usr/include/drm
	rm -rf $(P_DESTDIR)/usr/include/linux
	rm -rf $(P_DESTDIR)/usr/include/misc
	rm -rf $(P_DESTDIR)/usr/include/mtd
	rm -rf $(P_DESTDIR)/usr/include/rdma
	rm -rf $(P_DESTDIR)/usr/include/scsi
	rm -rf $(P_DESTDIR)/usr/include/sound
	rm -rf $(P_DESTDIR)/usr/include/video
	rm -rf $(P_DESTDIR)/usr/include/xen

	# This a not from kernel ...
	mkdir -p $(P_DESTDIR)/usr/include/scsi
	cp -a /opt/target/toolchain/$(P_TOOLCHAIN)/sysroot/usr/include/scsi/scsi.h $(P_DESTDIR)/usr/include/scsi/
	cp -a /opt/target/toolchain/$(P_TOOLCHAIN)/sysroot/usr/include/scsi/scsi_ioctl.h $(P_DESTDIR)/usr/include/scsi/
	cp -a /opt/target/toolchain/$(P_TOOLCHAIN)/sysroot/usr/include/scsi/sg.h $(P_DESTDIR)/usr/include/scsi/
