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
    awk -F'[?]?=' -v key="${var_name}" '
        $1 ~ "^[[:space:]]*" key "[[:space:]]*$" {
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2)
            print $2
            exit
        }
    ' "${mk_file}"
}

CORE_MK="${REPO_ROOT}/profiles/desktop-core.mk"

AX_DESKTOP_CORE_ENABLED="$(read_mk_var AX_DESKTOP_CORE_ENABLED "${CORE_MK}")"
if [ "${AX_DESKTOP_CORE_ENABLED}" != "y" ]; then
    printf 'AX_DESKTOP_CORE_ENABLED is not "y"; skipping fragment generation.\n' >&2
    exit 0
fi

AX_DESKTOP_SESSION="$(read_mk_var AX_DESKTOP_SESSION "${CORE_MK}")"
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

AX_PKG_GHEX="$(read_mk_var AX_PKG_GHEX "${CORE_MK}")"
AX_PKG_FEH="$(read_mk_var AX_PKG_FEH "${CORE_MK}")"
AX_PKG_SCROT="$(read_mk_var AX_PKG_SCROT "${CORE_MK}")"
AX_PKG_CPUX="$(read_mk_var AX_PKG_CPUX "${CORE_MK}")"
AX_PKG_NVTOP="$(read_mk_var AX_PKG_NVTOP "${CORE_MK}")"

AX_DESKTOP_PDF_VIEWER="$(read_mk_var AX_DESKTOP_PDF_VIEWER "${CORE_MK}")"
AX_PKG_GIT="$(read_mk_var AX_PKG_GIT "${CORE_MK}")"
AX_PKG_TERMINAL="$(read_mk_var AX_PKG_TERMINAL "${CORE_MK}")"
AX_PKG_ARCHIVE_TOOLS="$(read_mk_var AX_PKG_ARCHIVE_TOOLS "${CORE_MK}")"

AX_DESKTOP_HEAVY_GIMP="$(read_mk_var AX_DESKTOP_HEAVY_GIMP "${CORE_MK}")"
AX_DESKTOP_HEAVY_KRITA="$(read_mk_var AX_DESKTOP_HEAVY_KRITA "${CORE_MK}")"
AX_DESKTOP_HEAVY_SHOTCUT="$(read_mk_var AX_DESKTOP_HEAVY_SHOTCUT "${CORE_MK}")"
AX_DESKTOP_HEAVY_HANDBRAKE="$(read_mk_var AX_DESKTOP_HEAVY_HANDBRAKE "${CORE_MK}")"
AX_DESKTOP_HEAVY_KEEPASSXC="$(read_mk_var AX_DESKTOP_HEAVY_KEEPASSXC "${CORE_MK}")"

mkdir -p "$(dirname -- "${OUT_FILE}")"

{
    printf '# Auto-generated from piccolo-ax-desktop/profiles/desktop-core.mk\n'
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
    esac
    printf '\n'

    # Core 2D & Pixel Graphics Suite (< 30 MB total)
    printf '# Core 2D & Pixel Graphics Suite\n'
    [ "${AX_PKG_MTPAINT}" = "y" ]     && printf 'BR2_PACKAGE_MTPAINT=y\n'
    [ "${AX_PKG_GRAFX2}" = "y" ]      && printf 'BR2_PACKAGE_GRAFX2=y\n'
    [ "${AX_PKG_AZPAINTER}" = "y" ]   && printf 'BR2_PACKAGE_AZPAINTER=y\n'
    [ "${AX_PKG_LIBRESPRITE}" = "y" ] && printf 'BR2_PACKAGE_LIBRESPRITE=y\n'
    printf '\n'

    # Binary Inspection, Viewer, Screenshot & Silicon Diagnostics
    printf '# Inspection, Viewer & Diagnostics\n'
    [ "${AX_PKG_GHEX}" = "y" ]  && printf 'BR2_PACKAGE_GHEX=y\n'
    [ "${AX_PKG_FEH}" = "y" ]   && printf 'BR2_PACKAGE_FEH=y\n'
    [ "${AX_PKG_SCROT}" = "y" ] && printf 'BR2_PACKAGE_SCROT=y\n'
    [ "${AX_PKG_CPUX}" = "y" ]  && printf 'BR2_PACKAGE_CPU_X=y\n'
    [ "${AX_PKG_NVTOP}" = "y" ] && printf 'BR2_PACKAGE_NVTOP=y\n'
    printf '\n'

    # Developer & Archive Utilities
    printf '# CLI & Archive Tools\n'
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
    printf '\n'

    # Heavy Tier Guardrails
    printf '# Heavy Tier Guardrails\n'
    if [ "${AX_DESKTOP_HEAVY_GIMP}" = "y" ]; then
        printf 'BR2_PACKAGE_GIMP=y\n'
    else
        printf '# BR2_PACKAGE_GIMP is not set\n'
    fi
    if [ "${AX_DESKTOP_HEAVY_KRITA}" = "y" ]; then
        printf 'BR2_PACKAGE_KRITA=y\n'
    else
        printf '# BR2_PACKAGE_KRITA is not set\n'
    fi
    if [ "${AX_DESKTOP_HEAVY_SHOTCUT}" = "y" ]; then
        printf 'BR2_PACKAGE_SHOTCUT=y\n'
    else
        printf '# BR2_PACKAGE_SHOTCUT is not set\n'
    fi
    if [ "${AX_DESKTOP_HEAVY_HANDBRAKE}" = "y" ]; then
        printf 'BR2_PACKAGE_HANDBRAKE=y\n'
    else
        printf '# BR2_PACKAGE_HANDBRAKE is not set\n'
    fi
    if [ "${AX_DESKTOP_HEAVY_KEEPASSXC}" = "y" ]; then
        printf 'BR2_PACKAGE_KEEPASSXC=y\n'
    else
        printf '# BR2_PACKAGE_KEEPASSXC is not set\n'
    fi
} > "${OUT_FILE}"

printf 'Generated Buildroot fragment: %s\n' "${OUT_FILE}"

