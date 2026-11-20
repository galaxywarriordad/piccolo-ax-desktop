#!/bin/sh
# piccolo-ax-desktop/scripts/launch-mtpaint.sh
# Installed as /usr/local/bin/mtpaint (0755) to enforce SHARE persistence on read-only EROFS.

set -eu

SHARE_ROOT="${AX_SHARE_ROOT:-/userdata}"
MTPAINT_CFG_DIR="${SHARE_ROOT}/desktop/config/mtpaint"
mkdir -p "${MTPAINT_CFG_DIR}"

exec /usr/bin/mtpaint --config="${MTPAINT_CFG_DIR}/mtpaint.ini" "$@"
