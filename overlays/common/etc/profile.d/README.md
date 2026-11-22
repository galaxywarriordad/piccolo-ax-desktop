# `overlays/common/etc/profile.d/`

## Key Details in This Script

* **No `set -e` / `set -u` in `ax-desktop-xdg.sh`:** Because `/etc/profile` sources every file in `/etc/profile.d/` into interactive login shells, avoiding `set -eu` prevents an unset variable or non-zero test in a sub-script from closing a login shell[cite: 5].
* **Safe Mountpoint & Writability Guard:** `ax-desktop-xdg.sh` verifies that `${AX_SHARE_ROOT}` (default `/userdata`) is a mounted and writable directory (`AX_SHARE_READY=1`) before creating `${AX_DESKTOP_ROOT}` (default `${AX_SHARE_ROOT}/desktop`) and its persistent directories (`xdg-config`, `xdg-data`, `xdg-cache`, `xdg-state`, `apps`, `docs`, `books`, `src`). This prevents accidentally creating `/userdata/desktop` on a read-only `EROFS` root when `/userdata` is not mounted.
* **Automatic Non-Blocking Fallback:** When `${AX_SHARE_ROOT}` is not mounted or not writable, `ax-desktop-xdg.sh` falls back to a per-user directory under `/run/ax-desktop-${UID}` or `/tmp/ax-desktop-${UID}` and exports all four `XDG_*_HOME` variables (`XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_CACHE_HOME`, `XDG_STATE_HOME`) so desktop tools never attempt writes against a read-only root filesystem[cite: 5, 6].
* **Pure POSIX `sh`:** Uses only POSIX shell constructs and helper cleanup (`unset -f`) so it passes `sh -n` and works cleanly across `launch-desktop.sh`, `launch-falkon.sh`, `launch-mtpaint.sh`, and `stage-share-apps.sh`[cite: 5].
