FROM debian:12.1

# Packages
RUN apt-get update && apt-get install -y --no-install-recommends \
	libtool					\
	build-essential			\
	flex					\
	bison					\
	autoconf				\
	wget					\
	automake				\
	git						\
	mercurial				\
	pkg-config				\
	ssh						\
	bc						\
	gperf					\
	gawk					\
	libtool-bin				\
	libncurses5-dev			\
	vim						\
	ca-certificates			\
	texinfo					\
	man						\
	help2man				\
	unzip					\
	nasm					\
	xz-utils				\
	rsync					\
	dosfstools				\
	xutils-dev				\
	gcc-multilib			\
	g++-multilib			\
	kmod					\
	python-dev-is-python3	\
	cmake					\
	libkrb5-dev				\
	strace					\
	libtirpc3				\
	rpcbind					\
	gettext					\
	nfs-common				\
	autopoint				\
	gettext					\
	nfs-ganesha				\
	libssl-dev				\
	libltdl-dev				\
	fdisk

# Cross Tool NG 1.26.0
RUN	git clone -b 'crosstool-ng-1.26.0' --single-branch --depth 1 https://github.com/crosstool-ng/crosstool-ng.git /root/ctng	\
	&& cd /root/ctng														\
	&& ./bootstrap					\
	&& ./configure --prefix=/usr													\
	&& make																\
	&& make install															\
	&& rm -rf /root/ctng

# Expose some network ports
EXPOSE 2049 38465-38467 662 111/udp 111

# Cookie Environment
VOLUME /opt/cookie
ADD .bashrc /root
ENV COOKIE /opt/cookie
ENV COOKIE_ENV 1
ENV PYTHONPATH ${COOKIE}/python
ENV PYTHONDONTWRITEBYTECODE	1
ENV PATH .:/sbin:/usr/sbin:/usr/local/sbin:/bin:/usr/bin:/usr/local/bin:/opt/target/toolchain/bin:${COOKIE}/bin

# Default Command (shell)
CMD ["/bin/bash"]

