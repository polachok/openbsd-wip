# $OpenBSD: Makefile,v 1.18 2010/11/22 08:37:02 espie Exp $

COMMENT =	K Desktop Environment, libraries
DISTNAME =	kdelibs-${MODKDE_VERSION}
REVISION =	2

SHARED_LIBS =	kde3support          1.0      # .4.0
SHARED_LIBS +=	kdecore              9.0      # .5.0
SHARED_LIBS +=	kdefakes             9.0      # .5.0
SHARED_LIBS +=	kdesu                9.0      # .5.0
SHARED_LIBS +=	kdeui                10.0      # .5.0
SHARED_LIBS +=	kdnssd               4.0      # .2.0
SHARED_LIBS +=	khtml                9.0      # .5.0
SHARED_LIBS +=	kimproxy             3.0      # .4.0
SHARED_LIBS +=	kio                  9.0      # .5.0
SHARED_LIBS +=	kjs                  7.0      # .2.0
SHARED_LIBS +=	kjsembed             4.0      # .4.0
SHARED_LIBS +=	kmediaplayer         3.0      # .4.0
SHARED_LIBS +=	knotifyconfig        1.0      # .4.0
SHARED_LIBS +=	kntlm                3.0      # .1.0
SHARED_LIBS +=	kparts               6.0      # .4.0
SHARED_LIBS +=	krosscore            1.0      # .4.0
SHARED_LIBS +=	ktexteditor          3.0      # .4.0
SHARED_LIBS +=	kunittest            4.0      # .4.0
SHARED_LIBS +=	kutils               6.0      # .2.0
SHARED_LIBS +=	solid                1.0      # .4.0
SHARED_LIBS +=	threadweaver         1.0      # .4.0
SHARED_LIBS +=	kfile                1.0      # .4.0
SHARED_LIBS +=	knewstuff2           1.0      # .4.0
SHARED_LIBS +=	krossui              1.0      # .4.0
SHARED_LIBS +=  kpty                 1.0      # .4.0

SHARED_LIBS +=  kjsapi 			1.0
SHARED_LIBS +=	kdewebkit		1.0
SHARED_LIBS +=	knewstuff3		1.0
SHARED_LIBS +=	kunitconversion		1.0
SHARED_LIBS +=	plasma			1.0

SHARED_LIBS +=  kcmutils		1.0 # 4.7
SHARED_LIBS +=  kdeclarative		1.0 # 5.7
SHARED_LIBS +=  kemoticons		1.0 # 4.7
SHARED_LIBS +=  kidletime		1.0 # 4.7
SHARED_LIBS +=  kprintutils		1.0 # 4.7

SHARED_LIBS +=  nepomuk			1.0 # 4.9
SHARED_LIBS +=  nepomukquery		1.0 # 4.9
SHARED_LIBS +=  nepomukutils		1.0 # 4.9

# Each lib is used by corresponding binary in libexec/,
# so technically those are not plugins.
SHARED_LIBS +=	kdeinit4_kbuildsycoca4		0.0
SHARED_LIBS +=	kdeinit4_kconf_update		0.0
SHARED_LIBS +=	kdeinit4_kded4			0.0
SHARED_LIBS +=	kdeinit4_kio_http_cache_cleaner	0.0
SHARED_LIBS +=	kdeinit4_klauncher		0.0

WANTLIB =  c m pthread stdc++ z
WANTLIB += Half ICE Iex IlmImf IlmThread Imath
WANTLIB += lib/qt4/Qt3Support lib/qt4/QtDBus lib/qt4/QtDeclarative
WANTLIB += lib/qt4/QtGui lib/qt4/QtNetwork lib/qt4/QtOpenGL
WANTLIB += lib/qt4/QtScript lib/qt4/QtSql lib/qt4/QtSvg
WANTLIB += lib/qt4/QtWebKit lib/qt4/QtXml SM X11 Xau Xcursor Xdmcp Xext
WANTLIB += Xfixes Xft Xpm Xrender Xss Xtst asn1 aspell attica
WANTLIB += bz2 com_err crypto dbusmenu-qt enchant exslt fam
WANTLIB += gif gssapi intl jasper jpeg krb5 lzma pcre pcreposix
WANTLIB += png polkit-qt-core-1 qca2 soprano sopranoclient
WANTLIB += ssl streamanalyzer streams util xml2 xslt

MODULES =	multimedia/phonon
MODKDE4_USE =

BUILD_DEPENDS =	misc/shared-desktop-ontologies>=0.10 \
		misc/shared-mime-info \
		net/avahi \
		x11/grantlee

RUN_DEPENDS =	misc/shared-mime-info \
		misc/shared-desktop-ontologies \
		net/cagibi \
		sysutils/gamin \
		STEM->=${MODKDE4_VERSION}:x11/kde4/oxygen-icons \
		x11/dbus \
		x11/grantlee

LIB_DEPENDS =	archivers/bzip2 \
		archivers/xz \
		STEM->=${SOPRANO_VERSION}:databases/soprano \
		databases/strigi \
		devel/pcre \
		graphics/jasper \
		graphics/libungif \
		graphics/openexr \
		security/qca2 \
		sysutils/gamin \
		textproc/aspell/core \
		textproc/enchant \
		textproc/libxslt \
		STEM->=${ATTICA_VERSION}:productivity/attica \
		x11/dbusmenu-qt \
		x11/polkit-qt4

# we don't have krb5-config
CONFIGURE_ARGS =	-DGSSAPI_LIBS:STRING="-lgssapi -lkrb5 -lasn1 -lcom_err -lssl -lcrypto" \
			-DGSSAPI_INCS:STRING="/usr/include/kerberosV" \
			-DGSSAPI_FLAVOR:STRING="HEIMDAL" \
			-DGSSAPI_FOUND:BOOL=TRUE

# and do not have this stuff at all
CONFIGURE_ARGS +=	-DWITH_ACL:Bool=FALSE \
			-DWITH_HSPELL:Bool=FALSE \
			-DWITH_HUpnp:Bool=FALSE \
			-DWITH_UDev:Bool=FALSE

# some basic defines
CONFIGURE_ARGS +=	-D_KDE_DEFAULT_HOME_POSTFIX:String="4" \
			-DKDE_DISTRIBUTION_TEXT:String="OpenBSD Ports" \
			-DKDE4_AUTH_BACKEND_NAME:String="PolkitQt-1" \
			-DKDESU_USE_SUDO_DEFAULT:Bool=TRUE

# Reimplemented CMake modules, because previous were totally broken
REWR_CMAKE_MODULES =	FindXine FindXKB FindPolkitQt

# Contain (required) additional functionality compared to system ones
WRAP_CMAKE_MODULES =	FindLibXslt

MODKDE4_SYSCONF_FILES =	dbus-1	share/examples \
			xdg	share/examples

post-extract:
.for M in ${REWR_CMAKE_MODULES}
	cp ${FILESDIR}/${M}.cmake ${WRKSRC}/cmake/modules/${M}.cmake
.endfor
.for M in ${WRAP_CMAKE_MODULES}
	${SUBST_CMD} -c ${FILESDIR}/${M}.cmake ${WRKSRC}/cmake/modules/${M}.cmake
.endfor
	cp ${FILESDIR}/config-util.h.cmake ${WRKSRC}/kdecore/util/
	cp ${FILESDIR}/ConfigureChecks.cmake ${WRKSRC}/kdecore/util/

.include <bsd.port.mk>
