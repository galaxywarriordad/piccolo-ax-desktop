################################################################################
#
# ghex
#
################################################################################

GHEX_VERSION = 46.0
GHEX_SOURCE = ghex-$(GHEX_VERSION).tar.xz
GHEX_SITE = https://gnome.org
GHEX_LICENSE = GPL-2.0+
GHEX_LICENSE_FILES = COPYING
GHEX_DEPENDENCIES = host-pkgconf libgtk3

GHEX_CONF_OPTS = \
	-Dgtk_doc=false \
	-Dintrospection=disabled

$(eval $(meson-package))

