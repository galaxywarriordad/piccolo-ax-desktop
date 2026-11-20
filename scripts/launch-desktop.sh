#!/bin/sh
set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
REPO_ROOT="$(CDPATH= cd -- "${SCRIPT_DIR}/.." && pwd)"

# Load SHARE XDG environment if present
if [ -r /etc/profile.d/ax-desktop-xdg.sh ]; then
    # shellcheck source=/dev/null
    . /etc/profile.d/ax-desktop-xdg.sh
elif [ -r "${REPO_ROOT}/overlays/common/etc/profile.d/ax-desktop-xdg.sh" ]; then
    # shellcheck source=/dev/null
    . "${REPO_ROOT}/overlays/common/etc/profile.d/ax-desktop-xdg.sh"
fi

SESSION="${AX_DESKTOP_SESSION:-lxqt}"

case "${SESSION}" in
    lxqt)
        SESSION_BIN="startlxqt"
        ;;
    xfce)
        SESSION_BIN="startxfce4"
        ;;
    *)
        printf 'Unsupported AX_DESKTOP_SESSION: %s (expected "lxqt" or "xfce")\n' "${SESSION}" >&2
        exit 1
        ;;
esac

if ! command -v "${SESSION_BIN}" >/dev/null 2>&1; then
    printf 'Error: %s is not installed or not in PATH.\n' "${SESSION_BIN}" >&2
    exit 127
fi

exec "${SESSION_BIN}" "$@"
