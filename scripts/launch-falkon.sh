#!/bin/sh
set -eu

AX_SHARE_ROOT="${AX_SHARE_ROOT:-/userdata}"
export AX_SHARE_ROOT

if [ -r /etc/profile.d/ax-desktop-xdg.sh ]; then
    # shellcheck source=/dev/null
    . /etc/profile.d/ax-desktop-xdg.sh
else
    SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
    REPO_XDG="${SCRIPT_DIR}/../overlays/common/etc/profile.d/ax-desktop-xdg.sh"
    if [ -r "${REPO_XDG}" ]; then
        # shellcheck source=/dev/null
        . "${REPO_XDG}"
    fi
fi

if ! command -v falkon >/dev/null 2>&1; then
    printf 'Error: falkon is not installed or not in PATH.\n' >&2
    exit 127
fi

if [ "$(id -u)" -eq 0 ]; then
    case " ${QTWEBENGINE_CHROMIUM_FLAGS:-} " in
        *" --no-sandbox "*) ;;
        *)
            QTWEBENGINE_CHROMIUM_FLAGS="${QTWEBENGINE_CHROMIUM_FLAGS:+${QTWEBENGINE_CHROMIUM_FLAGS} }--no-sandbox"
            export QTWEBENGINE_CHROMIUM_FLAGS
            ;;
    esac
fi

exec falkon "$@"
