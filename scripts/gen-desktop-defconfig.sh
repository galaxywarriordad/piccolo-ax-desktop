#!/bin/sh
# Generates a Buildroot defconfig fragment from piccolo-ax-desktop/profiles/*.mk
# Usage: ./scripts/gen-desktop-defconfig.sh [output_fragment_path]

set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
REPO_ROOT="$(CDPATH= cd -- "${SCRIPT_DIR}/.." && pwd)"
OUT_FILE="${1:-${REPO_ROOT}/buildroot/piccolo-ax-desktop.fragment}"

read_mk_var() {
    var_name="$1"
    mk_file="$2"
    eval "current_val=\${${var_name}:-}"
    if [ -n "${current_val}" ]; then
        printf '%s\n' "${current_val}"
        return
    fi
    if [ -r "${mk_file}" ]; then
        awk -F'[?]?=' -v key="${var_name}" '
            $1 ~ "^[[:space:]]*" key "[[:space:]]*$" {
                gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2)
                print $2
                exit
            }
        ' "${mk_file}"
    fi
}

CORE_MK="${REPO_ROOT}/profiles/desktop-core.mk"
HEAVY_MK="${REPO_ROOT}/profiles/desktop-heavy.mk"

AX_DESKTOP_CORE_ENABLED="$(read_mk_var AX_DESKTOP_CORE_ENABLED "${CORE_MK}")"
if [ "${AX_DESKTOP_CORE_ENABLED}" != "y" ]; then
    printf 'AX_DESKTOP_CORE_ENABLED is not "y"; skipping fragment generation.\n' >&2
    exit 0
fi

# Tier A (Core) settings
AX_DESKTOP_SESSION="$(read_mk_var AX_DESKTOP_SESSION "${CORE_MK}")"
AX_PKG_PCMANFM_QT="$(read_mk_var AX_PKG_PCMANFM_QT "${CORE_MK}")"
AX_PKG_WORKER="$(read_mk_var AX_PKG_WORKER "${CORE_MK}")"
AX_PKG_LXQT_ARCHIVER="$(read_mk_var AX_PKG_LXQT_ARCHIVER "${CORE_MK}")"

AX_PKG_FALKON="$(read_mk_var AX_PKG_FALKON "${CORE_MK}")"
AX_PKG_ABIWORD="$(read_mk_var AX_PKG_ABIWORD "${CORE_MK}")"
AX_PKG_GNUMERIC="$(read_mk_var AX_PKG_GNUMERIC "${CORE_MK}")"
AX_PKG_FOLIATE="$(read_mk_var AX_PKG_FOLIATE "${CORE_MK}")"
AX_PKG_MPV="$(read_mk_var AX_PKG_MPV "${CORE_MK}")"
AX_PKG_YTDLP="$(read_mk_var AX_PKG_YTDLP "${CORE_MK}")"

AX_PKG_MTPAINT="$(read_mk_var AX_PKG_MTPAINT "${CORE_MK}")"
AX_PKG_GRAFX2="$(read_mk_var AX_PKG_GRAFX2 "${CORE_MK}")"
AX_PKG_AZPAINTER="$(read_mk_var AX_PKG_AZPAINTER "${CORE_MK}")"
AX_PKG_LIBRESPRITE="$(read_mk_var AX_PKG_LIBRESPRITE "${CORE_MK}")"

AX_PKG_MILKYTRACKER="$(read_mk_var AX_PKG_MILKYTRACKER "${CORE_MK}")"
AX_PKG_MHWAVEEDIT="$(read_mk_var AX_PKG_MHWAVEEDIT "${CORE_MK}")"
AX_PKG_QASMIXER="$(read_mk_var AX_PKG_QASMIXER "${CORE_MK}")"

AX_PKG_GHEX="$(read_mk_var AX_PKG_GHEX "${CORE_MK}")"
AX_PKG_FEH="$(read_mk_var AX_PKG_FEH "${CORE_MK}")"
AX_PKG_SCROT="$(read_mk_var AX_PKG_SCROT "${CORE_MK}")"
AX_PKG_QALCULATE_QT="$(read_mk_var AX_PKG_QALCULATE_QT "${CORE_MK}")"
AX_PKG_CPUX="$(read_mk_var AX_PKG_CPUX "${CORE_MK}")"
AX_PKG_NVTOP="$(read_mk_var AX_PKG_NVTOP "${CORE_MK}")"
AX_PKG_HTOP="$(read_mk_var AX_PKG_HTOP "${CORE_MK}")"

AX_DESKTOP_PDF_VIEWER="$(read_mk_var AX_DESKTOP_PDF_VIEWER "${CORE_MK}")"
AX_PKG_GIT="$(read_mk_var AX_PKG_GIT "${CORE_MK}")"
AX_PKG_TERMINAL="$(read_mk_var AX_PKG_TERMINAL "${CORE_MK}")"
AX_PKG_ARCHIVE_TOOLS="$(read_mk_var AX_PKG_ARCHIVE_TOOLS "${CORE_MK}")"
AX_PKG_LHASA="$(read_mk_var AX_PKG_LHASA "${CORE_MK}")"
AX_PKG_DEV_TEXT_TOOLS="$(read_mk_var AX_PKG_DEV_TEXT_TOOLS "${CORE_MK}")"
AX_PKG_X11_HELPERS="$(read_mk_var AX_PKG_X11_HELPERS "${CORE_MK}")"
AX_PKG_TEXT_EDITOR="$(read_mk_var AX_PKG_TEXT_EDITOR "${CORE_MK}")"

# Tier B (Optional Heavy) settings — read heavy.mk with core.mk fallback
AX_DESKTOP_HEAVY_ENABLED="$(read_mk_var AX_DESKTOP_HEAVY_ENABLED "${HEAVY_MK}")"
AX_DESKTOP_HEAVY_DELIVERY="$(read_mk_var AX_DESKTOP_HEAVY_DELIVERY "${HEAVY_MK}")"
AX_DESKTOP_HEAVY_GIMP="$(read_mk_var AX_DESKTOP_HEAVY_GIMP "${HEAVY_MK}")"
AX_DESKTOP_HEAVY_KRITA="$(read_mk_var AX_DESKTOP_HEAVY_KRITA "${HEAVY_MK}")"
AX_DESKTOP_HEAVY_SHOTCUT="$(read_mk_var AX_DESKTOP_HEAVY_SHOTCUT "${HEAVY_MK}")"
AX_DESKTOP_HEAVY_KDENLIVE="$(read_mk_var AX_DESKTOP_HEAVY_KDENLIVE "${HEAVY_MK}")"
AX_DESKTOP_HEAVY_HANDBRAKE="$(read_mk_var AX_DESKTOP_HEAVY_HANDBRAKE "${HEAVY_MK}")"
AX_DESKTOP_HEAVY_KEEPASSXC="$(read_mk_var AX_DESKTOP_HEAVY_KEEPASSXC "${HEAVY_MK}")"

heavy_pkg_active() {
    [ "${AX_DESKTOP_HEAVY_ENABLED}" = "y" ] && \
    [ "${AX_DESKTOP_HEAVY_DELIVERY}" = "package" ] && \
    [ "$1" = "y" ]
}

mkdir -p "$(dirname -- "${OUT_FILE}")"

{
    printf '# Auto-generated from piccolo-ax-desktop/profiles/*.mk\n'
    printf 'BR2_PACKAGE_PICCOLO_AX_DESKTOP=y\n'
    printf 'BR2_PACKAGE_XORG7=y\n\n'

    # Desktop Session (Appliance Mode Isolation: no SDDM/LightDM init service)
    printf '# Desktop Session (%s)\n' "${AX_DESKTOP_SESSION}"
    case "${AX_DESKTOP_SESSION}" in
        lxqt)
            printf 'BR2_PACKAGE_LXQT_SESSION=y\n'
            printf 'BR2_PACKAGE_OPENBOX=y\n'
            ;;
        xfce)
            printf 'BR2_PACKAGE_XFCE4_SESSION=y\n'
            printf 'BR2_PACKAGE_XFWM4=y\n'
            ;;
        *)
            printf 'Unsupported AX_DESKTOP_SESSION: %s\n' "${AX_DESKTOP_SESSION}" >&2
            exit 1
            ;;
    esac
    [ "${AX_PKG_PCMANFM_QT}" = "y" ]    && printf 'BR2_PACKAGE_PCMANFM_QT=y\n'
    [ "${AX_PKG_WORKER}" = "y" ]        && printf 'BR2_PACKAGE_WORKER=y\n'
    [ "${AX_PKG_LXQT_ARCHIVER}" = "y" ] && printf 'BR2_PACKAGE_LXQT_ARCHIVER=y\n'
    printf '# BR2_PACKAGE_SDDM is not set\n'
    printf '# BR2_PACKAGE_LIGHTDM is not set\n\n'

    # Core Browser, Media, Office & Readers
    printf '# Core Applications\n'
    [ "${AX_PKG_FALKON}" = "y" ]    && printf 'BR2_PACKAGE_FALKON=y\n'
    [ "${AX_PKG_ABIWORD}" = "y" ]   && printf 'BR2_PACKAGE_ABIWORD=y\n'
    [ "${AX_PKG_GNUMERIC}" = "y" ]  && printf 'BR2_PACKAGE_GNUMERIC=y\n'
    [ "${AX_PKG_FOLIATE}" = "y" ]   && printf 'BR2_PACKAGE_FOLIATE=y\n'
    [ "${AX_PKG_MPV}" = "y" ]       && printf 'BR2_PACKAGE_MPV=y\n'
    [ "${AX_PKG_YTDLP}" = "y" ]     && printf 'BR2_PACKAGE_YTDLP=y\n'

    case "${AX_DESKTOP_PDF_VIEWER}" in
        qpdfview) printf 'BR2_PACKAGE_QPDFVIEW=y\n' ;;
        mupdf)    printf 'BR2_PACKAGE_MUPDF=y\n' ;;
        atril)    printf 'BR2_PACKAGE_ATRIL=y\n' ;;
        *)
            printf 'Unsupported AX_DESKTOP_PDF_VIEWER: %s\n' "${AX_DESKTOP_PDF_VIEWER}" >&2
            exit 1
            ;;
    esac
    printf '\n'

    # Core 2D & Pixel Graphics Suite (< 30 MB total)
    printf '# Core 2D & Pixel Graphics Suite\n'
    [ "${AX_PKG_MTPAINT}" = "y" ]     && printf 'BR2_PACKAGE_MTPAINT=y\n'
    [ "${AX_PKG_GRAFX2}" = "y" ]      && printf 'BR2_PACKAGE_GRAFX2=y\n'
    [ "${AX_PKG_AZPAINTER}" = "y" ]   && printf 'BR2_PACKAGE_AZPAINTER=y\n'
    [ "${AX_PKG_LIBRESPRITE}" = "y" ] && printf 'BR2_PACKAGE_LIBRESPRITE=y\n'
    printf '\n'

    # Classic Tracker & Audio Utilities
    printf '# Classic Tracker & Audio Tools\n'
    [ "${AX_PKG_MILKYTRACKER}" = "y" ] && printf 'BR2_PACKAGE_MILKYTRACKER=y\n'
    [ "${AX_PKG_MHWAVEEDIT}" = "y" ]   && printf 'BR2_PACKAGE_MHWAVEEDIT=y\n'
    [ "${AX_PKG_QASMIXER}" = "y" ]     && printf 'BR2_PACKAGE_QASMIXER=y\n'
    printf '\n'

    # Binary Inspection, Viewer, Screenshot, Calculator & Diagnostics
    printf '# Inspection, Viewer, Calculator & Diagnostics\n'
    [ "${AX_PKG_GHEX}" = "y" ]         && printf 'BR2_PACKAGE_GHEX=y\n'
    [ "${AX_PKG_FEH}" = "y" ]          && printf 'BR2_PACKAGE_FEH=y\n'
    [ "${AX_PKG_SCROT}" = "y" ]        && printf 'BR2_PACKAGE_SCROT=y\n'
    [ "${AX_PKG_QALCULATE_QT}" = "y" ] && printf 'BR2_PACKAGE_QALCULATE_QT=y\n'
    [ "${AX_PKG_CPUX}" = "y" ]         && printf 'BR2_PACKAGE_CPU_X=y\n'
    [ "${AX_PKG_NVTOP}" = "y" ]        && printf 'BR2_PACKAGE_NVTOP=y\n'
    [ "${AX_PKG_HTOP}" = "y" ]         && printf 'BR2_PACKAGE_HTOP=y\n'
    printf '\n'

    # Developer, Archive, Diff/Patch/Search, X11 & Editor Utilities
    printf '# CLI, Archive, X11 & Editor Tools\n'
    [ "${AX_PKG_GIT}" = "y" ] && printf 'BR2_PACKAGE_GIT=y\n'
    if [ "${AX_PKG_TERMINAL}" = "y" ]; then
        if [ "${AX_DESKTOP_SESSION}" = "xfce" ]; then
            printf 'BR2_PACKAGE_XFCE4_TERMINAL=y\n'
        else
            printf 'BR2_PACKAGE_QTERMINAL=y\n'
        fi
    fi
    if [ "${AX_PKG_ARCHIVE_TOOLS}" = "y" ]; then
        printf 'BR2_PACKAGE_UNZIP=y\n'
        printf 'BR2_PACKAGE_P7ZIP=y\n'
        printf 'BR2_PACKAGE_TAR=y\n'
    fi
    [ "${AX_PKG_LHASA}" = "y" ] && printf 'BR2_PACKAGE_LHASA=y\n'
    if [ "${AX_PKG_DEV_TEXT_TOOLS}" = "y" ]; then
        printf 'BR2_PACKAGE_DIFFUTILS=y\n'
        printf 'BR2_PACKAGE_PATCH=y\n'
        printf 'BR2_PACKAGE_RSYNC=y\n'
        printf 'BR2_PACKAGE_RIPGREP=y\n'
    fi
    if [ "${AX_PKG_X11_HELPERS}" = "y" ]; then
        printf 'BR2_PACKAGE_XCLIP=y\n'
        printf 'BR2_PACKAGE_XORG_XRANDR=y\n'
        printf 'BR2_PACKAGE_SETXKBMAP=y\n'
    fi
    if [ "${AX_PKG_TEXT_EDITOR}" = "y" ]; then
        printf 'BR2_PACKAGE_MICRO=y\n'
    fi
    printf '\n'

    # Heavy Tier Guardrails (Tier B)
    printf '# Heavy Tier Guardrails (delivery=%s)\n' "${AX_DESKTOP_HEAVY_DELIVERY}"
    if heavy_pkg_active "${AX_DESKTOP_HEAVY_GIMP}"; then
        printf 'BR2_PACKAGE_GIMP=y\n'
    else
        printf '# BR2_PACKAGE_GIMP is not set\n'
    fi
    if heavy_pkg_active "${AX_DESKTOP_HEAVY_KRITA}"; then
        printf 'BR2_PACKAGE_KRITA=y\n'
    else
        printf '# BR2_PACKAGE_KRITA is not set\n'
    fi
    if heavy_pkg_active "${AX_DESKTOP_HEAVY_SHOTCUT}"; then
        printf 'BR2_PACKAGE_SHOTCUT=y\n'
    else
        printf '# BR2_PACKAGE_SHOTCUT is not set\n'
    fi
    if heavy_pkg_active "${AX_DESKTOP_HEAVY_KDENLIVE}"; then
        printf 'BR2_PACKAGE_KDENLIVE=y\n'
    else
        printf '# BR2_PACKAGE_KDENLIVE is not set\n'
    fi
    if heavy_pkg_active "${AX_DESKTOP_HEAVY_HANDBRAKE}"; then
        printf 'BR2_PACKAGE_HANDBRAKE=y\n'
    else
        printf '# BR2_PACKAGE_HANDBRAKE is not set\n'
    fi
    if heavy_pkg_active "${AX_DESKTOP_HEAVY_KEEPASSXC}"; then
        printf 'BR2_PACKAGE_KEEPASSXC=y\n'
    else
        printf '# BR2_PACKAGE_KEEPASSXC is not set\n'
    fi
} > "${OUT_FILE}"

printf 'Generated Buildroot fragment: %s\n' "${OUT_FILE}"
