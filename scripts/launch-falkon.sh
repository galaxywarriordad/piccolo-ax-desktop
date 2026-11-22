#!/bin/sh
set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
REPO_ROOT="$(CDPATH= cd -- "${SCRIPT_DIR}/.." && pwd)"

: "${AX_SHARE_ROOT:=/userdata}"
export AX_SHARE_ROOT

if [ -r /etc/profile.d/ax-desktop-xdg.sh ]; then
    # shellcheck source=/dev/null
    . /etc/profile.d/ax-desktop-xdg.sh
elif [ -r "${REPO_ROOT}/overlays/common/etc/profile.d/ax-desktop-xdg.sh" ]; then
    # shellcheck source=/dev/null
    . "${REPO_ROOT}/overlays/common/etc/profile.d/ax-desktop-xdg.sh"
fi

if ! command -v falkon >/dev/null 2>&1; then
    printf 'Error: falkon is not installed or not in PATH.\n' >&2
    exit 127
fi

UID_NUM="$(id -u 2>/dev/null || printf '1000')"
if [ "${UID_NUM}" -eq 0 ]; then
    case " ${QTWEBENGINE_CHROMIUM_FLAGS:-} " in
        *" --no-sandbox "*) ;;
        *)
            QTWEBENGINE_CHROMIUM_FLAGS="${QTWEBENGINE_CHROMIUM_FLAGS:+${QTWEBENGINE_CHROMIUM_FLAGS} }--no-sandbox"
            export QTWEBENGINE_CHROMIUM_FLAGS
            ;;
    esac
fi

exec falkon "$@"
