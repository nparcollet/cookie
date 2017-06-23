P_NAME			= libuv
P_VERSION		= 1.10.2
P_GITURL		= https://github.com/libuv/libuv.git
P_GITREV		= cb9f579a454b8db592030ffa274ae58df78dbe20
P_DESCRIPTION	= multi-platform support library with a focus on asynchronous I/O.
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
	cd $(P_SRCDIR) && sh autogen.sh
	cd $(P_SRCDIR) && ./configure --prefix=/usr --host=$(HOST)
	cd $(P_SRCDIR) && make $(P_MAKEOPTS)

install:
	cd $(P_SRCDIR) && make DESTDIR=$(P_DESTDIR) install
