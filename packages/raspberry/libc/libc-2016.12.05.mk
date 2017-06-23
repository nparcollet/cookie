P_NAME			= libc
P_VERSION		= 2016.12.05
P_REVISION		= d820ab9c21969013b4e56c7e9cba25518afcdd44
P_GITURL		= https://github.com/raspberrypi/tools
P_DESCRIPTION	= Binary C Library extracted from raspberry tools
P_LICENCES		= MULTI
P_ARCHS			= arm
P_OPTIONS		=
P_DEPENDS		=

fetch:
	cookie git clone $(P_GITURL) raspberry-tools

setup:
	cookie git checkout raspberry-tools $(P_REVISION) $(P_WORKDIR)/raspberry-tools

compile:
	echo "no compilation needed, binary sysroot from raspberry tools repository"

install:
	mkdir -p $(P_DESTDIR)
	cp -a $(P_WORKDIR)/raspberry-tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/arm-linux-gnueabihf/sysroot/* $(P_DESTDIR)/
