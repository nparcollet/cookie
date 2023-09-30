P_NAME			= kernel
P_VERSION		= 6.1.54
P_GITREV		= 2ff65ffbdeb0c8764985af19df2a687a126136f4
P_DESCRIPTION	= Linux Kernel and modules for raspberry, including matching kernel headers for extra module build
P_ARCHIVE       = $(P_GITREV).zip
P_URL   		= https://github.com/raspberrypi/linux/archive/$(P_ARCHIVE)
P_LICENCES		= GPLv2
P_ARCHS			= arm arm64
P_SRCDIR		= linux-2ff65ffbdeb0c8764985af19df2a687a126136f4
P_PROVIDES		= kernel
P_DEPENDS		= firmware

fetch:
	cookie fetch $(P_URL) $(P_ARCHIVE)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile_config:
	cookie import $(P_BOARD_DEFCONFIG).config .config || make ARCH=$(ARCH) CROSS_COMPILE=$(HOST)- $(P_DEFCONFIG)_defconfig

compile_arm: compile_config
	make -j$(NPROCS) PKG_CONFIG_SYSROOT_DIR="" ARCH=$(ARCH) CROSS_COMPILE=$(HOST)- zImage modules dtbs

compile_arm64: compile_config
	make -j$(NPROCS) PKG_CONFIG_SYSROOT_DIR="" ARCH=$(ARCH) CROSS_COMPILE=$(HOST)- Image modules dtbs

compile: compile_$(ARCH)
	
install_arm:
	make ARCH=$(ARCH) CROSS_COMPILE=$(HOST)- INSTALL_MOD_PATH=$(P_DESTDIR)/ modules_install
	mkdir -p $(P_DESTDIR)/boot/overlays
	cp arch/arm/boot/zImage $(P_DESTDIR)/boot/
	cp arch/arm/boot/dts/*.dtb $(P_DESTDIR)/boot/
	cp arch/arm/boot/dts/overlays/*.dtb* $(P_DESTDIR)/boot/overlays/

install_arm64:
	make ARCH=$(ARCH) CROSS_COMPILE=$(HOST)- INSTALL_MOD_PATH=$(P_DESTDIR)/ modules_install
	mkdir -p $(P_DESTDIR)/boot/overlays
	cp arch/arm64/boot/Image /boot/
	cp arch/arm64/boot/dts/broadcom/*.dtb $(P_DESTDIR)/boot/
	cp arch/arm64/boot/dts/overlays/*.dtb* $(P_DESTDIR)/boot/overlays/

install: install_$(ARCH)
	make mrproper	
	make ARCH=$(ARCH) CROSS_COMPILE=$(HOST)- INSTALL_HDR_PATH=$(P_DESTDIR)/usr headers_install
	find $(P_DESTDIR)/usr/include \( -name .install -o -name ..install.cmd \) -delete
