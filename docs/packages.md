# Package Tiers, Delivery Strategy & Licensing

`piccolo-ax-desktop` divides user-space software into two tiers so the immutable `EROFS` rootfs stays lean while optional heavy creative, media, and security tools live cleanly on persistent `SHARE` storage (`${AX_SHARE_ROOT:-/userdata}/desktop`).

## Package Tier Matrix

| Tier | Profile File | Included Software | Default Delivery | Rationale |
| :--- | :--- | :--- | :--- | :--- |
| **Tier A (Core)** | `profiles/desktop-core.mk` | `LXQt` (default) or `XFCE` (X11), **Falkon**, **AbiWord**, **Gnumeric**, **Foliate**, lightweight PDF viewer (`qpdfview` / `MuPDF` / `Atril`), **mtPaint**, **GrafX2**, **AzPainter**, **LibreSprite**, **GHex**, **feh**, **scrot**, **CPU-X**, **nvtop**, `git`, terminal & archive tools | Rootfs (`package`) | Lightweight C/C++ utilities (< 35 MB total across graphics, binary inspection, and silicon diagnostics) essential for local browsing, document editing, reading, pixel/vector illustration, ROM/hex inspection, hardware monitoring, and repository maintenance without background daemons. |
| **Tier B (Heavy)** | `profiles/desktop-heavy.mk` | **GIMP**, **Krita**, **Shotcut** / **Kdenlive**, **HandBrake**, **KeePassXC** | `appimage-share` (or opt-in `package`) | Larger binaries, media toolchains, and credential vaults kept out of the core appliance image by default to preserve fast `toram` EROFS boot budgets and store vaults directly on `SHARE`. |

## Delivery Mode Trade-Offs (`appimage-share` vs. `package`)

* **`appimage-share` (Recommended for Tier B):**
  * **Pros:** Zero bloat added to `rootfs.erofs`; updates or removals happen directly in `${AX_SHARE_ROOT:-/userdata}/desktop/apps` without rebuilding the OS image; isolates heavy dependencies.
  * **Cons:** Requires `SHARE` to be mounted before launching; slightly slower cold launch than native rootfs binaries.
* **`package` (Default for Tier A, Opt-In for Tier B):**
  * **Pros:** Guaranteed availability even if `SHARE` is unmounted; tightly integrated with system libraries and Buildroot target flags.
  * **Cons:** Increases `EROFS` image size and `toram` RAM footprint; updating requires a full image rebuild.

## Licensing & Upstream Attribution

* **Repository License:** All Buildroot profiles, overlay scripts, launch wrappers, and documentation in `piccolo-ax-desktop` are licensed under **GNU General Public License v3.0 (`GPLv3`)** to match the `Piccolo-AX` appliance stack.
* **Upstream Components:** Packaged applications and staged AppImages retain their respective upstream open-source licenses (including `GPLv2`/`GPLv3` for `GIMP`, `Krita`, `Shotcut`, `Kdenlive`, `HandBrake`, `KeePassXC`, `AbiWord`, `Gnumeric`, `Foliate`, `Falkon`, `mtPaint`, `GrafX2`, `AzPainter`, `LibreSprite`, `GHex`, `CPU-X`, and `nvtop`; `MIT`/`BSD`-style permissive licenses for `feh` and `scrot`; and `LGPLv2.1+` for `LXQt` libraries). When distributing binary images or bundled `SHARE` archives, retain upstream license texts and source-offer compliance per `GPLv3` requirements.
