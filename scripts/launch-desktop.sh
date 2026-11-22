#!/bin/sh
set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
REPO_ROOT="$(CDPATH= cd -- "${SCRIPT_DIR}/.." && pwd)"

# Load XDG and SHARE environment if present
if [ -r /etc/profile.d/ax-desktop-xdg.sh ]; then
    # shellcheck source=/dev/null
    . /etc/profile.d/ax-desktop-xdg.sh
elif [ -r "${REPO_ROOT}/overlays/common/etc/profile.d/ax-desktop-xdg.sh" ]; then
    # shellcheck source=/dev/null
    . "${REPO_ROOT}/overlays/common/etc/profile.d/ax-desktop-xdg.sh"
fi

if [ "${AX_SHARE_READY:-0}" -ne 1 ]; then
    printf 'Warning: AX_SHARE_ROOT (%s) is not mounted/writable; using volatile session fallback (%s).\n' \
        "${AX_SHARE_ROOT:-/userdata}" "${AX_ACTIVE_DESKTOP_ROOT:-/tmp}" >&2
fi

SESSION="$(printf '%s' "${AX_DESKTOP_SESSION:-lxqt}" | tr '[:upper:]' '[:lower:]')"

case "${SESSION}" in
    lxqt)
        SESSION_BIN="startlxqt"
        ;;
    xfce|xfce4)
        SESSION_BIN="startxfce4"
        ;;
    *)
        printf 'Error: Unsupported AX_DESKTOP_SESSION: %s (expected "lxqt" or "xfce")\n' "${SESSION}" >&2
        exit 1
        ;;
esac

if ! command -v "${SESSION_BIN}" >/dev/null 2>&1; then
    printf 'Error: %s is not installed or not in PATH.\n' "${SESSION_BIN}" >&2
    exit 127
fi

exec "${SESSION_BIN}" "$@"
