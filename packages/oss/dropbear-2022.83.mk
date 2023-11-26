P_NAME			= dropbear
P_VERSION		= 2022.83
P_DESCRIPTION	= Dropbear is a relatively small SSH server and client
P_URL   		= https://github.com/mkj/dropbear/archive/refs/tags/DROPBEAR_2022.83.tar.gz
P_ARCHIVE		= DROPBEAR_2022.83.tar.gz
P_LICENCES		= MIT
P_ARCHS			= arm arm64
P_SRCDIR		= dropbear-DROPBEAR_2022.83
P_DEPENDS		= zlib libxcrypt

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	autoreconf -if
	./configure --prefix=/usr CC=$(HOST)-gcc --host=$(HOST)
	make -j$(NPROCS)
	make -j$(NPROCS) scp

install:
	make DESTDIR=$(P_DESTDIR) install
	cp scp $(P_DESTDIR)/usr/bin/
	rm -rf $(P_DESTDIR)/usr/share
	mkdir -p $(P_DESTDIR)/etc/dropbear
