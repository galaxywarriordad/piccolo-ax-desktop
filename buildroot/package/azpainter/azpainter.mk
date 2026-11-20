################################################################################
#
# azpainter
#
################################################################################

AZPAINTER_VERSION = 3.0.9a
AZPAINTER_SOURCE = azpainter-v$(AZPAINTER_VERSION).tar.gz
AZPAINTER_SITE = https://gitlab.com/azelpg/azpainter.git
AZPAINTER_LICENSE = GPL-3.0+
AZPAINTER_LICENSE_FILES = COPYING
AZPAINTER_DEPENDENCIES = \
	host-ninja \
	host-pkgconf \
	xlib_libX11 \
	xlib_libXext \
	xlib_libXi \
	xlib_libXcursor \
	freetype \
	fontconfig \
	libpng \
	jpeg \
	zlib

define AZPAINTER_CONFIGURE_CMDS
	(cd $(@D) && \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		PKG_CONFIG="$(PKG_CONFIG_HOST_BINARY)" \
		./configure --prefix=/usr)
endef

define AZPAINTER_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(NINJA) -C $(@D)/build
endef

define AZPAINTER_INSTALL_TARGET_CMDS
	DESTDIR=$(TARGET_DIR) $(NINJA) -C $(@D)/build install
endef

$(eval $(generic-package))
