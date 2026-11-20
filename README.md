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
* **Desktop Session:** Lightweight session (`LXQt` or `XFCE`) + X11 and file/archive utilities
* **Developer & Shell Basics:** `git` and terminal tools
* **Browser:** **Falkon** (Qt-native C++ browser with built-in ad blocking)
* **Office:** **AbiWord** (word processor) and **Gnumeric** (spreadsheet)
* **Reading:** **Foliate** (ebooks/comics) + a lightweight PDF viewer (`qpdfview`, `MuPDF`, or `Atril`)

### 2. Optional Heavy Tier (`profiles/desktop-heavy.mk`)
Opt-in install selections or `SHARE`-staged tools/AppImages kept out of the core footprint unless explicitly requested:
* **Graphics & Painting:** **GIMP** and/or **Krita**
* **Video Editing:** **Shotcut** (or **Kdenlive** for heavier multi-track work)
* **Batch Transcoding:** **HandBrake** (run strictly in desktop mode; avoid overlapping with real-time audio, capture, or emulation)

## 🗂️ Repository Layout

```text
piccolo-ax-desktop/
├── LICENSE
├── README.md
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
    ├── topology.md
    └── packages.md
