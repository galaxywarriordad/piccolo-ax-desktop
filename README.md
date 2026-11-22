# 🖥️ piccolo-ax-desktop

Lightweight, local-first desktop mode for **Piccolo-AX**, engineered to give users, creators, and developers a complete general-purpose workstation without compromising the deterministic, low-latency ethos of the core appliance.

Unlike a standard lightweight Linux distribution—which typically stops at a bare window manager, a basic text editor, and a stripped-down browser—`piccolo-ax-desktop` pairs a cohesive Qt-native desktop (**LXQt**, **Falkon**, **PCManFM-Qt**, **LXQt Archiver**, **qpdfview**, **Qalculate! Qt**) with an Amiga- and Atari ST-inspired native C/C++ creative, audio, and hardware-diagnostics suite (**GrafX2**, **LibreSprite**, **AzPainter**, **mtPaint**, **MilkyTracker**, **mhWaveEdit**, **Worker**, **GHex**, **CPU-X**, **nvtop**, and **htop**) inside a `< 42 MB` Tier A footprint. Every user config, cache, repository, and optional AppImage persists cleanly to `SHARE` storage—keeping the read-only `EROFS` appliance image immutable, fast to boot into RAM (`toram`), and 100% isolated from real-time audio and emulation cores when you return to Appliance Mode.

## 🎯 Ethos & Boundaries

* **Local-first & low-bloat:** Excludes cloud agents, chat/social apps, and background auto-updaters.
* **Strict appliance isolation:** Default boot handles low-latency workloads (`Cores 0–4` vs. Core `5`), while desktop sessions run as an isolated secondary mode.
* **Persistent state on `SHARE`:** User data, XDG directories, documents, and git repositories reside on persistent `SHARE` storage to keep the OS read-only.
* **Bootloader deferred:** Session branching and bootloader entries are held off until target hardware validation.

## 📦 Package Tiers

### 1. Core Desktop (`profiles/desktop-core.mk`)
* **🖥 Session & File Management:** Lightweight LXQt/XFCE session, PCManFM-Qt (`AX_PKG_PCMANFM_QT`), Worker (`AX_PKG_WORKER`), and LXQt Archiver (`AX_PKG_LXQT_ARCHIVER`).
* **🛠️ Developer & Shell Basics:** Git, CLI diff/patch tools, ripgrep, and archive utilities including `lhasa` (`AX_PKG_LHASA`) for Amiga archives.
* **🌐 Browser:** Falkon (Qt-native C++ browser with ad-blocking).
* **🎬 Media & YouTube:** `mpv` + `yt-dlp` with hardware decoding and safe fallback via `scripts/launch-yt.sh`.
* **📝 Office & Reading:** AbiWord, Gnumeric, Foliate, and lightweight PDF viewers (`qpdfview`, `MuPDF`, `Atril`).
* **🎨 2D & Pixel Graphics Suite (< 42 MB total):** mtPaint (`AX_PKG_MTPAINT`), GrafX2 (`AX_PKG_GRAFX2`), AzPainter (`AX_PKG_AZPAINTER`), and LibreSprite (`AX_PKG_LIBRESPRITE`).
* **🎵 Classic Audio & Trackers:** MilkyTracker (`AX_PKG_MILKYTRACKER`), mhWaveEdit (`AX_PKG_MHWAVEEDIT`), and QASMixer (`AX_PKG_QASMIXER`).
* **🔍 Diagnostics & Inspection:** GHex (`AX_PKG_GHEX`), feh, scrot, Qalculate! Qt (`AX_PKG_QALCULATE_QT`), CPU-X (`AX_PKG_CPUX`), nvtop (`AX_PKG_NVTOP`), and htop (`AX_PKG_HTOP`).

### 2. Optional Heavy Tier (`profiles/desktop-heavy.mk`)
* **🎨 Graphics & Video:** GIMP, Krita, Shotcut, Kdenlive, and HandBrake.
* **🔐 Security:** KeePassXC stored locally on `SHARE`.

## 🗂️ Repository Layout

Additional repository details and directory structures can be inspected directly in the project files.
