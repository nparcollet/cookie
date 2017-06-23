P_NAME			= pulseaudio
P_VERSION		= 9.0
P_URL			= http://freedesktop.org/software/pulseaudio/releases/$(P_NAME)-$(P_VERSION).tar.xz
P_DESCRIPTION	= PulseAudio is a sound system for POSIX OSes
P_LICENCES		=
P_ARCHS			= arm
P_OPTIONS		=
P_DEPENDS		= json-c libsndfile alsa-lib
P_SRCDIR		= $(P_WORKDIR)/$(P_NAME)-$(P_VERSION)

# http://www.linuxfromscratch.org/blfs/view/svn/multimedia/pulseaudio.html
# alsa-lib-1.1.2, dbus-1.10.14, GLib-2.50.2, libcap-2.25 with PAM, OpenSSL-1.0.2j, Speex-1.2rc2 and Xorg Libraries

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract $(P_NAME)-$(P_VERSION).tar.xz $(P_WORKDIR)

compile:
	cd $(P_SRCDIR) && ./configure --prefix=/usr --sysconfdir=/etc --disable-bluez4 --disable-rpath --host=$(HOST)
	cd $(P_SRCDIR) && make $(P_MAKEOPTS)

install:
	cd $(P_SRCDIR) && make DESTDIR=$(P_DESTDIR) install
	#rm /etc/dbus-1/system.d/pulseaudio-system.conf
