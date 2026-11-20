################################################################################
#
# libresprite
#
################################################################################

LIBRESPRITE_VERSION = v1.2
LIBRESPRITE_SITE = https://github.com/LibreSprite/LibreSprite
LIBRESPRITE_SITE_METHOD = git
LIBRESPRITE_GIT_SUBMODULES = YES
LIBRESPRITE_LICENSE = GPL-2.0
LIBRESPRITE_LICENSE_FILES = LICENSE.txt
LIBRESPRITE_SUPPORTS_IN_SOURCE_BUILD = NO
LIBRESPRITE_DEPENDENCIES = \
	host-pkgconf \
	sdl2 \
	sdl2_image \
	libpng \
	jpeg \
	giflib \
	zlib \
	pixman \
	freetype \
	tinyxml2 \
	libcurl

LIBRESPRITE_CONF_OPTS = \
	-DCMAKE_BUILD_TYPE=Release \
	-DWITH_DESKTOP_INTEGRATION=ON \
	-DWITH_WEBP_SUPPORT=OFF \
	-DENABLE_UPDATER=OFF \
	-DENABLE_TESTS=OFF

$(eval $(cmake-package))
