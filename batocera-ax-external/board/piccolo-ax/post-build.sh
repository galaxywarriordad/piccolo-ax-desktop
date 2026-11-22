if grep -q "^BR2_PACKAGE_PICCOLO_AX_DESKTOP=y" "${BR2_CONFIG}"; then
    DESKTOP_REPO="${BR2_EXTERNAL_PICCOLO_AX_PATH}/../piccolo-ax-desktop"

    # 1. Install read-only rootfs /etc overlays (XDG SHARE setup, mpv, & Espresso UI palette)
    install -D -m 0644 \
        "${DESKTOP_REPO}/overlays/common/etc/profile.d/ax-desktop-xdg.sh" \
        "${TARGET_DIR}/etc/profile.d/ax-desktop-xdg.sh"
    install -D -m 0644 \
        "${DESKTOP_REPO}/overlays/common/etc/mpv/mpv.conf" \
        "${TARGET_DIR}/etc/mpv/mpv.conf"
    install -D -m 0644 \
        "${DESKTOP_REPO}/overlays/common/etc/xdg/lxqt/lxqt.conf" \
        "${TARGET_DIR}/etc/xdg/lxqt/lxqt.conf"
    install -D -m 0644 \
        "${DESKTOP_REPO}/overlays/common/etc/xdg/qterminal.org/qterminal.ini" \
        "${TARGET_DIR}/etc/xdg/qterminal.org/qterminal.ini"

    # 2. Stage dArkOS-inspired Coffee GRUB2 theme assets (grub.cfg activation deferred)
    install -d -m 0755 "${TARGET_DIR}/usr/share/grub/themes/piccolo-ax/icons"
    install -m 0644 \
        "${DESKTOP_REPO}/overlays/common/usr/share/grub/themes/piccolo-ax/theme.txt" \
        "${TARGET_DIR}/usr/share/grub/themes/piccolo-ax/theme.txt"
    install -m 0644 \
        "${DESKTOP_REPO}/overlays/common/usr/share/grub/themes/piccolo-ax/icons/"*.png \
        "${TARGET_DIR}/usr/share/grub/themes/piccolo-ax/icons/"

    # 3. Install on-demand launcher & SHARE staging scripts
    install -d -m 0755 "${TARGET_DIR}/usr/local/bin"
    install -m 0755 "${DESKTOP_REPO}/scripts/launch-desktop.sh"   "${TARGET_DIR}/usr/local/bin/launch-desktop.sh"
    install -m 0755 "${DESKTOP_REPO}/scripts/launch-falkon.sh"    "${TARGET_DIR}/usr/local/bin/launch-falkon.sh"
    install -m 0755 "${DESKTOP_REPO}/scripts/launch-yt.sh"        "${TARGET_DIR}/usr/local/bin/launch-yt.sh"
    install -m 0755 "${DESKTOP_REPO}/scripts/stage-share-apps.sh" "${TARGET_DIR}/usr/local/bin/stage-share-apps.sh"

    # 4. Install mtPaint SHARE-persistence wrapper ahead of /usr/bin/mtpaint
    install -m 0755 "${DESKTOP_REPO}/scripts/launch-mtpaint.sh"   "${TARGET_DIR}/usr/local/bin/mtpaint"
fi
