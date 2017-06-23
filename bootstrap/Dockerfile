FROM debian:8.6

# Packages
RUN apt-get update && apt-get install -y --no-install-recommends \
	libtool			\
	build-essential		\
	flex			\
	bison			\
	autoconf		\
	wget			\
	automake		\
	git			\
	mercurial		\
	pkg-config		\
	ssh			\
	bc			\
	gperf			\
	gawk			\
	libtool-bin		\
	libncurses5-dev		\
	vim			\
	ca-certificates		\
	texinfo			\
	man			\
	help2man		\
	unzip			\
	nasm			\
	xz-utils		\
	rsync			\
	dosfstools

# Where cookie is mounted within bootstrap
VOLUME /opt/cookie

# Cookie specific packages
ADD *.deb /root/debian/
RUN dpkg -i /root/debian/crosstool-ng-1.22.0.deb
RUN dpkg -i /root/debian/arm-rpi-linux-gnueabihf-2016.12.05.deb
RUN dpkg -i /root/debian/depot-tools-2017.01.06.deb
RUN rm -rf /root/debian

RUN apt-get install -y --no-install-recommends xutils-dev
RUN apt-get install -y --no-install-recommends gcc-multilib g++-multilib

# Customize the image
ADD .bashrc /root

# Environment Variables
ENV COOKIE			/opt/cookie
ENV PYTHONPATH			${COOKIE}/python
ENV PYTHONDONTWRITEBYTECODE	1
ENV PATH			.:/opt/cookie/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin

# Default Command (shell)
CMD ["/bin/bash"]

