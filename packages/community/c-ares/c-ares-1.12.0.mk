P_NAME			= c-ares
P_VERSION		= 1.12.0
P_GITURL		= https://github.com/c-ares/c-ares.git
P_GITREV		= 7691f773af79bf75a62d1863fd0f13ebf9dc51b1
P_DESCRIPTION	= Asynchronous resolver library.
P_LICENCES		=
P_ARCHS			= arm
P_OPTIONS		=
P_DEPENDS		=
P_SRCDIR		= $(P_WORKDIR)/$(P_NAME)-$(P_VERSION)

fetch:
	cookie git clone $(P_GITURL) $(P_NAME)-$(P_VERSION)

setup:
	cookie git checkout $(P_NAME)-$(P_VERSION) $(P_GITREV) $(P_SRCDIR)

compile:
	cd $(P_SRCDIR) && ./buildconf
	cd $(P_SRCDIR) && ./configure --prefix=/usr --host=$(HOST)
	cd $(P_SRCDIR) && make $(P_MAKEOPTS)
	cd $(P_SRCDIR) && make $(P_MAKEOPTS) ahost adig acountry

install:
	cd $(P_SRCDIR) && make DESTDIR=$(P_DESTDIR) install
