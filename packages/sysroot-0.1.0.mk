P_NAME			= sysroot
P_VERSION		= 0.1.0
P_DESCRIPTION	= Base sysroot imported from the target toolchain
P_LICENCES		=
P_ARCHS			= arm
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
	cp -a /opt/target/toolchain/$(TOOLCHAIN)/sysroot/* $(P_DESTDIR)/
	cp -a /opt/target/toolchain/$(TOOLCHAIN)/debug-root/usr/bin/*  $(P_DESTDIR)/usr/bin/
	cp -a /opt/target/toolchain/$(TOOLCHAIN)/debug-root/usr/lib/*  $(P_DESTDIR)/usr/lib/
