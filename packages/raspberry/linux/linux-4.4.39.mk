P_NAME			= linux
P_VERSION		= 4.4.39
P_REVISION		= 5e46914b3417fe9ff42546dcacd0f41f9a0fb172
P_GITURL		= https://github.com/raspberrypi/linux
P_DESCRIPTION	= Linux Kernel for Raspberry PI Platforms
P_LICENCES		= GPL2
P_ARCHS			= arm
P_OPTIONS		=
P_DEPENDS		=

fetch:
	cookie git clone $(P_GITURL) raspberry-linux

setup:
	cookie git checkout raspberry-linux $(P_REVISION) $(P_WORKDIR)/raspberry-linux

compile:
	cd $(P_WORKDIR)/raspberry-linux \
	&& KERNEL=$(P_KERNEL) make ARCH=$(P_ARCH) CROSS_COMPILE=$(P_CROSSCOMPILE)- bcm2709_defconfig \
	&& make ARCH=$(P_ARCH) CROSS_COMPILE=$(P_CROSSCOMPILE)- $(P_MAKEOPTS) zImage modules dtbs

install:
	mkkdir -p $(P_DESTDIR)/boot/overlays
	cd $(P_WORKDIR)/raspberry-linux \
	&& make ARCH=$(P_ARCH) CROSS_COMPILE=$(P_CROSSCOMPILE)- INSTALL_MOD_PATH=$(P_DESTDIR) modules_install
	&& scripts/mkknlimg arch/arm/boot/zImage $(P_DESTDIR)/boot/$(P_KERNEL).img
	&& cp arch/arm/boot/dts/*.dtb $(P_DESTDIR)/book/
	&& cp arch/arm/boot/dts/overlays/*.dtb* $(P_DESTDIR)/boot/overlays/
	&& cp arch/arm/boot/dts/overlays/README $(P_DESTDIR)/boot/overlays/
