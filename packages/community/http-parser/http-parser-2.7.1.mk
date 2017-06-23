P_NAME			= http-parser
P_VERSION		= 2.7.1
P_GITURL		= https://github.com/nodejs/http-parser.git
P_GITREV		= feae95a3a69f111bc1897b9048d9acbc290992f9
P_DESCRIPTION	= Parser for HTTP messages written in C. It parses both requests and responses.
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
	cd $(P_SRCDIR) && make $(P_MAKEOPTS) PREFIX=$(P_DESTDIR)/usr library

install:
	cd $(P_SRCDIR) && make PREFIX=$(P_DESTDIR)/usr install
