P_NAME			= openssl
P_VERSION		= 1.0.2p
P_DESCRIPTION	= Source toolkit implementing the Transport Layer Security (TLS) protocols (including SSLv3)
P_GITURL		= https://github.com/openssl/openssl.git
P_GITREV		= e71ebf275da66dfd601c92e0e80a35114c32f6f8
P_LICENCES		= SSLeay OpenSSL
P_ARCHS			= arm
P_SRCDIR		= openssl
P_DEPENDS		=

fetch:
	cookie git clone $(P_GITURL) $(P_NAME)

setup:
	# 1.0.2p
	cookie git checkout $(P_NAME) $(P_GITREV) $(P_SRCDIR)

compile:
	./Configure linux-armv4 shared --prefix=/usr --openssldir=/etc/ssl
	make CC=$(HOST)-gcc -j$(NPROCS)

install:
	make INSTALL_PREFIX=$(P_DESTDIR) install_sw
