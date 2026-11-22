# piccolo-ax-desktop/profiles/desktop-core.mk
# Core Desktop profile (Tier A): lightweight session, Falkon, office, readers,
# fullscreen media/YouTube playback, 2D/pixel graphics, binary inspection,
# classic trackers/audio tools, silicon diagnostics, and CLI/X11 helpers.
# Excludes heavy creative/transcoding/security suites (see profiles/desktop-heavy.mk).

AX_DESKTOP_CORE_ENABLED ?= y

# Desktop session choice: lxqt (default with Falkon) or xfce
AX_DESKTOP_SESSION ?= lxqt

# File managers (LXQt native + classic Directory Opus-style dual-pane) & GUI archiver
AX_PKG_PCMANFM_QT ?= y
AX_PKG_WORKER ?= y
AX_PKG_LXQT_ARCHIVER ?= y

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

# Classic Amiga/ST-inspired tracker & audio utilities
AX_PKG_MILKYTRACKER ?= y
AX_PKG_MHWAVEEDIT ?= y
AX_PKG_QASMIXER ?= y

# Binary inspection, viewer, screenshot & calculator utilities
AX_PKG_GHEX ?= y
AX_PKG_FEH ?= y
AX_PKG_SCROT ?= y
AX_PKG_QALCULATE_QT ?= y

# Silicon, GPU & process diagnostics (CPU-Z / GPU-Z / core-pinning monitors)
AX_PKG_CPUX ?= y
AX_PKG_NVTOP ?= y
AX_PKG_HTOP ?= y

# Lightweight PDF viewer choice: qpdfview, mupdf, or atril
AX_DESKTOP_PDF_VIEWER ?= qpdfview

# Developer, file, X11 & editing utilities
AX_PKG_GIT ?= y
AX_PKG_TERMINAL ?= y
AX_PKG_ARCHIVE_TOOLS ?= y
AX_PKG_LHASA ?= y
AX_PKG_DEV_TEXT_TOOLS ?= y
AX_PKG_X11_HELPERS ?= y
AX_PKG_TEXT_EDITOR ?= y

# Guardrails: keep heavy creative/media/security tools off by default in core
AX_DESKTOP_HEAVY_GIMP ?= n
AX_DESKTOP_HEAVY_KRITA ?= n
AX_DESKTOP_HEAVY_SHOTCUT ?= n
AX_DESKTOP_HEAVY_HANDBRAKE ?= n
AX_DESKTOP_HEAVY_KEEPASSXC ?= n
