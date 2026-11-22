# 🖥️ piccolo-ax-desktop

Lightweight, local-first desktop mode for **Piccolo-AX**, designed to give users and developers a clean general-purpose escape hatch without compromising the deterministic, low-latency ethos of the core appliance[cite: 7].

## 🎯 Ethos & Boundaries

* **Local-first & low-bloat:** No chat or social apps, no cloud sync agents, and no background auto-updaters running idle in the tray[cite: 7].
* **Strict appliance isolation:** The default **Piccolo-AX** appliance boot remains dedicated to real-time/low-latency workloads (`Cores 0–4` vs. Core `5` / `0x20`, `2.00–2.67 ms` audio, media/capture, and controller/synth workstreams). Desktop sessions run as a separate, on-demand secondary mode with zero desktop or transcoding processes running in default appliance mode[cite: 7].
* **Persistent state on `SHARE`:** User configs, XDG directories, documents, books, `git` repositories, and optional portable tools live on persistent `SHARE` storage (`${AX_SHARE_ROOT:-/userdata}`, with desktop state under `${AX_DESKTOP_ROOT:-${AX_SHARE_ROOT}/desktop}`) rather than bloating the read-only OS image[cite: 6, 7].
* **Bootloader deferred:** Bootloader menu entries (`limine.conf` / `grub.cfg` / session branching) are held off until the desktop session and package profiles are validated on target hardware[cite: 7].

## ⚙️ Session & App Launchers

* **`overlays/common/etc/profile.d/ax-desktop-xdg.sh`:** Pure POSIX `sh` environment initializer (intentionally omitting `set -e` / `set -u` for safe interactive login sourcing) that checks whether `${AX_SHARE_ROOT}` is mounted and writable (`AX_SHARE_READY=1`) before creating `${AX_DESKTOP_ROOT}` subdirectories (`xdg-config`, `xdg-data`, `xdg-cache`, `xdg-state`, `apps`, `docs`, `books`, `src`)[cite: 5, 6].
* **Safe fallback when `SHARE` is unmounted or read-only:** Sets `AX_SHARE_READY=0` and falls back to `/run/ax-desktop-${UID}` or `/tmp/ax-desktop-${UID}` (`AX_ACTIVE_DESKTOP_ROOT`), exporting `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_CACHE_HOME`, and `XDG_STATE_HOME` so desktop apps never attempt writes against a read-only `EROFS` root filesystem[cite: 5, 6].
* **`scripts/launch-desktop.sh`:** Sources `/etc/profile.d/ax-desktop-xdg.sh` (or `${REPO_ROOT}/overlays/common/etc/profile.d/ax-desktop-xdg.sh`), warns to `stderr` if `SHARE` is not ready, selects `startlxqt` or `startxfce4` based on `AX_DESKTOP_SESSION` (defaulting to `lxqt`), verifies the session binary is in `PATH`, and `exec`s into the desktop session[cite: 4, 6].
* **`scripts/launch-falkon.sh` & `scripts/launch-mtpaint.sh`:** Load the desktop XDG environment cleanly, pass `--no-sandbox` in `QTWEBENGINE_CHROMIUM_FLAGS` when running `falkon` as root (`id -u -eq 0`), and keep `mtpaint.ini` under `${XDG_CONFIG_HOME}/mtpaint` (with per-user `/tmp` fallback when unmounted)[cite: 7, 8, 9].

## 📦 Package Tiers

### 1. Core Desktop (`profiles/desktop-core.mk`)
Always included when Desktop Mode is enabled:
* **🖥 Desktop Session:** Lightweight session (`LXQt` default or `XFCE`) + X11 and file/archive utilities[cite: 7]
* **🛠️ Developer & Shell Basics:** `git` and terminal tools[cite: 7]
* **🌐 Browser:** **Falkon** (Qt-native C++ browser with built-in ad blocking)[cite: 7]
* **📝 Office:** **AbiWord** (word processor) and **Gnumeric** (spreadsheet)[cite: 7]
* **📚 Reading:** **Foliate** (ebooks/comics) + a lightweight PDF viewer (`qpdfview`, `MuPDF`, or `Atril`)[cite: 7]

### 🎨 2D & Pixel Graphics Suite (Tier A Core)
`profiles/desktop-core.mk` includes a native C/C++ 2D and pixel-art suite (< 30 MB graphics footprint; < 35 MB total across graphics, binary inspection, and silicon diagnostics) modeled on classic Amiga graphics workflows[cite: 7]:

* **🖌️ mtPaint (`AX_PKG_MTPAINT`)**: Indexed palette editing, custom dithering matrices, and low-overhead pixel manipulation (wrapped via `/usr/local/bin/mtpaint` to persist config to `SHARE`)[cite: 7].
* **🕹️ GrafX2 (`AX_PKG_GRAFX2`)**: Pure C/SDL2 256-color pixel editor with Deluxe Paint-style custom brush grabbing, color cycling, and dual-view zoom[cite: 7].
* **🖍️ AzPainter (`AX_PKG_AZPAINTER`)**: Compact C/X11 16-bit full-color illustration and layer painting app (packaged in `buildroot/package/azpainter/`)[cite: 7].
* **🎞️ LibreSprite (`AX_PKG_LIBRESPRITE`)**: Native C++/SDL2 animated sprite-sheet editor with timeline scrubbing and onion-skinning (packaged in `buildroot/package/libresprite/`)[cite: 7].

### 🔍 Binary Inspection, Viewer & Diagnostics (Tier A Core)
* **🔢 GHex (`AX_PKG_GHEX`)**: Lightweight GTK3 hex and binary editor for inspecting ROM headers, save states, and raw binary files (packaged in `buildroot/package/ghex/`)[cite: 7].
* **🖼️ feh & scrot (`AX_PKG_FEH`, `AX_PKG_SCROT`)**: Instant X11 image viewer and command-line screenshot capture utility[cite: 7].
* **🧠 CPU-X (`AX_PKG_CPUX`)**: System profiling tool (CPU-Z equivalent) displaying CPU clocks, caches, motherboard, memory, and PCI hardware details in both GTK3 GUI and ncurses TUI (packaged in `buildroot/package/cpu-x/`)[cite: 7].
* **📊 nvtop (`AX_PKG_NVTOP`)**: Live terminal GPU monitor (GPU-Z equivalent) tracking NVIDIA and Intel iGPU clocks, VRAM, and utilization[cite: 7].

### 2. Optional Heavy Tier (`profiles/desktop-heavy.mk`)
Opt-in install selections or `SHARE`-staged tools/AppImages kept out of the core footprint unless explicitly requested:
* **🎨 Graphics & Painting:** **GIMP** and/or **Krita**[cite: 7]
* **🎬 Video Editing:** **Shotcut** (or **Kdenlive** for heavier multi-track work)[cite: 7]
* **⚙️ Batch Transcoding:** **HandBrake** (run strictly in desktop mode; avoid overlapping with real-time audio, capture, or emulation)[cite: 7]
* **🔐 Credential Vault:** **KeePassXC** (local-first `.kdbx` password manager stored on `SHARE`)[cite: 7]

## 🗂️ Repository Layout

```text
piccolo-ax-desktop/
├── LICENSE
├── README.md
├── topology.md
├── batocera-ax-external/
├── profiles/
│   ├── desktop-core.mk
│   └── desktop-heavy.mk
├── overlays/
│   └── common/
│       └── etc/
│           └── profile.d/
│               ├── README.md
│               └── ax-desktop-xdg.sh
├── scripts/
│   ├── gen-desktop-defconfig.sh
│   ├── launch-desktop.sh
│   ├── launch-falkon.sh
│   └── launch-mtpaint.sh
├── buildroot/
│   ├── Config.in
│   ├── README.md
│   └── package/
│       ├── azpainter/
│       ├── cpu-x/
│       ├── ghex/
│       └── libresprite/
└── docs/
    └── packages.md
```[cite: 5, 6, 7]
