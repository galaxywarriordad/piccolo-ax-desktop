#!/bin/sh
# Initialize persistent SHARE-backed XDG directories for piccolo-ax-desktop.
# Designed to be sourced by /etc/profile and desktop launcher scripts.

AX_SHARE_ROOT="${AX_SHARE_ROOT:-/userdata}"
AX_DESKTOP_ROOT="${AX_DESKTOP_ROOT:-${AX_SHARE_ROOT}/desktop}"

export AX_SHARE_ROOT AX_DESKTOP_ROOT

if [ -d "${AX_SHARE_ROOT}" ] && [ -w "${AX_SHARE_ROOT}" ]; then
    XDG_CONFIG_HOME="${AX_DESKTOP_ROOT}/xdg-config"
    XDG_DATA_HOME="${AX_DESKTOP_ROOT}/xdg-data"
    XDG_CACHE_HOME="${AX_DESKTOP_ROOT}/xdg-cache"

    export XDG_CONFIG_HOME XDG_DATA_HOME XDG_CACHE_HOME

    mkdir -p \
        "${XDG_CONFIG_HOME}" \
        "${XDG_DATA_HOME}" \
        "${XDG_CACHE_HOME}" \
        "${AX_DESKTOP_ROOT}/apps" \
        "${AX_DESKTOP_ROOT}/docs" \
        "${AX_DESKTOP_ROOT}/books" \
        "${AX_DESKTOP_ROOT}/src"
fi

