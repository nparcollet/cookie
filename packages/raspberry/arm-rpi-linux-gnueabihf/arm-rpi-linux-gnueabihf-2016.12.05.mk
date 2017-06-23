P_NAME			= arm-rpi-linux-gnueabihf
P_VERSION		= 2016.12.05
P_REVISION		= d820ab9c21969013b4e56c7e9cba25518afcdd44
P_GITURL		= https://github.com/raspberrypi/tools
P_DESCRIPTION	= Binary toolchain provided by raspberry community
P_LICENCES		= MULTI
P_ARCHS			= amd64
P_OPTIONS		=
P_DEPENDS		=

fetch:
	cookie git clone $(P_GITURL) $(P_NAME)

setup:
	cookie git checkout $(P_NAME) $(P_REVISION) $(P_WORKDIR)/$(P_NAME)

compile:
	echo "no compile phase"

install:
	mkdir -p $(P_DESTDIR)/opt/toolchains
	mkdir -p $(P_DESTDIR)/root/profile.d
	cp -a $(P_WORKDIR)/$(P_NAME)/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf $(P_DESTDIR)/opt/toolchains/$(P_NAME)
	echo "export PATH=\$$PATH:/opt/toolchains/$(P_NAME)/bin" > $(P_DESTDIR)/root/profile.d/$(P_NAME).env
