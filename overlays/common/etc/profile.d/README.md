## Key Details in This Script

No set -e / set -u inside /etc/profile.d/*.sh: Because /etc/profile sources every file in /etc/profile.d/ into the user's interactive login shell, avoiding set -eu prevents an unset shell variable elsewhere from closing a login terminal.

Safe Unmounted Guard ([ -d "${AX_SHARE_ROOT}" ] && [ -w "${AX_SHARE_ROOT}" ]): It only creates the 7 subdirectories (xdg-config, xdg-data, xdg-cache, apps, docs, books, src) when SHARE is actually mounted and writable, protecting the read-only EROFS rootfs during early boot or unmounted states.

Pure POSIX sh: Passes sh -n cleanly and aligns 100% with launch-falkon.sh and stage-share-apps.sh
