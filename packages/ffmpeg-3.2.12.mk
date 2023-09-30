P_NAME			= ffmpeg
P_VERSION		= 3.2.12
P_DESCRIPTION	= A complete, cross-platform solution to record, convert and stream audio and video.
P_GITURL		= https://git.ffmpeg.org/ffmpeg.git
P_GITREV		= a911f234e26e488198dff8aec8a5ff3c2e052cc4
P_LICENCES		= LGPL2.1
P_ARCHS			= arm
P_SRCDIR		= ffmpeg
# Note: openssl-1.1.1 i not comptatible with this version
P_DEPENDS		= alsa-lib zlib openssl libssh

CFLAGS= $(CFGLAGS)						\
		-D__STDC_CONSTANT_MACROS		\
		-D__STDC_LIMIT_MACROS			\
		-DTARGET_POSIX					\
		-DTARGET_LINUX					\
		-fPIC							\
		-DPIC							\
 		-D_REENTRANT 					\
		-D_HAVE_SBRK					\
		-D_LARGEFILE64_SOURCE			\
		-DHAVE_CMAKE_CONFIG				\
		-DHAVE_VMCS_CONFIG				\
		-D_REENTRANT					\
		-DUSE_VCHIQ_ARM					\
		-DVCHI_BULK_ALIGN=1				\
		-DVCHI_BULK_GRANULARITY=1		\
		-DEGL_SERVER_DISPMANX 			\
		-D_LARGEFILE_SOURCE				\
		-D_LARGEFILE64_SOURCE 			\
		-D__VIDEOCORE4__				\
		-DGRAPHICS_X_VG=1 				\
		-U_FORTIFY_SOURCE				\
		-Wall							\
		-DHAVE_OMXLIB					\
		-DUSE_EXTERNAL_FFMPEG 			\
		-DHAVE_LIBAVCODEC_AVCODEC_H		\
		-DHAVE_LIBAVUTIL_MEM_H			\
		-DHAVE_LIBAVUTIL_AVUTIL_H 		\
		-DHAVE_LIBAVFORMAT_AVFORMAT_H	\
		-DHAVE_LIBAVFILTER_AVFILTER_H	\
		-DOMX							\
		-DOMX_SKIP64BIT

#DECODERS =

EXTRA_CFLAGS=	-mfpu=$(ARM_FPU)				\
				-mfloat-abi=$(ARM_FLOATABI)		\
				-mno-apcs-stack-check			\
				-mstructure-size-boundary=32	\
				-mno-sched-prolog

fetch:
	cookie git clone $(P_GITURL) $(P_NAME)

setup:
	cookie git checkout $(P_NAME) $(P_GITREV) $(P_SRCDIR)

compile:
	# Option identicals to omxplayer inline ffmpeg ...
	# Enable > Disable (until we add dependent packages): smbclient
	CC=$(HOST)-cc CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" ./configure	\
		--pkg-config-flags=""				\
		--disable-libsmbclient				\
		--enable-libssh						\
		--enable-cross-compile				\
		--cross-prefix=$(HOST)-				\
		--arch=$(ARCH)						\
		--cpu=$(ARM_CPU)					\
		--target-os=linux					\
		--enable-shared						\
		--disable-static					\
		--prefix=/usr						\
		--extra-cflags="$(EXTRA_CFLAGS)" 	\
		--enable-gpl						\
		--enable-nonfree					\
		--enable-parsers					\
		--enable-version3					\
		--enable-protocols					\
		--enable-pthreads					\
		--enable-pic						\
		--enable-armv6t2					\
		--enable-armv6						\
		--enable-openssl					\
		--enable-hardcoded-tables 			\
		--enable-decoder=mpegvideo 			\
		--enable-decoder=mpeg1video 		\
		--enable-decoder=mpeg2video 		\
		--enable-decoder=mjpeg 				\
		--enable-decoder=mjpegb 			\
		--enable-decoder=mpeg4 				\
		--enable-decoder=vp6 				\
		--enable-decoder=vp6f 				\
		--enable-decoder=vc1 				\
		--enable-decoder=wmv3 				\
		--enable-decoder=h264 				\
		--enable-decoder=theora 			\
		--enable-decoder=vp8 				\
		--enable-decoder=opus				\
		--disable-debug						\
		--disable-doc						\
		--disable-hwaccels					\
		--disable-muxers					\
		--disable-filters					\
		--disable-encoders					\
		--disable-devices					\
		--disable-programs					\
		--disable-postproc					\
		--disable-armv5te					\
		--disable-neon						\
		--disable-runtime-cpudetect 		\
		--disable-crystalhd 				\
		--disable-decoder=h264_vda 			\
		--disable-decoder=h264_crystalhd 	\
		--disable-decoder=h264_vdpau 		\
		--disable-decoder=vc1_crystalhd 	\
		--disable-decoder=wmv3_crystalhd 	\
		--disable-decoder=wmv3_vdpau 		\
		--disable-decoder=mpeg1_vdpau 		\
		--disable-decoder=mpeg2_crystalhd 	\
		--disable-decoder=mpeg4_crystalhd 	\
		--disable-decoder=mpeg4_vdpau 		\
		--disable-decoder=mpeg_vdpau 		\
		--disable-decoder=mpeg_xvmc 		\
		--disable-decoder=msmpeg4_crystalhd \
		--disable-decoder=vc1_vdpau 		\
		--disable-decoder=mvc1 				\
		--disable-decoder=mvc2 				\
		--disable-decoder=h261 				\
		--disable-decoder=h263 				\
		--disable-decoder=rv10 				\
		--disable-decoder=rv20 				\
		--disable-decoder=sp5x 				\
		--disable-decoder=jpegls 			\
		--disable-decoder=rawvideo 			\
		--disable-decoder=msmpeg4v1 		\
		--disable-decoder=msmpeg4v2 		\
		--disable-decoder=msmpeg4v3 		\
		--disable-decoder=wmv1 				\
		--disable-decoder=wmv2 				\
		--disable-decoder=h263p 			\
		--disable-decoder=h263i 			\
		--disable-decoder=svq1 				\
		--disable-decoder=svq3 				\
		--disable-decoder=dvvideo 			\
		--disable-decoder=huffyuv 			\
		--disable-decoder=cyuv 				\
		--disable-decoder=indeo3 			\
		--disable-decoder=vp3 				\
		--disable-decoder=asv1 				\
		--disable-decoder=asv2 				\
		--disable-decoder=ffv1 				\
		--disable-decoder=vcr1 				\
		--disable-decoder=cljr 				\
		--disable-decoder=mdec 				\
		--disable-decoder=roq 				\
		--disable-decoder=xan_wc3 			\
		--disable-decoder=xan_wc4 			\
		--disable-decoder=rpza 				\
		--disable-decoder=cinepak 			\
		--disable-decoder=msrle 			\
		--disable-decoder=msvideo1 			\
		--disable-decoder=idcin 			\
		--disable-decoder=smc 				\
		--disable-decoder=flic 				\
		--disable-decoder=truemotion1 		\
		--disable-decoder=vmdvideo 			\
		--disable-decoder=mszh 				\
		--disable-decoder=zlib 				\
		--disable-decoder=qtrle 			\
		--disable-decoder=snow 				\
		--disable-decoder=tscc 				\
		--disable-decoder=ulti 				\
		--disable-decoder=qdraw 			\
		--disable-decoder=qpeg 				\
		--disable-decoder=png 				\
		--disable-decoder=ppm 				\
		--disable-decoder=pbm 				\
		--disable-decoder=pgm 				\
		--disable-decoder=pgmyuv 			\
		--disable-decoder=pam 				\
		--disable-decoder=ffvhuff 			\
		--disable-decoder=rv30 				\
		--disable-decoder=rv40 				\
		--disable-decoder=loco 				\
		--disable-decoder=wnv1 				\
		--disable-decoder=aasc 				\
		--disable-decoder=indeo2 			\
		--disable-decoder=fraps 			\
		--disable-decoder=truemotion2 		\
		--disable-decoder=bmp 				\
		--disable-decoder=cscd 				\
		--disable-decoder=mmvideo 			\
		--disable-decoder=zmbv 				\
		--disable-decoder=avs 				\
		--disable-decoder=nuv 				\
		--disable-decoder=kmvc 				\
		--disable-decoder=flashsv 			\
		--disable-decoder=cavs 				\
		--disable-decoder=jpeg2000 			\
		--disable-decoder=vmnc 				\
		--disable-decoder=vp5 				\
		--disable-decoder=targa 			\
		--disable-decoder=dsicinvideo 		\
		--disable-decoder=tiertexseqvideo 	\
		--disable-decoder=tiff 				\
		--disable-decoder=gif 				\
		--disable-decoder=dxa 				\
		--disable-decoder=thp 				\
		--disable-decoder=sgi 				\
		--disable-decoder=c93 				\
		--disable-decoder=bethsoftvid 		\
		--disable-decoder=ptx 				\
		--disable-decoder=txd 				\
		--disable-decoder=vp6a 				\
		--disable-decoder=amv 				\
		--disable-decoder=vb 				\
		--disable-decoder=pcx 				\
		--disable-decoder=sunrast 			\
		--disable-decoder=indeo4 			\
		--disable-decoder=indeo5 			\
		--disable-decoder=mimic 			\
		--disable-decoder=rl2 				\
		--disable-decoder=escape124 		\
		--disable-decoder=dirac 			\
		--disable-decoder=bfi 				\
		--disable-decoder=motionpixels 		\
		--disable-decoder=aura 				\
		--disable-decoder=aura2 			\
		--disable-decoder=v210x 			\
		--disable-decoder=tmv 				\
		--disable-decoder=v210 				\
		--disable-decoder=dpx 				\
		--disable-decoder=frwu 				\
		--disable-decoder=flashsv2 			\
		--disable-decoder=cdgraphics 		\
		--disable-decoder=r210 				\
		--disable-decoder=anm 				\
		--disable-decoder=iff_ilbm 			\
		--disable-decoder=kgv1 				\
		--disable-decoder=yop 				\
		--disable-decoder=webp 				\
		--disable-decoder=pictor 			\
		--disable-decoder=ansi 				\
		--disable-decoder=r10k 				\
		--disable-decoder=mxpeg 			\
		--disable-decoder=lagarith 			\
		--disable-decoder=prores 			\
		--disable-decoder=jv 				\
		--disable-decoder=dfa 				\
		--disable-decoder=wmv3image 		\
		--disable-decoder=vc1image 			\
		--disable-decoder=utvideo 			\
		--disable-decoder=bmv_video 		\
		--disable-decoder=vble 				\
		--disable-decoder=dxtory 			\
		--disable-decoder=v410 				\
		--disable-decoder=xwd 				\
		--disable-decoder=cdxl 				\
		--disable-decoder=xbm 				\
		--disable-decoder=zerocodec 		\
		--disable-decoder=mss1 				\
		--disable-decoder=msa1 				\
		--disable-decoder=tscc2 			\
		--disable-decoder=mts2 				\
		--disable-decoder=cllc 				\
		--disable-decoder=mss2 				\
		--disable-decoder=y41p 				\
		--disable-decoder=escape130 		\
		--disable-decoder=exr 				\
		--disable-decoder=avrp 				\
		--disable-decoder=avui 				\
		--disable-decoder=ayuv 				\
		--disable-decoder=v308 				\
		--disable-decoder=v408 				\
		--disable-decoder=yuv4 				\
		--disable-decoder=sanm 				\
		--disable-decoder=paf_video 		\
		--disable-decoder=avrn 				\
		--disable-decoder=cpia 				\
		--disable-decoder=bintext 			\
		--disable-decoder=xbin 				\
		--disable-decoder=idf 				\
		--disable-decoder=hevc

	make -j$(NPROCS)

install:
	make DESTDIR=$(P_DESTDIR) install
