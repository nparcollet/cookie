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
	g++-multilib

# Where cookie is mounted within bootstrap
VOLUME /opt/cookie

# Raspberry Pi Tools
RUN git clone https://github.com/raspberrypi/tools.git /opt/rpitools

# Customize the image
ADD .bashrc /root

# Environment Variables
ENV COOKIE			/opt/cookie
ENV COOKIE_ENV		1
ENV PYTHONPATH			${COOKIE}/python
ENV PYTHONDONTWRITEBYTECODE	1
ENV PATH			.:/opt/cookie/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin

RUN apt-get install -y --no-install-recommends \
	kmod

# Default Command (shell)
CMD ["/bin/bash"]
