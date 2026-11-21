# 🖥️ piccolo-ax-desktop

Lightweight, local-first desktop mode for **Piccolo-AX**, designed to give users and developers a clean general-purpose escape hatch without compromising the deterministic, low-latency ethos of the core appliance.

## 🎯 Ethos & Boundaries

* **Local-first & low-bloat:** No chat or social apps, no cloud sync agents, and no background auto-updaters running idle in the tray.
* **Strict appliance isolation:** The default **Piccolo-AX** appliance boot remains dedicated to real-time/low-latency workloads (`Cores 0–4` vs. Core `5` / `0x20`, `2.00–2.67 ms` audio, media/capture, and controller/synth workstreams). Desktop sessions run as a separate, on-demand secondary mode with zero desktop or transcoding processes running in default appliance mode.
* **Persistent state on `SHARE`:** User configs, XDG directories, documents, books, `git` repositories, and optional portable tools live on persistent `SHARE` storage rather than bloating the read-only OS image.
* **Bootloader deferred:** Bootloader menu entries (`grub.cfg` / session branching) are intentionally held off until the desktop session and package profiles are validated on target hardware.

## 📦 Package Tiers

### 1. Core Desktop (`profiles/desktop-core.mk`)
Always included when Desktop Mode is enabled ("everything up to the large files"):
* **🖥 Desktop Session:** Lightweight session (`LXQt` or `XFCE`) + X11 and file/archive utilities
* **🛠️ Developer & Shell Basics:** `git` and terminal tools
* **🌐 Browser:** **Falkon** (Qt-native C++ browser with built-in ad blocking)
* **📝 Office:** **AbiWord** (word processor) and **Gnumeric** (spreadsheet)
* **📚 Reading:** **Foliate** (ebooks/comics) + a lightweight PDF viewer (`qpdfview`, `MuPDF`, or `Atril`)

### 🎨 2D & Pixel Graphics Suite (Tier A Core)
`profiles/desktop-core.mk` includes a native C/C++ 2D and pixel-art suite (< 30 MB total footprint) modeled on classic Amiga graphics workflows:

* **🖌️ mtPaint (`AX_PKG_MTPAINT`)**: Indexed palette editing, custom dithering matrices, and low-overhead pixel manipulation (wrapped via `/usr/local/bin/mtpaint` to persist config to `SHARE`).
* **🕹️ GrafX2 (`AX_PKG_GRAFX2`)**: Pure C/SDL2 256-color pixel editor with Deluxe Paint-style custom brush grabbing, color cycling, and dual-view zoom.
* **🖍️ AzPainter (`AX_PKG_AZPAINTER`)**: Compact C/X11 16-bit full-color illustration and layer painting app (packaged in `buildroot/package/azpainter/`).
* **🎞️ LibreSprite (`AX_PKG_LIBRESPRITE`)**: Native C++/SDL2 animated sprite-sheet editor with timeline scrubbing and onion-skinning (packaged in `buildroot/package/libresprite/`).

### 🔍 Binary Inspection, Viewer & Diagnostics (Tier A Core)
* **🔢 GHex (`AX_PKG_GHEX`)**: Lightweight GTK3 hex and binary editor for inspecting ROM headers, save states, and raw binary files (packaged in `buildroot/package/ghex/`).
* **🖼️ feh & scrot (`AX_PKG_FEH`, `AX_PKG_SCROT`)**: Instant X11 image viewer and command-line screenshot capture utility.
* **🧠 CPU-X (`AX_PKG_CPUX`)**: System profiling tool (CPU-Z equivalent) displaying CPU clocks, caches, motherboard, memory, and PCI hardware details in both GTK3 GUI and ncurses TUI (packaged in `buildroot/package/cpu-x/`).
* **📊 nvtop (`AX_PKG_NVTOP`)**: Live terminal GPU monitor (GPU-Z equivalent) tracking NVIDIA and Intel iGPU clocks, VRAM, and utilization.

### 2. Optional Heavy Tier (`profiles/desktop-heavy.mk`)
Opt-in install selections or `SHARE`-staged tools/AppImages kept out of the core footprint unless explicitly requested:
* **🎨 Graphics & Painting:** **GIMP** and/or **Krita**
* **🎬 Video Editing:** **Shotcut** (or **Kdenlive** for heavier multi-track work)
* **⚙️ Batch Transcoding:** **HandBrake** (run strictly in desktop mode; avoid overlapping with real-time audio, capture, or emulation)
* **🔐 Credential Vault:** **KeePassXC** (local-first `.kdbx` password manager stored on `SHARE`)

## 🗂️ Repository Layout

```text
piccolo-ax-desktop/
├── LICENSE
├── README.md
├── topology.md
├── profiles/
│   ├── desktop-core.mk
│   └── desktop-heavy.mk
├── overlays/
│   └── common/
│       └── etc/
│           └── profile.d/
│               └── ax-desktop-xdg.sh
├── scripts/
│   ├── launch-desktop.sh
│   ├── launch-falkon.sh
│   └── stage-share-apps.sh
├── buildroot/
│   └── README.md
└── docs/
    └── packages.md
```
