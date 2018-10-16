P_NAME			= boost
P_VERSION		= 1.68.0
P_DESCRIPTION	= Boost provides free peer-reviewed portable C++ source libraries.
P_ARCHIVE		= boost_1_68_0.tar.bz2
P_URL			= https://fossies.org/linux/misc/$(P_ARCHIVE)
P_LICENCES		= BOOST
P_ARCHS			= arm
P_DEPENDS		= zlib
P_SRCDIR		= boost_1_68_0

fetch:
	cookie fetch $(P_URL) $(P_ARCHIVE)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)

compile:
	./bootstrap.sh
	sed -e "s#using gcc#using gcc : arm : $(HOST)-g++#" -i project-config.jam
	./bjam toolset=gcc-arm							\
	 	--without-python							\
		-s ZLIB_INCLUDE=$(P_SYSROOT)/usr/include	\
		-s ZLIB_LIBPATH=$(P_SYSROOT)/usr/lib		\
		--prefix=/usr

install:
	./bjam toolset=gcc-arm --without-python --prefix=$(P_DESTDIR)/usr install
