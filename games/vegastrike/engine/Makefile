# $OpenBSD$

# needs LOTS of memory
ONLY_FOR_ARCHS =	amd64

COMMENT =		3D space simulator

DISTNAME =		vegastrike-src-${V}
PKGNAME =		vegastrike-${V}

WANTLIB += GL GLU OgreMain SDL X11 Xcomposite Xcursor Xdamage
WANTLIB += Xext Xfixes Xi Xinerama Xmu Xrandr Xrender atk-1.0
WANTLIB += boost_python boost_thread-mt c cairo expat fontconfig
WANTLIB += freetype gdk-x11-2.0 gdk_pixbuf-2.0 gio-2.0 glib-2.0
WANTLIB += glut gobject-2.0 gtk-x11-2.0 iconv intl jpeg m ogg
WANTLIB += openal pango-1.0 pangocairo-1.0 pangoft2-1.0 pixman-1
WANTLIB += png pthread pthread-stubs stdc++ util vorbis vorbisfile
WANTLIB += xcb xcb-render xcb-shm z

PATCHORIG =		.orig.port

MODULES =		lang/python
#BUILD_DEPENDS =	???
RUN_DEPENDS =		games/vegastrike/data>=${V}
LIB_DEPENDS =		x11/gtk+2 \
			audio/openal \
			devel/boost \
			audio/libvorbis \
			x11/ogre \
			graphics/freeglut \
			devel/sdl


CONFIGURE_STYLE =	gnu
CONFIGURE_ARGS +=	${CONFIGURE_SHARED} \
			--with-python-version=${MODPY_VERSION} \
			--with-png-libs="${LOCALBASE}/lib" \
			--with-png-inc="${LOCALBASE}/include/libpng" \
			--with-jpeg-libs="${LOCALBASE}/lib" \
			--with-openal-libs="${LOCALBASE}/lib" \
			--with-al-inc="${LOCALBASE}/include" \
			--with-vorbis-libs="${LOCALBASE}/lib" \
			--with-vorbis-inc="${LOCALBASE}/include/vorbis" \
			--with-boost=system \
			--with-data-dir="${TRUEPREFIX}/share/vegastrike"
CONFIGURE_ENV =	\
	CPPFLAGS="-I${X11BASE}/include -I${LOCALBASE}/include -I${LOCALBASE}/include/libpng" \
	LDFLAGS="-L${X11BASE}/lib -L${LOCALBASE}/lib"

.include <bsd.port.mk>
