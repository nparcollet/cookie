P_NAME			= openssh
P_VERSION		= 7.8p1
P_DESCRIPTION	= OpenSSH is a 100% complete SSH protocol 2.0 implementation and includes sftp client and server support.
P_URL			= https://ftp.fr.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.8p1.tar.gz
P_ARCHIVE		= openssh-7.8p1.tar.gz
P_LICENCES		= BSD
P_ARCHS			= arm
P_SRCDIR		= openssh-7.8p1
# Note: openssl-1.1.1 is not comptatible with this version...
P_DEPENDS		= openssl zlib

CONFOPTS = 					\
	--host=$(HOST)			\
	--with-lib				\
	--prefix=/usr			\
	--with-ssl-dir=/etc/ssl	\
	--disable-strip			\
	--sysconfdir=/etc/ssh	\
	CC=$(HOST)-gcc			\
	AR=$(HOST)-ar

fetch:
	cookie fetch $(P_URL) $(P_ARCHIVE)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	autoreconf -if
	./configure $(CONFOPTS)
	make -j$(P_NPROCS)

install:
	make DESTDIR=$(P_DESTDIR) install
	rm -rf $(P_DESTDIR)/usr/share
