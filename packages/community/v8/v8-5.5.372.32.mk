# MATCH CHROMIUM 55.0.2883.87 on https://omahaproxy.appspot.com
P_NAME			= v8
P_VERSION		= 5.5.372.32
P_GITURL		= https://github.com/v8/v8.git
P_GITREV		= 1ae9314d1ba4a31d1a230a6f17cc26e1ddf80e97
P_DESCRIPTION	= multi-platform support library with a focus on asynchronous I/O.
P_LICENCES		=
P_ARCHS			= arm
P_OPTIONS		=
P_DEPENDS		=
P_SRCDIR		= srcdir
P_DESTDIR		= staging

fetch:

	# Base repository (DEPS file contains dependencies, there location and revision. TODO: Auto read this file ...)
	cookie git clone $(P_GITURL) community-$(P_NAME)

	# V8 Rely on additionnal component that also need to be fetched (see DEPS file)
	cookie git clone https://chromium.googlesource.com/chromium/deps/icu.git						community-$(P_NAME)-icu
	cookie git clone https://chromium.googlesource.com/chromium/src/base/trace_event/common.git		community-$(P_NAME)-common
	cookie git clone https://chromium.googlesource.com/chromium/src/build.git						community-$(P_NAME)-build
	cookie git clone https://chromium.googlesource.com/chromium/buildtools.git						community-$(P_NAME)-buildtools
	cookie git clone https://chromium.googlesource.com/external/gyp.git								community-$(P_NAME)-gyp
	cookie git clone https://chromium.googlesource.com/external/github.com/google/googletest.git	community-$(P_NAME)-gtest

setup:

	# Checkout source code
	cookie git checkout community-v8 $(P_GITREV) $(P_SRCDIR)

	# Checkout other dependencies (only the one needed for this build)
	cookie git checkout community-v8-icu		b0bd3ee50bc2e768d7a17cbc60d87f517f024dbe	$(P_SRCDIR)/third_party/icu
	cookie git checkout community-v8-buildtools 5fd66957f08bb752dca714a591c84587c9d70762	$(P_SRCDIR)/buildtools
	cookie git checkout community-v8-gyp		e7079f0e0e14108ab0dba58728ff219637458563	$(P_SRCDIR)/tools/gyp
	cookie git checkout community-v8-build		475d5b37ded6589c9f8a0d19ced54ddf2e6d14a0	$(P_SRCDIR)/build
	cookie git checkout community-v8-common		e0fa02a02f61430dae2bddfd89a334ea4389f495	$(P_SRCDIR)/base/trace_event/common
	cookie git checkout community-v8-gtest		6f8a66431cb592dad629028a50b3dd418a408c87	$(P_SRCDIR)/testing/gtest

	# Disable build tests
	sed -e "s#'../test/fuzzer/fuzzer.gyp:\*',##g"		-i $(P_SRCDIR)/gypfiles/all.gyp
	sed -e "s#'../test/cctest/cctests.gyp:\*',##g"		-i $(P_SRCDIR)/gypfiles/all.gyp
	sed -e "s#'../test/unittests/unittests.gyp:\*',##g"	-i $(P_SRCDIR)/gypfiles/all.gyp

compile:

	# Do the cross build
	cd $(P_SRCDIR) &&					\
		GYPFLAGS="-Dclang=0"			\
		CC_host=x86_64-linux-gnu-gcc	\
		CXX_host=x86_64-linux-gnu-g++	\
		make arm.release snapshot=off library=shared arm_version=$(ARM_VERSION) armfpu=$(ARM_FPU) armfloatabi=$(ARM_FLOATABI) $(P_MAKEOPTS)

install:

	# Create install directories
	mkdir -p $(P_DESTDIR)/usr/include
	mkdir -p $(P_DESTDIR)/usr/lib
	mkdir -p $(P_DESTDIR)/usr/bin

	# Install libs
	cp -a $(P_SRCDIR)/out/arm.release/lib.target/lib*.so $(P_DESTDIR)/usr/lib/
	cp -a $(P_SRCDIR)/out/arm.release/obj.target/src/lib*.a $(P_DESTDIR)/usr/lib/

	# Install includes
	cp -a $(P_SRCDIR)/include/* $(P_DESTDIR)/usr/*

	# Install binaries
	cp -a $(P_SRCDIR)/out/arm.release/hello-world	$(P_DESTDIR)/usr/bin/
	cp -a $(P_SRCDIR)/out/arm.release/mkpeephole	$(P_DESTDIR)/usr/bin/
	cp -a $(P_SRCDIR)/out/arm.release/process		$(P_DESTDIR)/usr/bin/
	cp -a $(P_SRCDIR)/out/arm.release/v8_shell		$(P_DESTDIR)/usr/bin/
	cp -a $(P_SRCDIR)/out/arm.release/icudtl.dat	$(P_DESTDIR)/usr/bin/
