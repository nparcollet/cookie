P_NAME			= pcre
P_VERSION		= 8.42
P_DESCRIPTION	= Perl Compatible Regular Expression library
P_ARCHIVE		= pcre-8.42.tar.bz2
P_URL			= https://ftp.pcre.org/pub/pcre/$(P_ARCHIVE)
P_LICENCES		= BSD
P_ARCHS			= arm
P_DEPENDS		= zlib bzip2
P_SRCDIR		= pcre-8.42

.PHONY: fetch setup compile install

CONFOPTS =							\
	--prefix=/usr					\
	--host=$(HOST)					\
	--enable-unicode-properties		\
	--enable-pcre16					\
	--enable-pcre32					\
	--enable-pcregrep-libz			\
	--enable-pcregrep-libbz2		\
	--disable-pcretest-libreadline	\
	--disable-static

fetch:
	cookie fetch $(P_URL) $(P_ARCHIVE)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	[ ! -e $(P_WORKDIR)/build ] || rm -rf $(P_WORKDIR)/build
	mkdir -p $(P_WORKDIR)/build
	cd $(P_WORKDIR)/build && ../pcre-8.42/configure $(CONFOPTS)
	cd $(P_WORKDIR)/build && make -j$(P_NPROCS)

install:
	cd $(P_WORKDIR)/build && make DESTDIR=$(P_DESTDIR) install-strip
	rm -rf $(P_DESTDIR)/usr/share
	fix-la-files $(P_DESTDIR)
