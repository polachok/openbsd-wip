# $OpenBSD:$

COMMENT =	adds support for https to p5-libwww

DISTNAME =	LWP-Protocol-https-6.03
CATEGORIES =	www net security
CPAN_AUTHOR =	GAAS

MAINTAINER =	Nigel Taylor <nigel@openbsd.org>

# Perl
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

MODULES =	cpan

RUN_DEPENDS =	net/p5-Net-HTTP>=6 \
		security/p5-Mozilla-CA>=20110101 \
		www/p5-libwww>=6.04

# p5-Net-HTTP requires either p5-IO-Socket-SSL
# or p5-Crypt-SSLeay ensure p5-IO-Socket-SSL
# is first
BUILD_DEPENDS =	security/p5-IO-Socket-SSL>=1.54 \
		${RUN_DEPENDS}

.include <bsd.port.mk>
