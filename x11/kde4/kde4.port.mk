# $OpenBSD$

.include "kdeversions.port.mk"

# The version of KDE SC in x11/kde4
_MODKDE4_STABLE =	4.9.3

# Should be changed only by Makefile.inc in test directories
MODKDE4_VERSION ?=	${_MODKDE4_STABLE}
MODKDE_VERSION =	${MODKDE4_VERSION}

# General options set by module
SHARED_ONLY ?=		Yes
ONLY_FOR_ARCHS ?=	${GCC4_ARCHS}
EXTRACT_SUFX ?=		.tar.xz

CATEGORIES +=		x11/kde4

.if "${NO_BUILD:L}" != "yes"
MODULES +=		devel/cmake
SEPARATE_BUILD ?=	flavored

# CONFIGURE_STYLE needs separate handling because it is set to empty
# string in bsd.port.mk initially.
.  if "${CONFIGURE_STYLE}" == ""
CONFIGURE_STYLE =	cmake
.  endif
.endif

# MODKDE4_RESOURCES: Yes/No
#   If enabled, disable default Qt and KDE LIB_DEPENDS and RUN_DEPENDS,
#   and set PKG_ARCH=*. Also, FLAVORS will not be touched. "libs"
#   dependencies in MODKDE4_USE (see below) will become a BUILD_DEPENDS.

MODKDE4_RESOURCES ?=	No

# MODKDE4_USE: [libs | runtime | workspace] [PIM]
#   - Set to empty for stuff that is a prerequisite for kde base blocks:
#     kdelibs, kde-runtime, kdepimlibs or kdepim-runtime.
#
#   - Set to "libs" for ports that need only libs, without runtime support.
#     All options below imply "libs". If no from "none", "libs" or
#     "runtime" were specified, "libs" is implied. This is the default
#     value when MODKDE4_RESOURCES is enabled.
#
#   - Set to "runtime" for ports which depend on base KDE libraries and
#     runtime components. This is the default setting until
#     MODKDE4_RESOURCES is enabled.
#
#   - Set to "workspace" for ports that require KDE workspace libraries.
#     This automatically implies "runtime".
#
#   - Add "pim" when port depends on KDE PIM framework, i.e. LIB_DEPENDS
#     on kdepimlibs and, if "libs" was not specified, RUN_DEPENDS on
#     kdepim-runtime.
#
# NOTE: There are no options like "Kate" or "Okular", they should be handled
#       with simple LIB_DEPENDS on corresponding packages in addition to
#       options above.
#

.if ${MODKDE4_RESOURCES:L} == "no"
MODKDE4_USE ?=		runtime
.else
MODKDE4_USE ?=		libs
MODKDE_NO_QT ?=		Yes
.endif

_MODKDE4_USE_ALL =	libs runtime workspace pim
.for _modkde4_u in ${MODKDE4_USE:L}
.   if !${_MODKDE4_USE_ALL:M${_modkde4_u}}
ERRORS += "Fatal: unknown KDE 4 use flag: ${_modkde4_u}"
ERRORS += "Fatal: (not one from ${_MODKDE4_USE_ALL})."
.   endif
.endfor
.if ${MODKDE4_USE:L} == "pim" || ${MODKDE4_USE:Mworkspace}
MODKDE4_USE +=		runtime
.endif

# 1. Force CMake which has merged KDE modules
# 2. Various distfiles contain long paths, necessitating an archiver
# compliant with POSIX.1-2001 extended headers.
MODKDE4_BUILD_DEPENDS =	archivers/gtar \
			STEM->=2.8.8:devel/cmake \
			textproc/docbook \
			textproc/docbook-xsl
MODKDE4_LIB_DEPENDS =
MODKDE4_RUN_DEPENDS =
MODKDE4_WANTLIB =
MODKDE4_CONF_ARGS =

TAR =			${LOCALBASE}/bin/gtar

FLAVOR ?=

.ifdef MODKDE_NO_QT
MODKDE4_NO_QT ?=	${MODKDE_NO_QT}
.endif

.if ${MODKDE4_USE:L:Mruntime} || ${MODKDE4_USE:L:Mpim}
MODKDE4_USE +=		libs
.endif

.if ${MODKDE4_RESOURCES:L} != "no"
PKG_ARCH ?=		*
MODKDE4_NO_QT ?=	Yes	# resources usually don't need Qt
.   if ${MODKDE4_USE:L:Mworkspace}
MODKDE4_BUILD_DEPENDS +=	STEM->=${MODKDE4_VERSION}:x11/kde4/workspace
.   endif
.   if ${MODKDE4_USE:L:Mlibs}
MODKDE4_BUILD_DEPENDS +=	STEM->=${MODKDE4_VERSION}:x11/kde4/libs
.   endif
.else
# Small hack, until automoc4 will be gone
PKGNAME ?= ${DISTNAME}
.   if !${PKGNAME:Mautomoc4-*}
MODKDE4_BUILD_DEPENDS +=	devel/automoc
.   endif

MODKDE4_NO_QT ?=	No
.   if ${MODKDE4_USE:L:Mlibs}
.       if ${MODKDE4_NO_QT:L} == "yes"
ERRORS +=	"Fatal: KDE libraries require Qt."
.       endif

MODKDE4_LIB_DEPENDS +=		STEM->=${MODKDE4_VERSION}:x11/kde4/libs
MODKDE4_WANTLIB +=		kdecore>=8
.       if ${MODKDE4_USE:L:Mpim}
MODKDE4_LIB_DEPENDS +=		STEM->=${MODKDE4_VERSION}:x11/kde4/pimlibs
.       endif

.       if ${MODKDE4_USE:L:Mruntime}
MODKDE4_RUN_DEPENDS +=		STEM->=${MODKDE4_VERSION}:x11/kde4/runtime
.           if ${MODKDE4_USE:L:Mpim}
MODKDE4_RUN_DEPENDS +=		STEM->=${MODKDE4_VERSION}:x11/kde4/pim-runtime
.           endif

.           if ${MODKDE4_USE:L:Mworkspace}
MODKDE4_LIB_DEPENDS +=		STEM->=${MODKDE4_VERSION}:x11/kde4/workspace
.           endif
.       endif
.   endif    # ${MODKDE4_USE:L:Mlibs}

# See FindKDE4Internal.cmake from kdelibs package for details.
.if ${CONFIGURE_STYLE:Mcmake}
.   if ${FLAVOR:Mdebug}
# No optimization, debug symbols included, qDebug/kDebug enabled
MODKDE4_CONF_ARGS +=	-DCMAKE_BUILD_TYPE:String=DebugFull
MODKDE4_CMAKE_PREFIX =	-debugfull
.   else
# Optimization for speed, debug symbols stripped, qDebug/kDebug disabled
MODKDE4_CONF_ARGS +=	-DCMAKE_BUILD_TYPE:String=Release
MODKDE4_CMAKE_PREFIX =	-release
.   endif

MODKDE4_INCLUDE_DIR =	include/kde4
MODKDE4_LIB_DIR =	lib/kde4/private
MODKDE_INCLUDE_DIR =	${MODKDE4_INCLUDE_DIR}
MODKDE_LIB_DIR =	${MODKDE4_LIB_DIR}

# Use right directories
MODKDE4_CONF_ARGS +=	-DMAN_INSTALL_DIR:Path=${PREFIX}/man \
			-DINFO_INSTALL_DIR:Path=${PREFIX}/info \
			-DLIBEXEC_INSTALL_DIR:Path=${PREFIX}/libexec \
			-DSYSCONF_INSTALL_DIR:Path=${SYSCONFDIR}

# Avoid conflicts with KDE3.
# Libraries are handled in kde4-post-install target, see below.
MODKDE4_CONF_ARGS +=	-DINCLUDE_INSTALL_DIR:Path=${MODKDE4_INCLUDE_DIR} \
			-DKDE4_LIB_INSTALL_DIR:Path=${PREFIX}/${MODKDE4_LIB_DIR}

# Enable PIE if supported by platform
. if !empty(PIE_ARCH:M${ARCH})
MODKDE4_CONF_ARGS +=	-DKDE4_ENABLE_FPIE:Bool=Yes
. else
MODKDE4_CONF_ARGS +=	-DKDE4_ENABLE_FPIE:Bool=No
. endif

# NOTE: due to bugs in make-plist, plist may contain
# ${FLAVORS} instead of ${MODKDE4_CMAKE_PREFIX}.
# You've been warned.
SUBST_VARS +=		MODKDE4_CMAKE_PREFIX

FLAVORS +=	debug
.endif

# ${MODKDE4_RESOURCES:L} != "no"
.endif

.if ${CONFIGURE_STYLE:Mcmake}
. if "${NO_REGRESS:L}" != "yes"
# Enable regression tests if any
MODKDE4_CONF_ARGS +=	-DKDE4_BUILD_TESTS:Bool=Yes
. endif

# Set up directories
MODKDE4_CONF_ARGS +=	-DKDE4_INCLUDE_INSTALL_DIR:String=${PREFIX}/include \
			-DKDE4_INSTALL_DIR:String=${PREFIX} \
			-DKDE4_LIB_INSTALL_DIR:String=${PREFIX}/lib \
			-DKDE4_LIBEXEC_INSTALL_DIR:String=${PREFIX}/libexec \
			-DKDE4_INFO_INSTALL_DIR:String=${PREFIX}/info \
			-DKDE4_MAN_INSTALL_DIR:String=${PREFIX}/man \
			-DKDE4_SYSCONF_INSTALL_DIR:String=${SYSCONFDIR}
.endif

# FIXME
MODKDE4_CONFIGURE_ENV =	HOME=${WRKDIR}
PORTHOME ?=		${WRKDIR}

MODKDE4_NO_QT ?=	No
MODKDE_NO_QT ?=		${MODKDE4_NO_QT}
.if ${MODKDE4_NO_QT:L} == "no"
MODULES +=			x11/qt4
MODQT4_OVERRIDE_UIC ?=		No
MODKDE4_CONFIGURE_ENV +=	QTDIR=${MODQT_LIBDIR}
.endif

MODKDE_BUILD_DEPENDS =	${MODKDE4_BUILD_DEPENDS}
MODKDE_LIB_DEPENDS =	${MODKDE4_LIB_DEPENDS}
MODKDE_RUN_DEPENDS =	${MODKDE4_RUN_DEPENDS}
MODKDE_WANTLIB =	${MODKDE4_WANTLIB}
MODKDE_CONFIGURE_ENV =	${MODKDE4_CONFIGURE_ENV}

BUILD_DEPENDS +=	${MODKDE_BUILD_DEPENDS}

LIB_DEPENDS +=		${MODKDE_LIB_DEPENDS}

RUN_DEPENDS +=		${MODKDE_RUN_DEPENDS}
WANTLIB +=		${MODKDE_WANTLIB}
CONFIGURE_ENV +=	${MODKDE_CONFIGURE_ENV}
CONFIGURE_ARGS +=	${MODKDE4_CONF_ARGS}
# MAKE_FLAGS +=		${MODKDE4_CONF_ARGS}

# Tweak dependency path for testing directories
.if "${MODKDE4_VERSION}" != "${_MODKDE4_STABLE}"
_MODKDE4_REAL_DIR =	x11/kde${MODKDE4_VERSION:S/.//g}
CATEGORIES +=		${_MODKDE4_REAL_DIR}
BUILD_DEPENDS :=	${BUILD_DEPENDS:C@x11/kde4/@${_MODKDE4_REAL_DIR}/@}
RUN_DEPENDS :=		${RUN_DEPENDS:C@x11/kde4/@${_MODKDE4_REAL_DIR}/@}
LIB_DEPENDS :=		${LIB_DEPENDS:C@x11/kde4/@${_MODKDE4_REAL_DIR}/@}
. if "${MULTI_PACKAGES}" != ""
.  for _s in ${MULTI_PACKAGES}
.   if defined(RUN_DEPENDS${_s})
RUN_DEPENDS${_s} :=	${RUN_DEPENDS${_s}:C@x11/kde4/@${_MODKDE4_REAL_DIR}/@}
.   endif
.   if defined(LIB_DEPENDS${_s})
LIB_DEPENDS${_s} :=	${LIB_DEPENDS${_s}:C@x11/kde4/@${_MODKDE4_REAL_DIR}/@}
.   endif
.  endfor
. endif
.endif

# System (CMake) FindGettext.cmake requires having PO_FILES marker
MODKDE4_post-patch =	@echo '====> Fixing GETTEXT_PROCESS_PO_FILES() calls'; \
	cd ${WRKSRC} && find . -name CMakeLists.txt | sort | \
		while read F; do \
			perl -pi.pofilesfix -e '\
			if (/GETTEXT_PROCESS_PO_FILES/ and !/\sPO_FILES/) { \
				s@\$$\{_po_files\}@PO_FILES $$&@; \
			}' "$$F"; \
			if cmp -s "$$F" "$$F".pofilesfix; then \
				rm "$$F".pofilesfix; \
			else \
				echo "$$F" >&2; \
			fi; \
		done

# Some KDE ports install files under ${SYSCONFDIR}.
# We want to have them under ${PREFIX}/share/examples or such,
# and just be @sample'd under ${SYSCONFDIR}.
# So add "file/dir destination" pairs to this variable, and
# apporiate @sample lines to packing list, e.g.:
#   dbus-1	share/examples
MODKDE4_SYSCONF_FILES ?=

# Create soft links for shared libraries in ${PREFIX}/lib to
# ${MODKDE4_LIB_DIR}. Used to avoid clashing with KDE 3.
MODKDE4_LIB_LINKS ?=	No

# We cannot use at least "MODKDE4_pre-install", as it means a totally different
# thing for MODULES rather than for ports. So play another game...

# Always create directory for headers, remove later if left empty
kde4-pre-install:
	${INSTALL_DATA_DIR} ${PREFIX}/${MODKDE4_INCLUDE_DIR}

# 1. Remove includes directory created above, if empty.
# 2. Create links for shared libraries in ${PREFIX}/lib/kde4/private/ ,
#    to allow using -DKDE4_LIB_INSTALL_DIR=${PREFIX}/lib/kde4/private.
# 3. Fixup files in ${SYSCONFDIR}, see notes for MODKDE4_SYSCONF_FILES above.
kde4-post-install:
	rmdir ${PREFIX}/${MODKDE4_INCLUDE_DIR} 2>/dev/null || true
#	if [ -d ${PREFIX}/lib/kde4 ]; then \
#		${INSTALL_DATA_DIR} ${PREFIX}/${MODKDE4_LIB_DIR}; \
#		cd ${PREFIX}/${MODKDE4_LIB_DIR} && ln -s .. kde4; \
#	fi
.if ${MODKDE4_LIB_LINKS:L} == "yes" && defined(SHARED_LIBS) && !empty(SHARED_LIBS)
	${INSTALL_DATA_DIR} ${PREFIX}/${MODKDE4_LIB_DIR}
. for _l _v in ${SHARED_LIBS}
# Note that number of upper-level directories depends on
# actual ${MODKDE4_LIB_DIR} value relative to ${PREFIX}/lib.
	if [ -e ${PREFIX}/lib/lib${_l}.so.${_v} ]; then \
		cd ${PREFIX}/${MODKDE4_LIB_DIR} && \
		    ln -sf ../../lib${_l}.so.${_v}; \
	fi
. endfor
.endif
.for _f _d in ${MODKDE4_SYSCONF_FILES}
	rm -Rf ${PREFIX}/${_d}/${_f}
	${INSTALL_DATA_DIR} ${PREFIX}/${_d}
	mv ${WRKINST}${SYSCONFDIR}/${_f} ${PREFIX}/${_d}/${_f}
.endfor

.if !target(pre-install)
pre-install: kde4-pre-install
.endif
.if !target(post-install)
post-install: kde4-post-install
.endif
