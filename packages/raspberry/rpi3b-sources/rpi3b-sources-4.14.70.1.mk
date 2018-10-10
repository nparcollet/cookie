P_NAME			= rpi3b-sources
P_VERSION		= 4.14.70.1
P_DESCRIPTION	= Linux Kernel and modules for raspberry (Release 1.20180919.1)
P_URL   		= https://www.raspberrypi.org/documentation/linux/kernel
P_LICENCES		= GPLv2
P_ARCHS			= arm
P_ARCHIVE       = raspberrypi-kernel_1.20180919-1.tar.gz
P_SRCDIR		= linux-raspberrypi-kernel_1.20180919-1
P_PROVIDES		= kernel

fetch:
	cookie fetch https://github.com/raspberrypi/linux/archive/$(P_ARCHIVE)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	# NOTE: If headers are installed, it will conflict with sysroot headers
	#make mrproper
	#KERNEL=kernel7 make ARCH=$(ARCH) CROSS_COMPILE=$(HOST)- INSTALL_HDR_PATH=dest headers_install
	#find dest/include \( -name .install -o -name ..install.cmd \) -delete
	KERNEL=kernel7 make ARCH=$(ARCH) CROSS_COMPILE=$(HOST)- bcm2709_defconfig
	make -j$(P_NPROCS) ARCH=$(ARCH) CROSS_COMPILE=$(HOST)- zImage modules dtbs

install:
	make ARCH=$(ARCH) CROSS_COMPILE=$(HOST)- INSTALL_MOD_PATH=$(P_DESTDIR)/ modules_install
	mkdir -p $(P_DESTDIR)/boot/overlays
	cp arch/arm/boot/zImage $(P_DESTDIR)/boot
	cp arch/arm/boot/dts/*.dtb $(P_DESTDIR)/boot
	cp arch/arm/boot/dts/overlays/*.dtb* $(P_DESTDIR)/boot/overlays
	# NOTE: If headers are installed, it will conflict with sysroot headers
	#mkdir -p $(P_DESTDIR)/usr/include
	#cp -a dest/include $(P_DESTDIR)/usr/
