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
	rm -rf $(P_DESTDIR)/usr/include/{asm,asm-generic,drm,linux,misc,mtd,rdma,scsi,sound,video,xen}
