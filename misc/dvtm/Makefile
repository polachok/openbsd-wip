# $OpenBSD: Makefile,v 1.14 2012/04/24 19:28:31 naddy Exp $

COMMENT=		tiling window management for the console

DISTNAME=		dvtm-0.8
CATEGORIES=		misc

HOMEPAGE=		http://www.brain-dump.org/projects/dvtm/
MAINTAINER=		Dennis Herrmann <dhn@FreeBSD.org>

# MIT/X
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_CDROM= Yes
PERMIT_DISTFILES_FTP=	Yes

WANTLIB= 		c ncurses util

MASTER_SITES=		${HOMEPAGE}

FAKE_FLAGS=		DESTDIR=""

NO_REGRESS=     	Yes

.include <bsd.port.mk>
