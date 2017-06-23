P_NAME			= sqlite
P_VERSION		= 3.15.2
P_URL			= http://sqlite.org/2016/sqlite-autoconf-3150200.tar.gz
P_DESCRIPTION	= Self-contained, serverless, zero-configuration, transactional SQL database engine
P_LICENCES		=
P_ARCHS			= arm
P_OPTIONS		=
P_DEPENDS		= libc
P_SRCDIR		= $(P_WORKDIR)/sqlite-autoconf-3150200

fetch:
	cookie fetch $(P_URL)

setup:
	cookie extract sqlite-autoconf-3150200.tar.gz $(P_WORKDIR)

compile:
	cd $(P_SRCDIR) && ./configure --prefix=/usr --host=$(HOST)	\
		CFLAGS="-g -O2 -DSQLITE_ENABLE_FTS3=1					\
		-DSQLITE_ENABLE_COLUMN_METADATA=1						\
		-DSQLITE_ENABLE_UNLOCK_NOTIFY=1							\
		-DSQLITE_SECURE_DELETE=1								\
		-DSQLITE_ENABLE_DBSTAT_VTAB=1"
	cd $(P_SRCDIR) && make $(P_MAKEOPTS)

install:
	cd $(P_SRCDIR) && make DESTDIR=$(P_DESTDIR) install
