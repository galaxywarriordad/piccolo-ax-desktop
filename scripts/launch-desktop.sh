#!/usr/bin/env sh
set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
REPO_ROOT="$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)"

# Load SHARE XDG environment if present
if [ -r /etc/profile.d/ax-desktop-xdg.sh ]; then
    # shellcheck disable=SC1091
    . /etc/profile.d/ax-desktop-xdg.sh
elif [ -r "$REPO_ROOT/overlays/common/etc/profile.d/ax-desktop-xdg.sh" ]; then
    # shellcheck disable=SC1091
    . "$REPO_ROOT/overlays/common/etc/profile.d/ax-desktop-xdg.sh"
fi

SESSION="${AX_DESKTOP_SESSION:-lxqt}"

case "$SESSION" in
    lxqt)
        exec startlxqt
        ;;
    xfce|xfce4)
        exec startxfce4
        ;;
    *)
        echo "Unsupported AX_DESKTOP_SESSION: $SESSION (expected 'lxqt' or 'xfce')" >&2
        exit 1
        ;;
esac
