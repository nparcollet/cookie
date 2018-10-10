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
	python-dev

# Cross Tool NG 1.23.0
RUN git clone -b 'crosstool-ng-1.23.0' --single-branch --depth 1 https://github.com/crosstool-ng/crosstool-ng.git /root/ctng
RUN cd /root/ctng && autoreconf -if && ./configure --prefix=/usr && make && make install
RUN rm -rf /root/ctng

# Where cookie is mounted within bootstrap
VOLUME /opt/cookie

# Customize the image
ADD .bashrc /root

# Environment
ENV COOKIE			/opt/cookie
ENV COOKIE_ENV			1
ENV PYTHONPATH			${COOKIE}/python
ENV PYTHONDONTWRITEBYTECODE	1
ENV PATH			.:/sbin:/usr/sbin:/usr/local/sbin:/bin:/usr/bin:/usr/local/bin:/opt/target/toolchain/bin:${COOKIE}/bin

# Default Command (shell)
CMD ["/bin/bash"]

