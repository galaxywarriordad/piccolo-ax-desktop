# piccolo-ax-desktop/profiles/desktop-heavy.mk
# Optional Heavy Creative, Media, DAW & Security Tier (Tier B)
# Disabled by default to preserve Piccolo-AX's < 512 MB toram EROFS budget.
# Delivery mode: appimage-share (recommended, staged under SHARE) or package.

AX_DESKTOP_HEAVY_ENABLED ?= n

# Delivery mode: appimage-share (default) or package
AX_DESKTOP_HEAVY_DELIVERY ?= appimage-share

# Heavy raster painting, vector & 3D graphics
AX_DESKTOP_HEAVY_GIMP ?= n
AX_GIMP_ADDON_GMIC ?= y

AX_DESKTOP_HEAVY_KRITA ?= n

AX_DESKTOP_HEAVY_INKSCAPE ?= n
AX_INKSCAPE_ADDON_BOXES ?= y

AX_DESKTOP_HEAVY_BLENDER ?= n
# Optional Blender add-ons (staged on SHARE under XDG_CONFIG_HOME/blender)
AX_BLENDER_ADDON_ESSENTIALS ?= y
AX_BLENDER_ADDON_RIGIFY ?= n
AX_BLENDER_ADDON_CAD_SKETCHER ?= n
AX_BLENDER_ADDON_SPRYTILE ?= n
AX_BLENDER_ADDON_SVERCHOK ?= n

# Nonlinear video editing, GPU capture & batch transcoding
AX_DESKTOP_HEAVY_SHOTCUT ?= n
AX_DESKTOP_HEAVY_KDENLIVE ?= n
AX_VIDEO_ADDON_GLAXNIMATE ?= n

AX_DESKTOP_HEAVY_HANDBRAKE ?= n

AX_DESKTOP_HEAVY_OBS ?= n
AX_OBS_ADDON_VKCAPTURE ?= y

# Multi-track DAW / MIDI production
AX_DESKTOP_HEAVY_ARDOUR ?= n
AX_ARDOUR_ADDON_LV2_PACK ?= y

# Full office suite & desktop publishing (DTP)
AX_DESKTOP_HEAVY_LIBREOFFICE ?= n
AX_DESKTOP_HEAVY_SCRIBUS ?= n

# Local-first credential & key vault (.kdbx stored on SHARE)
AX_DESKTOP_HEAVY_KEEPASSXC ?= n
