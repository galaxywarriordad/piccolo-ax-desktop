# piccolo-ax-desktop/profiles/desktop-heavy.mk
# Optional Heavy Tier profile (Tier B): opt-in creative & transcoding tools.
# Run strictly inside secondary desktop sessions; avoid real-time appliance cores.

AX_DESKTOP_HEAVY_ENABLED ?= n

# Image & painting tools
AX_DESKTOP_HEAVY_GIMP ?= n
AX_DESKTOP_HEAVY_KRITA ?= n

# Video editing & batch transcoding
AX_DESKTOP_HEAVY_SHOTCUT ?= n
AX_DESKTOP_HEAVY_HANDBRAKE ?= n

# Delivery mode hint for heavy tools: "appimage-share" or "package"
AX_DESKTOP_HEAVY_DELIVERY ?= appimage-share

# Target directory on persistent SHARE storage for AppImages / portable tools
AX_SHARE_MOUNT ?= /userdata
AX_SHARE_APPS_DIR ?= $(AX_SHARE_MOUNT)/desktop/apps
