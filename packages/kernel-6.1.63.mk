P_NAME			= kernel
P_VERSION		= 6.1.63
P_GITREV		= a984fda6b2c24dbf1ca21924f99c8f9418f5765e
P_DESCRIPTION	= Linux Kernel and modules for raspberry, including matching kernel headers for extra module build
P_ARCHIVE       = $(P_GITREV).zip
P_URL   		= https://github.com/raspberrypi/linux/archive/$(P_ARCHIVE)
P_LICENCES		= GPLv2
P_ARCHS			= arm arm64
P_SRCDIR		= linux-a984fda6b2c24dbf1ca21924f99c8f9418f5765e
P_PROVIDES		= kernel
P_DEPENDS		=
P_OPTIONS		= defconfig

# Setup as defined on: https://www.raspberrypi.com/documentation/computers/linux_kernel.html#building-the-kernel

# To match stock kernels, image to build depend on arch
P_PRIV_IMAGE_arm	= zImage
P_PRIV_IMAGE_arm64	= Image.gz
P_PRIV_IMAGE		= $(P_PRIV_IMAGE_$(ARCH))

# To match stock kernels, image name depends on arch and config
P_PRIV_KERNEL_arm_bcmrpi 	= kernel
P_PRIV_KERNEL_arm_bcm2709	= kernel7
P_PRIV_KERNEL_arm_bcm2711	= kernel7l
P_PRIV_KERNEL_arm64_bcm2711	= kernel8
P_PRIV_KERNEL_arm64_bcm2712	= kernel_2712
P_PRIV_KERNEL   			= $(P_PRIV_KERNEL_$(ARCH)_$(P_OPTION_DEFCONFIG))

fetch:
	cookie fetch $(P_URL) $(P_ARCHIVE)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	make mrproper
	sed -i 's/EXTRAVERSION =.*/EXTRAVERSION = +/' Makefile
	cookie import $(P_OPTION_DEFCONFIG).config .config || make ARCH=$(ARCH) CROSS_COMPILE=$(HOST)- $(P_OPTION_DEFCONFIG)_defconfig
	make -j$(NPROCS) PKG_CONFIG_SYSROOT_DIR="" ARCH=$(ARCH) CROSS_COMPILE=$(HOST)- $(P_PRIV_IMAGE) modules dtbs

install:
	mkdir -p $(P_DESTDIR)/boot/overlays
	cp arch/$(ARCH)/boot/$(P_PRIV_IMAGE) $(P_DESTDIR)/boot/$(P_PRIV_KERNEL).img
	[ -d arch/$(ARCH)/boot/dts/broadcom ] && cp arch/$(ARCH)/boot/dts/broadcom/*.dtb $(P_DESTDIR)/boot/
	cp arch/$(ARCH)/boot/dts/overlays/*.dtb* $(P_DESTDIR)/boot/overlays/
	cp arch/$(ARCH)/boot/dts/overlays/README $(P_DESTDIR)/boot/overlays/
	make ARCH=$(ARCH) CROSS_COMPILE=$(HOST)- INSTALL_MOD_PATH=$(P_DESTDIR)/ modules_install
	make ARCH=$(ARCH) CROSS_COMPILE=$(HOST)- INSTALL_HDR_PATH=$(P_DESTDIR)/usr headers_install
	find $(P_DESTDIR)/usr/include \( -name .install -o -name ..install.cmd \) -delete
