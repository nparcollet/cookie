P_NAME		:= linux-headers
P_VERSION	:= 3.8.1
P_LICENCE	:= GPL
P_DESC		:= Header files related to Linux kernel version 3.8.1
P_DISTFILES	:= https://www.kernel.org/pub/linux/kernel/v2.6/longterm/v3.8.1/linux-$(P_VERSION).tar.xz
P_DEPENDS	:=
P_PROVIDES	:=
P_FLAGS		:=

clean:
	rm -rf $(STAGING)
	rm -rf $(WORKDIR)/build

setup:
	for d in $(P_DISTFILES); do [ -e $(DISTFILES)/$${d##*/} ] || wget -c $$d -O $(DISTFILES)/$${d##*/}; done
	cd $(WORKDIR) && tar xJf $(DISTFILES)/linux-$(P_VERSION).tar.xz

compile:
	cd $(WORKDIR)/linux-$(P_VERSION) && make mrproper
	cd $(WORKDIR)/linux-$(P_VERSION) && make headers_check
	cd $(WORKDIR)/linux-$(P_VERSION) && make INSTALL_HDR_PATH=$(WORKDIR)/build headers_install

install:
	mkdir -p $(STAGING)/usr/include
	cp -rv $(WORKDIR)/build/include/* $(STAGING)/usr/include
	find $(STAGING)/usr/include -name .install -or -name ..install.cmd | xargs rm -fv
