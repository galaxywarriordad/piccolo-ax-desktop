################################################################################
#
# cpu-x
#
################################################################################

CPU_X_VERSION = v5.0.4
CPU_X_SITE = https://github.com/TheTumultuousUnicornOfDarkness/CPU-X.git
CPU_X_SITE_METHOD = git
CPU_X_GIT_SUBMODULES = YES
CPU_X_LICENSE = GPL-3.0+
CPU_X_LICENSE_FILES = COPYING
CPU_X_SUPPORTS_IN_SOURCE_BUILD = NO
CPU_X_DEPENDENCIES = \
	host-pkgconf \
	libgtk3 \
	ncurses \
	pciutils \
	procps-ng

CPU_X_CONF_OPTS = \
	-DCMAKE_BUILD_TYPE=Release \
	-DWITH_GTK=ON \
	-DWITH_NCURSES=ON \
	-DWITH_GETTEXT=OFF \
	-DWITH_LIBCPUID=ON \
	-DWITH_LIBPCI=ON \
	-DWITH_LIBGLFW=OFF \
	-DWITH_OPENCL=OFF \
	-DWITH_VULKAN=OFF \
	-DWITH_BANDWIDTH=OFF \
	-DAPPIMAGE=OFF

$(eval $(cmake-package))
