# 🗺️ piccolo-ax-desktop Topology & Architecture Design

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

# 📦 Packages & Tiers (`docs/packages.md`)

`piccolo-ax-desktop` splits software into a lean **Core Desktop** tier and an opt-in **Heavy Tier** so everyday tasks stay fast while large creative/transcoding tools do not inflate default builds. See [topology.md](../topology.md) for compute, storage (`EROFS` vs. `SHARE`), and session boundaries.

## Tier A — Core Desktop (`profiles/desktop-core.mk`)

* **Session:** `LXQt` (preferred alongside Qt-native **Falkon**) or `XFCE` over X11.
* **Browser:** **Falkon** (C++/Qt, built-in ad blocking, supports full desktop or `scripts/launch-falkon.sh`).
* **Office:** **AbiWord** (word processor) and **Gnumeric** (spreadsheet).
* **Readers:** **Foliate** (EPUB/CBZ/ebooks) and a lightweight PDF viewer (`qpdfview`, `MuPDF`, or `Atril`).
* **Utilities:** `git`, terminal emulator, and archive tools.

## Tier B — Optional Heavy Tier (`profiles/desktop-heavy.mk`)

* **Graphics & Painting:** **GIMP**, **Krita**.
* **Video & Transcoding:** **Shotcut** (or **Kdenlive**), **HandBrake**.
* **Delivery:** Prefer staging AppImages/portable tools under `${AX_SHARE_ROOT:-/userdata}/desktop/apps` via `scripts/stage-share-apps.sh`, and run only inside Desktop Mode (never overlapping with real-time appliance workloads).

## Upstream Licenses

Upstream applications and toolkits retain their respective upstream licenses; repository-authored scripts, profiles, overlays, and docs in `piccolo-ax-desktop` are licensed under **GPLv3**.

---

## ⚖️ 4. Licensing & Governance (GPLv3)

- Repository-authored scripts, make/profile definitions, overlays, and documentation in `piccolo-ax-desktop` are licensed under **GNU General Public License v3.0 (GPLv3)**, aligning with **Piccolo-AX**.
- Upstream packages and optional tools (such as `LXQt`, `XFCE`, `Falkon`, `AbiWord`, `Gnumeric`, `Foliate`, PDF viewers, `GIMP`, `Krita`, `Shotcut`, and `HandBrake`) retain their own upstream licenses, documented in `docs/packages.md`[cite: 2].
