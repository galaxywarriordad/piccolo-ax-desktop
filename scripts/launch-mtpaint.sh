#!/bin/sh
# piccolo-ax-desktop/scripts/launch-mtpaint.sh
# Installed as /usr/local/bin/mtpaint (0755) to enforce SHARE persistence on read-only EROFS.

set -eu

if [ -z "${XDG_CONFIG_HOME:-}" ] && [ -r /etc/profile.d/ax-desktop-xdg.sh ]; then
    # shellcheck source=/dev/null
    . /etc/profile.d/ax-desktop-xdg.sh
fi

SHARE_ROOT="${AX_SHARE_ROOT:-/userdata}"
MTPAINT_CFG_DIR="${XDG_CONFIG_HOME:-${SHARE_ROOT}/desktop/xdg-config}/mtpaint"
mkdir -p "${MTPAINT_CFG_DIR}"

exec /usr/bin/mtpaint --config="${MTPAINT_CFG_DIR}/mtpaint.ini" "$@"
