################################################################################
#
# azpainter
#
################################################################################

AZPAINTER_VERSION = 3.0.9a
AZPAINTER_SOURCE = azpainter-v$(AZPAINTER_VERSION).tar.gz
AZPAINTER_SITE = https://gitlab.com/azelpg/azpainter/-/archive/v$(AZPAINTER_VERSION)
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

AZPAINTER_NINJA = $(HOST_DIR)/bin/ninja

define AZPAINTER_CONFIGURE_CMDS
	cd $(@D) && \
		$(TARGET_CONFIGURE_OPTS) \
		PKG_CONFIG="$(PKG_CONFIG_HOST_BINARY)" \
		./configure --prefix=/usr
endef

define AZPAINTER_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(AZPAINTER_NINJA) -C $(@D)/build
endef

define AZPAINTER_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(AZPAINTER_NINJA) -C $(@D)/build install DESTDIR=$(TARGET_DIR)
endef

$(eval $(generic-package))
