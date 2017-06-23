P_NAME			= depot-tools
P_VERSION		= 2017.01.06
P_GITURL		= https://chromium.googlesource.com/chromium/tools/depot_tools
P_GITREV		= 66c50ea1f11a8776355f50800fe7e77e9eea4ce1
P_DESCRIPTION	= This package contains tools for working with Chromium development. It requires python 2.7
P_LICENCES		=
P_ARCHS			= amd64
P_OPTIONS		=
P_DEPENDS		=
P_SRCDIR		= $(P_WORKDIR)/$(P_NAME)-$(P_VERSION)

fetch:
	cookie git clone $(P_GITURL) community-$(P_NAME)

setup:
	cookie git checkout community-$(P_NAME) $(P_GITREV) $(P_SRCDIR)

compile:
	echo "nothing to compile"

install:
	mkdir -p $(P_DESTDIR)/opt/depot_tools
	mkdir -p $(P_DESTDIR)/root/profile.d
	cp -a $(P_SRCDIR)/* $(P_DESTDIR)/opt/depot_tools
	echo "export PATH=\$$PATH:/opt/depot_tools" > $(P_DESTDIR)/root/profile.d/$(P_NAME).env
