# $OpenBSD: Makefile.template,v 1.61 2012/03/29 13:41:58 sthen Exp $

COMMENT =		SMTP benchmark and stress tool.

DISTNAME =		postal-0.72
PKGNAME =		${DISTNAME}

CATEGORIES =		benchmarks devel

HOMEPAGE =		http://doc.coker.com.au/projects/postal/

MAINTAINER =	Sergey Bronnikov <estetus@gmail.com>

PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB += c m pthread stdc++

MASTER_SITES =		http://www.coker.com.au/postal/
EXTRACT_SUFX =		.tgz

USE_GMAKE =		Yes
CONFIGURE_STYLE =	gnu
CONFIGURE_ARGS =	--disable-openssl

.include <bsd.port.mk>
