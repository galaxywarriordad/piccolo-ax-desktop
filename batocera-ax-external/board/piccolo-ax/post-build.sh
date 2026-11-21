if grep -q "^BR2_PACKAGE_PICCOLO_AX_DESKTOP=y" "${BR2_CONFIG}"; then
    DESKTOP_REPO="${BR2_EXTERNAL_PICCOLO_AX_PATH}/../piccolo-ax-desktop"

    # 1. Install /etc/profile.d/ax-desktop-xdg.sh into read-only rootfs
    install -D -m 0644 \
        "${DESKTOP_REPO}/overlays/common/etc/profile.d/ax-desktop-xdg.sh" \
        "${TARGET_DIR}/etc/profile.d/ax-desktop-xdg.sh"

    # 2. Install on-demand launcher & SHARE staging scripts
    install -d -m 0755 "${TARGET_DIR}/usr/local/bin"
    install -m 0755 "${DESKTOP_REPO}/scripts/launch-desktop.sh"    "${TARGET_DIR}/usr/local/bin/launch-desktop.sh"
    install -m 0755 "${DESKTOP_REPO}/scripts/launch-falkon.sh"     "${TARGET_DIR}/usr/local/bin/launch-falkon.sh"
    install -m 0755 "${DESKTOP_REPO}/scripts/stage-share-apps.sh"  "${TARGET_DIR}/usr/local/bin/stage-share-apps.sh"

    # 3. Install mtPaint SHARE-persistence wrapper ahead of /usr/bin/mtpaint
    install -m 0755 "${DESKTOP_REPO}/scripts/launch-mtpaint.sh"    "${TARGET_DIR}/usr/local/bin/mtpaint"
fi
