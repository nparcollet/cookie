FROM debian:8.6

# Packages
RUN apt-get update && apt-get install -y --no-install-recommends \
	libtool				\
	build-essential			\
	flex				\
	bison				\
	autoconf			\
	wget				\
	automake			\
	git				\
	mercurial			\
	pkg-config			\
	ssh				\
	bc				\
	gperf				\
	gawk				\
	libtool-bin			\
	libncurses5-dev			\
	vim				\
	ca-certificates			\
	texinfo				\
	man				\
	help2man			\
	unzip				\
	nasm				\
	xz-utils			\
	rsync				\
	dosfstools			\
	xutils-dev			\
	gcc-multilib			\
	g++-multilib			\
	kmod				\
	python-dev			\
	cmake				\
	libkrb5-dev			\
	strace				\
	libtirpc1			\
	rpcbind				\
	nfs-common

# Cross Tool NG 1.23.0
RUN	git clone -b 'crosstool-ng-1.23.0' --single-branch --depth 1 https://github.com/crosstool-ng/crosstool-ng.git /root/ctng	\
	&& cd /root/ctng														\
	&& autoreconf -if														\
	&& ./configure --prefix=/usr													\
	&& make																\
	&& make install															\
	&& rm -rf /root/ctng

# Ganesha Userland NFS Server 2.6.3 (Patched)
ADD ganesha.patch /root
RUN 	cd /root 									\
	&& git clone -b v2.6.3 --depth 1 https://github.com/nfs-ganesha/nfs-ganesha.git	\
	&& cd nfs-ganesha								\
	&& git submodule update --init 							\
	&& patch -p1 < /root/ganesha.patch						\
	&& mkdir -p /root/nfs-ganesha/build						\
	&& cd /root/nfs-ganesha/build							\
	&& cmake -DUSE_GSS=OFF ../src 							\
	&& make										\
	&& make install									\
	&& cd										\
	&& rm -rf /root/ganesha.patch /root/nfs-ganesha
ADD ganesha.conf /etc/ganesha/ganesha.conf
EXPOSE 2049 38465-38467 662 111/udp 111

# Cookie Environment
VOLUME /opt/cookie
ADD .bashrc /root
ENV COOKIE			/opt/cookie
ENV COOKIE_ENV			1
ENV PYTHONPATH			${COOKIE}/python
ENV PYTHONDONTWRITEBYTECODE	1
ENV PATH			.:/sbin:/usr/sbin:/usr/local/sbin:/bin:/usr/bin:/usr/local/bin:/opt/target/toolchain/bin:${COOKIE}/bin

# Default Command (shell)
CMD ["/bin/bash"]

