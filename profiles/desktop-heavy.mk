# piccolo-ax-desktop/profiles/desktop-heavy.mk
# Optional Heavy Creative, Media & Security Tier (Tier B)
# Disabled by default to preserve Piccolo-AX's < 512 MB toram EROFS budget.
# Delivery mode: appimage-share (recommended, staged under SHARE) or package.

AX_DESKTOP_HEAVY_ENABLED ?= n

# Delivery mode: appimage-share (default) or package
AX_DESKTOP_HEAVY_DELIVERY ?= appimage-share

# Heavy raster painting & photo manipulation
AX_DESKTOP_HEAVY_GIMP ?= n
AX_DESKTOP_HEAVY_KRITA ?= n

# Nonlinear video editing & batch transcoding
AX_DESKTOP_HEAVY_SHOTCUT ?= n
AX_DESKTOP_HEAVY_KDENLIVE ?= n
AX_DESKTOP_HEAVY_HANDBRAKE ?= n

# Local-first credential & key vault (.kdbx stored on SHARE)
AX_DESKTOP_HEAVY_KEEPASSXC ?= n
