#!/bin/sh
# Initialize XDG directories for piccolo-ax-desktop.
# Designed to be sourced by /etc/profile, profile.d, and desktop launchers.
# Intentionally omits 'set -e' and 'set -u' for safe interactive login sourcing.

: "${AX_SHARE_ROOT:=/userdata}"
: "${AX_DESKTOP_ROOT:=${AX_SHARE_ROOT}/desktop}"

_ax_is_writable_dir() {
    [ -n "$1" ] && [ -d "$1" ] && [ -w "$1" ]
}

_ax_is_mountpoint() {
    [ -n "$1" ] && [ -d "$1" ] && {
        if command -v mountpoint >/dev/null 2>&1; then
            mountpoint -q "$1" 2>/dev/null
        elif [ -r /proc/mounts ]; then
            awk -v mp="$1" '$2 == mp { found = 1; exit } END { exit !found }' /proc/mounts
        else
            return 0
        fi
    }
}

AX_SHARE_READY=0
if _ax_is_mountpoint "${AX_SHARE_ROOT}" && _ax_is_writable_dir "${AX_SHARE_ROOT}"; then
    AX_SHARE_READY=1
    AX_ACTIVE_DESKTOP_ROOT="${AX_DESKTOP_ROOT}"
    mkdir -p \
        "${AX_ACTIVE_DESKTOP_ROOT}/xdg-config" \
        "${AX_ACTIVE_DESKTOP_ROOT}/xdg-data" \
        "${AX_ACTIVE_DESKTOP_ROOT}/xdg-cache" \
        "${AX_ACTIVE_DESKTOP_ROOT}/xdg-state" \
        "${AX_ACTIVE_DESKTOP_ROOT}/apps" \
        "${AX_ACTIVE_DESKTOP_ROOT}/docs" \
        "${AX_ACTIVE_DESKTOP_ROOT}/books" \
        "${AX_ACTIVE_DESKTOP_ROOT}/src" 2>/dev/null || AX_SHARE_READY=0
fi

if [ "${AX_SHARE_READY}" -ne 1 ]; then
    AX_UID="${UID:-$(id -u 2>/dev/null || printf '1000')}"
    AX_FALLBACK_BASE="/run/ax-desktop-${AX_UID}"
    if ! mkdir -p "${AX_FALLBACK_BASE}" 2>/dev/null || ! _ax_is_writable_dir "${AX_FALLBACK_BASE}"; then
        AX_FALLBACK_BASE="/tmp/ax-desktop-${AX_UID}"
        mkdir -p "${AX_FALLBACK_BASE}" 2>/dev/null || true
    fi
    AX_ACTIVE_DESKTOP_ROOT="${AX_FALLBACK_BASE}"
    mkdir -p \
        "${AX_ACTIVE_DESKTOP_ROOT}/xdg-config" \
        "${AX_ACTIVE_DESKTOP_ROOT}/xdg-data" \
        "${AX_ACTIVE_DESKTOP_ROOT}/xdg-cache" \
        "${AX_ACTIVE_DESKTOP_ROOT}/xdg-state" 2>/dev/null || true
fi

XDG_CONFIG_HOME="${AX_ACTIVE_DESKTOP_ROOT}/xdg-config"
XDG_DATA_HOME="${AX_ACTIVE_DESKTOP_ROOT}/xdg-data"
XDG_CACHE_HOME="${AX_ACTIVE_DESKTOP_ROOT}/xdg-cache"
XDG_STATE_HOME="${AX_ACTIVE_DESKTOP_ROOT}/xdg-state"

export AX_SHARE_ROOT AX_DESKTOP_ROOT AX_ACTIVE_DESKTOP_ROOT AX_SHARE_READY
export XDG_CONFIG_HOME XDG_DATA_HOME XDG_CACHE_HOME XDG_STATE_HOME

unset -f _ax_is_writable_dir _ax_is_mountpoint 2>/dev/null || true
