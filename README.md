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

## Silicon Preservation Society Ecosystem

### Core Repositories (8)

1. **Shared Silicon SDK (GitHub):** [`galaxywarriordad/ax-sdk`](https://github.com/galaxywarriordad/ax-sdk.git) — Shared dependency-free C++20 deterministic hardware runtime (`ax::sdk` / `v1_36_2`), dynamic Intel SMT / AMD CCX topology resolver, platform shims, and master architecture specs.
2. **Linux USB Console & A/V Appliance (GitHub):** [`galaxywarriordad/Piccolo-AX`](https://github.com/galaxywarriordad/Piccolo-AX.git) — Standalone `< 300 MB` `toram` EROFS Batocera / Buildroot `Linux 6.12-rt` `x86_64` appliance (`batocera-ax-external`) with direct ALSA `SCHED_FIFO` and `iHD` VA-API `dma_buf`.
3. **Linux Handheld Appliance (GitHub):** [`galaxywarriordad/Piccolo-2go`](https://github.com/galaxywarriordad/Piccolo-2go.git) — Deterministic Buildroot `aarch64` (`RK3326` `1:2:1`) retro handheld OS for **BATLEXP G350** and **R36S**.
4. **Optional Desktop Tier (GitHub):** [`galaxywarriordad/piccolo-ax-desktop`](https://github.com/galaxywarriordad/piccolo-ax-desktop.git) — On-demand C/C++ LXQt/X11 desktop workbench (`< 42 MB` budget).
5. **Commodore Amiga Engine (GitHub):** [`galaxywarriordad/Amiberry-AX`](https://github.com/galaxywarriordad/Amiberry-AX.git) — Deterministic Commodore Amiga 500 / 1200 / CD32 engine linked against `ax-sdk`.
6. **Bare-Metal Audio & A/V Engine (GitHub):** [`galaxywarriordad/FLAC_AX`](https://github.com/galaxywarriordad/FLAC_AX.git) — RAM-resident bit-perfect audio player, `ax_av_studio` MIDI/DSP synth workstation, and `ax_video_upscaler` stream pipeline.
7. **Retro Multi-System Engine (GitHub):** [`galaxywarriordad/Generation-X-AX`](https://github.com/galaxywarriordad/Generation-X-AX.git) — Deterministic multi-console `[AX]` integration across `Flycast` and `RMG`.
8. **Wii U Engine (GitHub):** [`galaxywarriordad/Cemu-Latte-AX`](https://github.com/galaxywarriordad/Cemu-Latte-AX.git) — Deterministic Nintendo Wii U (Latte GPU) AX engine powered by `ax::sdk`.

### Sister & Downstream Forks

- **Main Switch Engine Fork (Forgejo):** [`galaxywarriordad/Eden-Espresso-Wave-AX`](https://git.eden-emu.dev/galaxywarriordad/Eden-Espresso-Wave-AX.git) — Deterministic Nintendo Switch fork tuned for `ax::sdk` core topology, Vulkan telemetry, and low-latency audio, kept aligned with upstream for frictionless PR cherry-picks.
- **Upstream Ecosystem Hub (Forgejo):** [`eden-emu/eden`](https://git.eden-emu.dev/eden-emu/eden/) — Upstream Eden Switch emulator reference repository.
