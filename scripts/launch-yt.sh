#!/bin/sh
# piccolo-ax-desktop/scripts/launch-yt.sh
# Fullscreen YouTube / stream launcher using mpv + yt-dlp with SHARE/XDG persistence.

set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
REPO_ROOT="$(CDPATH= cd -- "${SCRIPT_DIR}/.." && pwd)"

if [ -r /etc/profile.d/ax-desktop-xdg.sh ]; then
    # shellcheck source=/dev/null
    . /etc/profile.d/ax-desktop-xdg.sh
elif [ -r "${REPO_ROOT}/overlays/common/etc/profile.d/ax-desktop-xdg.sh" ]; then
    # shellcheck source=/dev/null
    . "${REPO_ROOT}/overlays/common/etc/profile.d/ax-desktop-xdg.sh"
fi

if [ "$#" -lt 1 ]; then
    printf 'Usage: %s <url-or-search-query> [mpv-options...]\n' "$(basename -- "$0")" >&2
    exit 2
fi

if ! command -v mpv >/dev/null 2>&1; then
    printf 'Error: mpv is not installed or not in PATH.\n' >&2
    exit 127
fi

UID_NUM="$(id -u 2>/dev/null || printf '1000')"
MPV_CFG_DIR="${XDG_CONFIG_HOME:-/tmp/ax-desktop-${UID_NUM}/xdg-config}/mpv"
MPV_CACHE_DIR="${XDG_CACHE_HOME:-/tmp/ax-desktop-${UID_NUM}/xdg-cache}/mpv"
mkdir -p "${MPV_CFG_DIR}" "${MPV_CACHE_DIR}"

SYS_CONF=""
if [ -r /etc/mpv/mpv.conf ]; then
    SYS_CONF="/etc/mpv/mpv.conf"
elif [ -r "${REPO_ROOT}/overlays/common/etc/mpv/mpv.conf" ]; then
    SYS_CONF="${REPO_ROOT}/overlays/common/etc/mpv/mpv.conf"
fi

if [ -n "${SYS_CONF}" ] && [ ! -e "${MPV_CFG_DIR}/mpv.conf" ]; then
    cp "${SYS_CONF}" "${MPV_CFG_DIR}/mpv.conf" 2>/dev/null || true
fi

TARGET="$1"
shift

case "${TARGET}" in
    http://*|https://*|/*|./*|../*|ytdl://*)
        ;;
    *)
        TARGET="ytdl://ytsearch1:${TARGET}"
        ;;
esac

exec mpv \
    --config-dir="${MPV_CFG_DIR}" \
    --fs \
    "${TARGET}" \
    "$@"
