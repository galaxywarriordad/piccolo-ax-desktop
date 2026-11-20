# 🗺️ Topology & Architecture Design

The topology of `piccolo-ax-desktop` enforces strict boundaries along **three dimensions**: compute/real-time isolation, storage (`EROFS` vs. `SHARE`), and package tiers (Core vs. Heavy).

---

## Part 1: Topology

### ⚡ 1. Compute & Session Topology

```text
+-------------------------------------------------------------------+
|                      Piccolo-AX Host Hardware                     |
|                                                                   |
|  +-----------------------------+  +-----------------------------+ |
|  |   APPLIANCE MODE (Default)  |  |  DESKTOP MODE (Secondary)   | |
|  |                             |  |                             | |
|  |  - Real-time / low-latency  |  |  - On-demand X11 session    | |
|  |  - Core isolation boundaries|  |  - LXQt (default) or XFCE   | |
|  |  - Audio / media / synth /  |  |  - Falkon, AbiWord,         | |
|  |    controller lanes         |  |    Gnumeric, Foliate, PDF   | |
|  |  - Zero desktop / browser / |  |  - Optional heavy tools     | |
|  |    transcoding daemons      |  |    (GIMP/Krita, Shotcut,    | |
|  |                             |  |    HandBrake)               | |
|  +--------------+--------------+  +--------------+--------------+ |
|                 |                                |                |
+-----------------|--------------------------------|----------------+
                  v                                v
+-------------------------------------------------------------------+
|                       Storage & State Layer                       |
|                                                                   |
|  +-----------------------------+  +-----------------------------+ |
|  |   Read-Only System / EROFS  |  |   Persistent SHARE          | |
|  |                             |  |   (/userdata/desktop/...)   | |
|  |  - Base appliance & core    |  |                             | |
|  |    binaries/scripts         |  |  - xdg-config, xdg-data,    | |
|  |  - Immutable system layer   |  |    xdg-cache                | |
|  |  - No mutable user state    |  |  - apps/ (AppImages/extras) | |
|  |                             |  |  - docs/, books/, src/      | |
|  +-----------------------------+  +-----------------------------+ |
+-------------------------------------------------------------------+
```

### 🗂️ 2. Repository & Delivery Topology

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
```

---

### 🛡️ 3. Boundary Invariants

- **No background bleed into Appliance Mode:** Default appliance boots must not start desktop shells, browser engines, or batch transcoders.
- **No user bloat in the read-only OS layer:** Profiles, caches, documents, ebooks/comics, local `git` repos, and optional AppImages live under `SHARE` (`${AX_SHARE_ROOT:-/userdata}/desktop`).
- **Bootloader stays decoupled until validated:** Boot menu entries (`grub.cfg` / session flags) are added only after session startup and `SHARE` persistence are proven on hardware[cite: 2].

---

# 🏗️ Part 2: Architecture Design

## 🎯 1. Architectural Goals & Non-Goals

### Goals
- Provide a clean, predictable general-purpose environment for browsing documentation, working with lightweight documents/spreadsheets, reading EPUB/CBZ/PDF files, and managing local `git` repositories.
- Preserve deterministic behavior and clean resource release when running the real-time **Piccolo-AX** appliance stack.
- Keep the core desktop lean by separating high-footprint creative and transcoding tools into an opt-in tier[cite: 1, 2].

### Non-Goals
- Turning **Piccolo-AX** into a general-purpose daily-driver workstation with chat/social apps, cloud sync daemons, or background software updaters.
- Modifying real-time scheduling, audio pipelines, or core-isolation logic inside `piccolo-ax-desktop`[cite: 1, 2].

---

## 📦 2. Tiered Package Architecture

### Tier A — Core Desktop (`profiles/desktop-core.mk`)
Always present when Desktop Mode is selected, covering everyday lightweight tasks without large media/painting suites:

- **Session & Windowing:** `LXQt` (default alongside Qt-native **Falkon**) or `XFCE`, running over X11.
- **Browser:** **Falkon** (C++/Qt browser with built-in ad blocking; supports both full desktop usage and a dedicated direct-launch path).
- **Office:** **AbiWord** (word processor) and **Gnumeric** (spreadsheet).
- **Reading:** **Foliate** (EPUB/CBZ/ebooks) paired with a lightweight PDF viewer (`qpdfview`, `MuPDF`, or `Atril`).
- **CLI & File Utilities:** `git`, terminal emulator, and archive tools[cite: 2].

### Tier B — Optional Heavy Tier (`profiles/desktop-heavy.mk`)
Opt-in tools with larger binary, dependency, or runtime footprints (`GIMP`, `Krita`, `Shotcut`, `HandBrake`):

- **Opt-In by Default:** Disabled in core profiles (`n`) so users who only want a lightweight desktop do not pay the size or build cost.
- **Flexible Delivery (`appimage-share` vs. `package`):** Supports staging self-contained AppImages or portable tools under `${AX_SHARE_ROOT}/desktop/apps` or enabling package selections when building a heavier variant. - **Session Discipline:** Intended to run inside Desktop Mode and be closed before returning to real-time appliance workloads[cite: 1, 2].  ---  ## 🔄 3. State, Environment & Launcher Flow  1. **Environment Initialization (`overlays/common/etc/profile.d/ax-desktop-xdg.sh`):** - Resolves `AX_SHARE_ROOT` (defaulting to `/userdata`) and sets `AX_DESKTOP_ROOT="${AX_SHARE_ROOT}/desktop"`.
   - Exports `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, and `XDG_CACHE_HOME` under `${AX_DESKTOP_ROOT}` so desktop configs, application state, and caches stay persistent and isolated from the read-only rootfs. - Creates standard subdirectories (`xdg-config`, `xdg-data`, `xdg-cache`, `apps`, `docs`, `books`, `src`) when `SHARE` is present.  2. **Desktop Session Launch (`scripts/launch-desktop.sh`):** - Sources `/etc/profile.d/ax-desktop-xdg.sh` (falling back to the repo overlay during local testing). - Selects the configured desktop session (`AX_DESKTOP_SESSION`: `lxqt` or `xfce`) and hands off cleanly via `exec`.  3. **Direct-to-Falkon Launch (`scripts/launch-falkon.sh`):** - Supports launching **Falkon** directly for a focused browser flow while ensuring XDG/`SHARE` paths are initialized and avoiding root-user sandbox pitfalls typical of Chromium/QtWebEngine runtimes.  4. **Optional `SHARE` Staging (`scripts/stage-share-apps.sh`):** - Prepares `${AX_DESKTOP_ROOT}/apps` and validates/stages optional AppImages or local user tools without altering read-only OS files.

---

## ⚖️ 4. Licensing & Governance (GPLv3)

- Repository-authored scripts, make/profile definitions, overlays, and documentation in `piccolo-ax-desktop` are licensed under **GNU General Public License v3.0 (GPLv3)**, aligning with **Piccolo-AX**.
- Upstream packages and optional tools (such as `LXQt`, `XFCE`, `Falkon`, `AbiWord`, `Gnumeric`, `Foliate`, PDF viewers, `GIMP`, `Krita`, `Shotcut`, and `HandBrake`) retain their own upstream licenses, documented in `docs/packages.md`[cite: 2].
