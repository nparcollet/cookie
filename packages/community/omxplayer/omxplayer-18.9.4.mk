P_NAME			= omxplayer
P_VERSION		= 18.9.4
P_DESCRIPTION	= HW Accelerated video player
P_GITURL		= https://github.com/popcornmix/omxplayer.git
P_GITREV		= 7f3faf6cadac913013248de759462bcff92f0102
P_LICENCES		= GPL2
P_ARCHS			= arm
P_SRCDIR		= omxplayer
P_DEPENDS		= alsa-lib

fetch:
	cookie git clone $(P_GITURL) $(P_NAME)

setup:
	cookie git checkout $(P_NAME) $(P_GITREV) $(P_SRCDIR)

compile:
	HOST=$(HOST) FLOAT=$(ARM_FLOATABI) SDKSTAGE=$(P_SYSROOT) LDFLAGS="$(LDFLAGS)" INCLUDES="-isystem$(P_SYSROOT)/usr/include" make ffmpeg
	# SDKSTAGE=$(P_SYSROOT) STRIP=$(HOST)-strip
	#CC=$(HOST)-cc SDKSTAGE=$(P_SYSROOT) STRIP=$(HOST)-strip make

install:
