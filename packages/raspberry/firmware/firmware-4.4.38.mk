P_NAME			= firmware
P_VERSION		= 4.4.38
P_REVISION		= 2190ebaaab17d690fb4a6aa767ff7755eaf51b12
P_GITURL		= https://github.com/raspberrypi/firmware.git
P_DESCRIPTION	= pre-compiled binaries for Raspberry Pi kernel and modules
P_LICENCES		= BCM
P_ARCHS			= arm
P_OPTIONS		=
P_DEPENDS		=
P_SRCDIR		= $(P_WORKDIR)/raspberry-firmware

fetch:
	cookie git clone $(P_GITURL) raspberry-firmware

setup:
	cookie git checkout raspberry-firmware $(P_REVISION) $(P_SRCDIR)

compile:
	echo "no compile phase"

install:
	mkdir -p $(P_DESTDIR)
	mkdir -p $(P_DESTDIR)/lib
	mkdir -p $(P_DESTDIR)/usr
	cp -a $(P_SRCDIR)/boot $(P_DESTDIR)/boot
	cp -a $(P_SRCDIR)/modules/4.4.38-v7+ $(P_DESTDIR)/lib/modules
	#[ $(4.4.38+
	cp -a $(P_SRCDIR)/opt/vc/bin $(P_DESTDIR)/usr/
	cp -a $(P_SRCDIR)/opt/vc/include $(P_DESTDIR)/usr/
	cp -a $(P_SRCDIR)/opt/vc/lib $(P_DESTDIR)/usr/
	cp -a $(P_SRCDIR)/opt/vc/sbin $(P_DESTDIR)/usr/
