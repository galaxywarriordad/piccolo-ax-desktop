# Buildroot & External Layer Integration (`BR2_EXTERNAL`)

`piccolo-ax-desktop` is designed as a decoupled add-on layer for **Piccolo-AX** so standard real-time appliance builds remain completely untouched unless Desktop Mode is explicitly enabled.

## Directory Consumption

External Buildroot trees (`batocera-ax-external` / `Piccolo-AX`) consume this repository as follows:

1. **Package Profiles & Fragment Generation (`profiles/*.mk` + `scripts/gen-desktop-defconfig.sh`):**
   - Run `scripts/gen-desktop-defconfig.sh <output_fragment>` to translate `profiles/desktop-core.mk` (and any environment overrides such as `AX_DESKTOP_SESSION=xfce`) into a Buildroot Kconfig fragment pulling in LXQt (or XFCE), X11, Falkon, AbiWord, Gnumeric, Foliate, a lightweight PDF viewer, CLI utilities, and the core 2D/pixel graphics suite (`mtPaint`, `GrafX2`, `AzPainter`, `LibreSprite`).
   - Merge the emitted fragment onto `piccolo_x86_64_defconfig` via Buildroot's `support/kconfig/merge_config.sh -m` followed by `make olddefconfig`.
   - Optionally enable `AX_DESKTOP_HEAVY_*` flags (see `profiles/desktop-heavy.mk`) when staging GIMP, Krita, Shotcut, or HandBrake (`package` or `appimage-share` mode).
2. **Custom Buildroot Packages (`buildroot/package/`):**
   - Source `buildroot/Config.in` (or `buildroot/package/azpainter/Config.in` and `buildroot/package/libresprite/Config.in`) in desktop-enabled `BR2_EXTERNAL` trees to expose `BR2_PACKAGE_AZPAINTER` and `BR2_PACKAGE_LIBRESPRITE` alongside upstream `BR2_PACKAGE_MTPAINT` and `BR2_PACKAGE_GRAFX2`.
3. **Rootfs Overlay (`overlays/common/`):**
   - Register `overlays/common` in `BR2_ROOTFS_OVERLAY` for desktop-enabled targets. This installs `/etc/profile.d/ax-desktop-xdg.sh` into the read-only EROFS rootfs.
4. **Launcher & Staging Scripts (`scripts/`):**
   - Install `scripts/launch-desktop.sh`, `scripts/launch-falkon.sh`, and `scripts/stage-share-apps.sh` into `/usr/local/bin/` (or `/usr/bin/`) with `0755` permissions during target rootfs assembly.
   - Install `scripts/launch-mtpaint.sh` as `/usr/local/bin/mtpaint` (`0755`) so `mtPaint` persists its configuration to `${AX_SHARE_ROOT:-/userdata}/desktop/xdg-config/mtpaint/mtpaint.ini` rather than attempting to write `~/.mtpaint` on the read-only rootfs.

## Boundary Rules for Build Integration

- **Immutable EROFS Guarantee:** Never write user configs, caches, or AppImages into `/root`, `/home`, or `/etc` during `post-build.sh`. All mutable state must resolve to `${AX_SHARE_ROOT:-/userdata}/desktop` at runtime.
- **Appliance Mode Isolation:** Do not register desktop display managers (SDDM, LightDM) or X11 sessions as default init services (`gen-desktop-defconfig.sh` explicitly keeps `BR2_PACKAGE_SDDM` and `BR2_PACKAGE_LIGHTDM` unset). Desktop Mode is launched strictly on demand via `launch-desktop.sh`.
- **Bootloader Deferral:** Do not add `grub.cfg` menu entries or kernel boot flags (`ax.mode=desktop`) in Buildroot `post-image.sh` until X11 session startup, `SHARE` persistence, and Appliance Mode process isolation are verified on target hardware.
