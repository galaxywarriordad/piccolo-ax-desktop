################################################################################
#
# ghex
#
################################################################################

GHEX_VERSION_MAJOR = 3.41
GHEX_VERSION = $(GHEX_VERSION_MAJOR).2
GHEX_SOURCE = ghex-$(GHEX_VERSION).tar.xz
GHEX_SITE = https://gitlab.gnome.org/GNOME/ghex/-/archive/$(GHEX_VERSION)
GHEX_LICENSE = GPL-2.0+
GHEX_LICENSE_FILES = COPYING
GHEX_DEPENDENCIES = host-pkgconf libgtk3

GHEX_CONF_OPTS = \
	-Dgtk_doc=false \
	-Dintrospection=disabled

$(eval $(meson-package))
