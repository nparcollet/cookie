P_NAME			= kernel
P_VERSION		= 4.14.70.1
P_DESCRIPTION	= Linux Kernel and modules for raspberry, does not include kernel headers
P_ARCHIVE       = raspberrypi-kernel_1.20180919-1.tar.gz
P_URL   		= https://github.com/raspberrypi/linux/archive/$(P_ARCHIVE)
P_LICENCES		= GPLv2
P_ARCHS			= arm
P_SRCDIR		= linux-raspberrypi-kernel_1.20180919-1
P_PROVIDES		= kernel
P_DEPENDS		= firmware

fetch:
	cookie fetch $(P_URL) $(P_ARCHIVE)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

# NOTE: Kernel Headers are taken from the toolchain rootfs (sysroot) and thu not built/installed

compile_headers:
	make mrproper
	KERNEL=kernel7 make ARCH=$(ARCH) CROSS_COMPILE=$(HOST)- INSTALL_HDR_PATH=dest headers_install
	find dest/include \( -name .install -o -name ..install.cmd \) -delete

compile_bcmrpi:
	cookie import bcmrpi.config .config || KERNEL=kernel make ARCH=$(ARCH) CROSS_COMPILE=$(HOST)- bcmrpi_defconfig

compile_bcm2709:
	cookie import bcm2709.config .config || KERNEL=kernel7 make ARCH=$(ARCH) CROSS_COMPILE=$(HOST)- bcm2709_defconfig

compile: compile_$(KCONFIG)
	make -j$(P_NPROCS) ARCH=$(ARCH) CROSS_COMPILE=$(HOST)- zImage modules dtbs

install:
	make ARCH=$(ARCH) CROSS_COMPILE=$(HOST)- INSTALL_MOD_PATH=$(P_DESTDIR)/ modules_install
	mkdir -p $(P_DESTDIR)/boot/overlays
	cp arch/arm/boot/zImage $(P_DESTDIR)/boot
	cp arch/arm/boot/dts/*.dtb $(P_DESTDIR)/boot
	cp arch/arm/boot/dts/overlays/*.dtb* $(P_DESTDIR)/boot/overlays
