#!/bin/sh
set -eu

AX_SHARE_ROOT="${AX_SHARE_ROOT:-/userdata}"
AX_DESKTOP_ROOT="${AX_SHARE_ROOT}/desktop"
AX_APPS_DIR="${AX_DESKTOP_ROOT}/apps"

if [ ! -d "${AX_SHARE_ROOT}" ]; then
    printf 'Error: SHARE root (%s) is not mounted or does not exist.\n' "${AX_SHARE_ROOT}" >&2
    exit 1
fi

mkdir -p "${AX_APPS_DIR}"

# Copy any provided AppImages or portable binaries into SHARE/desktop/apps
for src_item in "$@"; do
    if [ ! -e "${src_item}" ]; then
        printf 'Warning: skipping missing source path: %s\n' "${src_item}" >&2
        continue
    fi
    base_name="$(basename -- "${src_item}")"
    cp -f "${src_item}" "${AX_APPS_DIR}/${base_name}"
    chmod 0755 "${AX_APPS_DIR}/${base_name}"
    printf 'Staged: %s -> %s/%s\n' "${src_item}" "${AX_APPS_DIR}" "${base_name}"
done

# Ensure all existing AppImages or binaries already placed in SHARE/desktop/apps are executable
for staged_item in "${AX_APPS_DIR}"/*.AppImage "${AX_APPS_DIR}"/*.appimage; do
    if [ -f "${staged_item}" ]; then
        chmod 0755 "${staged_item}"
    fi
done

printf 'SHARE apps directory ready: %s\n' "${AX_APPS_DIR}"
