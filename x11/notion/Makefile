# $OpenBSD$

COMMENT= 		tiling, tabbed window manager for the X window system
V= 			3-2012042300
DISTNAME= 		notion-$V-src
PKGNAME= 		notion$V
WRKDIST= 		${WRKDIR}/notion-$V
EXTRACT_SUFX= 		.tar.bz2

CATEGORIES= 		x11

HOMEPAGE= 		http://notion.sourceforge.net/

MAINTAINER= 		ports@openbsd.org

# GPL
PERMIT_PACKAGE_CDROM=   Yes
PERMIT_PACKAGE_FTP=     Yes
PERMIT_DISTFILES_CDROM= Yes
PERMIT_DISTFILES_FTP=   Yes

USE_GMAKE= 		Yes

LIB_DEPENDS= 		converters/libiconv

MODULES= 		lang/lua \
			devel/gettext

WANTLIB += 		c X11 Xext lua5.1 m intl iconv

MASTER_SITES= 		${MASTER_SITE_SOURCEFORGE:=notion/}

NO_REGRESS= 		Yes

.include <bsd.port.mk>
