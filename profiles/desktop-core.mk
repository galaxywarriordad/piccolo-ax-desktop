# piccolo-ax-desktop/profiles/desktop-core.mk
# Core Desktop profile (Tier A): lightweight session, Falkon, office, readers,
# fullscreen media/YouTube playback, 2D/pixel graphics, binary inspection,
# and silicon diagnostics.
# Excludes heavy creative/transcoding/security suites (see profiles/desktop-heavy.mk).

AX_DESKTOP_CORE_ENABLED ?= y

# Desktop session choice: lxqt (default with Falkon) or xfce
AX_DESKTOP_SESSION ?= lxqt

# Core applications
AX_PKG_FALKON ?= y
AX_PKG_ABIWORD ?= y
AX_PKG_GNUMERIC ?= y
AX_PKG_FOLIATE ?= y

# Fullscreen media & YouTube playback (paired with overlays/common/etc/mpv/mpv.conf and scripts/launch-yt.sh)
AX_PKG_MPV ?= y
AX_PKG_YTDLP ?= y

# Core 2D & pixel graphics suite (< 30 MB total)
AX_PKG_MTPAINT ?= y
AX_PKG_GRAFX2 ?= y
AX_PKG_AZPAINTER ?= y
AX_PKG_LIBRESPRITE ?= y

# Binary inspection, viewer & screenshot utilities
AX_PKG_GHEX ?= y
AX_PKG_FEH ?= y
AX_PKG_SCROT ?= y

# Silicon & GPU diagnostics (CPU-Z / GPU-Z equivalents)
AX_PKG_CPUX ?= y
AX_PKG_NVTOP ?= y

# Lightweight PDF viewer choice: qpdfview, mupdf, or atril
AX_DESKTOP_PDF_VIEWER ?= qpdfview

# Developer & file utilities
AX_PKG_GIT ?= y
AX_PKG_TERMINAL ?= y
AX_PKG_ARCHIVE_TOOLS ?= y

# Guardrails: keep heavy creative/media/security tools off by default in core
AX_DESKTOP_HEAVY_GIMP ?= n
AX_DESKTOP_HEAVY_KRITA ?= n
AX_DESKTOP_HEAVY_SHOTCUT ?= n
AX_DESKTOP_HEAVY_HANDBRAKE ?= n
AX_DESKTOP_HEAVY_KEEPASSXC ?= n
