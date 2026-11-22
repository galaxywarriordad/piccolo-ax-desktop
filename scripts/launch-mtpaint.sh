#!/bin/sh
# piccolo-ax-desktop/scripts/launch-mtpaint.sh
# Installed as /usr/local/bin/mtpaint (0755) to enforce SHARE persistence on read-only EROFS.

set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
REPO_ROOT="$(CDPATH= cd -- "${SCRIPT_DIR}/.." && pwd)"

if [ -z "${XDG_CONFIG_HOME:-}" ]; then
    if [ -r /etc/profile.d/ax-desktop-xdg.sh ]; then
        # shellcheck source=/dev/null
        . /etc/profile.d/ax-desktop-xdg.sh
    elif [ -r "${REPO_ROOT}/overlays/common/etc/profile.d/ax-desktop-xdg.sh" ]; then
        # shellcheck source=/dev/null
        . "${REPO_ROOT}/overlays/common/etc/profile.d/ax-desktop-xdg.sh"
    fi
fi

UID_NUM="$(id -u 2>/dev/null || printf '1000')"
if [ -n "${XDG_CONFIG_HOME:-}" ]; then
    MTPAINT_CFG_DIR="${XDG_CONFIG_HOME}/mtpaint"
else
    SHARE_ROOT="${AX_SHARE_ROOT:-/userdata}"
    if [ -d "${SHARE_ROOT}" ] && [ -w "${SHARE_ROOT}" ]; then
        MTPAINT_CFG_DIR="${SHARE_ROOT}/desktop/xdg-config/mtpaint"
    else
        MTPAINT_CFG_DIR="/tmp/ax-desktop-mtpaint-${UID_NUM}"
    fi
fi

mkdir -p "${MTPAINT_CFG_DIR}"
exec /usr/bin/mtpaint --config="${MTPAINT_CFG_DIR}/mtpaint.ini" "$@"
