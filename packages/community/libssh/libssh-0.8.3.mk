P_NAME			= libssh
P_VERSION		= 0.8.3
P_DESCRIPTION	= Multiplatform C library implementing the SSHv2 protocol on client and server side.
P_URL			= https://www.libssh.org/files/0.8/libssh-0.8.3.tar.xz
P_ARCHIVE		= libssh-0.8.3.tar.xz
P_LICENCES		=
P_ARCHS			= arm
P_SRCDIR		= libssh-0.8.3
# Note: openssl-1.1.1 i not comptatible with this version
P_DEPENDS		= openssl zlib

fetch:
	cookie fetch $(P_URL) $(P_ARCHIVE)

setup:
	cookie extract $(P_ARCHIVE) $(P_WORKDIR)
	sed -e "s#cmake_minimum_required(VERSION 3.3.0)#cmake_minimum_required(VERSION 3.0.0)#" -i $(P_SRCDIR)/CMakeLists.txt

compile:
	mkdir -p $(P_WORKDIR)/build
	# Wonderful cmake pkgconfig managment ...
	cd $(P_WORKDIR)/build &&  cmake \
		-DCMAKE_FIND_ROOT_PATH=$(P_SYSROOT) \
		-DCMAKE_SYSROOT=$(P_SYSROOT) \
		-DCMAKE_PREFIX_PATH=$(P_SYSROOT) \
		-DCMAKE_SYSTEM_PROCESSOR=$(ARCH) \
		-DCMAKE_C_COMPILER=$(HOST)-gcc \
		-DCMAKE_CXX_COMPILER=$(HOST)-g++ \
		-DCMAKE_C_FLAGS=$(CFLAGS) \
		-DCMAKE_CXX_FLAGS=$(CXXFLAGS) \
		-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
		-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
		-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
		-DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ONLY \
		-DCMAKE_INSTALL_PREFIX=/usr				\
		../libssh-0.8.3
	cd $(P_WORKDIR)/build &&  make

install:
	cd $(P_WORKDIR)/build &&  make DESTDIR=$(P_DESTDIR) install
