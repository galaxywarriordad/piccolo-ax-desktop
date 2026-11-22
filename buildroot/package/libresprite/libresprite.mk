################################################################################
#
# libresprite
#
################################################################################

LIBRESPRITE_VERSION = v1.2
LIBRESPRITE_SITE = https://github.com/LibreSprite/LibreSprite.git
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

$(eval $(cmake-package))
