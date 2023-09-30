P_NAME			= openssl
P_VERSION		= 1.1.1
P_DESCRIPTION	= Source toolkit implementing the Transport Layer Security (TLS) protocols (including SSLv3)
P_GITURL		= https://github.com/openssl/openssl.git
P_GITREV		= 1708e3e85b4a86bae26860aa5d2913fc8eff6086
P_LICENCES		= SSLeay OpenSSL
P_ARCHS			= arm arm64
P_SRCDIR		= openssl
P_DEPENDS		=

fetch:
	cookie git clone $(P_GITURL) $(P_NAME)

setup:
	cookie git checkout $(P_NAME) $(P_GITREV) $(P_SRCDIR)

configure_arm:
	./Configure linux-armv4 shared --prefix=/usr --openssldir=/etc/ssl

configure_arm64:
	./Configure linux-aarch64 shared --prefix=/usr --openssldir=/etc/ssl

compile: configure_$(ARCH)
	make CC=$(HOST)-gcc -j$(NPROCS)

install:
	make DESTDIR=$(P_DESTDIR) install_sw install_ssldirs
	rm -rf $(P_DESTDIR)/usr/share
