# 80-plymouth.sh - install (or remove) a Plymouth boot splash
#
# Fetches a themed pack from adi1090x/plymouth-themes and sets it as the
# default Plymouth theme, wires the 'plymouth' hook into mkinitcpio's HOOKS
# ahead of (sd-)encrypt (so the LUKS unlock prompt is themed too), and adds the
# standard silent-boot kernel params.
#
# Since plymouth 24 there is a single 'plymouth' hook for both busybox and
# systemd initramfs; the old 'sd-plymouth' hook no longer exists and mkinitcpio
# fails on it. Any leftover 'sd-plymouth' is stripped.
#
# Kernel params go wherever limine-entry-tool actually reads them: a managed
# KERNEL_CMDLINE[default]+= line in /etc/default/limine when that file defines
# the cmdline (CachyOS does, and '+=' makes the tool ignore /etc/kernel/cmdline),
# otherwise an existing /etc/kernel/cmdline. A cmdline file is never created
# from scratch - one without root= etc. would leave the system unbootable.
#
# Environment knobs:
#   PLYMOUTH_PRESET=lone   which preset to install (see PRESETS below)
#   NO_CONFIRM=1           skip pacman's confirmation prompt
#
# Safe to re-run: every step checks current state before changing anything.
# Uninstall reads the currently active theme back off the system rather than
# trusting PLYMOUTH_PRESET, so it works even if that variable is not set to
# whatever was installed.

# -------------------------------------------------------------------------------------------------
# GLOBALS
# -------------------------------------------------------------------------------------------------

readonly CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"        # Current directory (relative to this file)
readonly PKGS=(plymouth)                                            # Packages this module owns
readonly THEMES_REPO="https://github.com/adi1090x/plymouth-themes"  # Upstream theme source
readonly THEMES_DIR="/usr/share/plymouth/themes"                    # Where themes live once installed
readonly MKINITCPIO_CONF="/etc/mkinitcpio.conf"                     # HOOKS live here
readonly PLYMOUTHD_CONF="/etc/plymouth/plymouthd.conf"              # Per-theme daemon overrides
readonly CMDLINE_FILE="/etc/kernel/cmdline"                         # Fallback cmdline source for limine-entry-tool
readonly LIMINE_DEFAULT="/etc/default/limine"                       # Preferred cmdline source when it sets KERNEL_CMDLINE
readonly HOOK="plymouth"                                            # mkinitcpio hook (covers systemd initramfs too)
readonly HOOK_STATE="/etc/plymouth/.10-plymouth-added-hook"         # Present only if this module added HOOK
readonly BAK_SUFFIX=".pre-plymouth.bak"                             # Backup suffix for an edited /etc/kernel/cmdline
PLYMOUTH_PRESET="${PLYMOUTH_PRESET:-lone}"                          # Preset to install (see PRESETS)
NO_CONFIRM="${NO_CONFIRM:-0}"                                       # Skip pacman's confirmation prompt

# Silent-boot kernel params, fixed on - not exposed as a knob.
readonly SPLASH_PARAMS=(quiet splash loglevel=3 udev.log_level=3 systemd.show_status=auto)

# The managed block written into plymouthd.conf, and the line inside it.
readonly MARK_BEGIN="# >>> 10-plymouth.sh managed >>>"
readonly MARK_END="# <<< 10-plymouth.sh managed <<<"

# Presets: name -> "theme:extraConfig". extraConfig is a "Key=Value" line
# written to plymouthd.conf's [Daemon] section, or empty for none.
declare -A PRESETS=(
  [rings]="rings:"
  [lone]="lone:ShowDelay=0"
  [cuts]="cuts:ShowDelay=0"
  [circuit]="circuit:"
  [connect]="connect:"
)

# Resolved from PLYMOUTH_PRESET by on_init.
THEME=""
EXTRA_CONFIG=""

# Logging helper.
log() {
  debug "$*" 2>&1 | indent 4
}

# -------------------------------------------------------------------------------------------------
# HOOKS
# -------------------------------------------------------------------------------------------------

# Called by source script. Initializes the module.
on_init() {
  log "$FUNCNAME: Checking environment..."
  check_environment

  log "$FUNCNAME: Resolving preset '${PLYMOUTH_PRESET}'..."
  resolve_preset

  # Prime the sudo timestamp up front so the install does not stall on a
  # password prompt halfway through.
  sudo -v
}

# Called by source script. Installs the module.
on_install() {
  log "$FUNCNAME: Installing ${PKGS[*]}..."
  install_packages

  log "$FUNCNAME: Fetching theme '${THEME}'..."
  fetch_theme

  log "$FUNCNAME: Setting default theme to '${THEME}'..."
  sudo plymouth-set-default-theme "$THEME"

  log "$FUNCNAME: Writing plymouthd.conf overrides..."
  write_daemon_conf

  log "$FUNCNAME: Wiring ${HOOK} into mkinitcpio HOOKS..."
  add_hook

  log "$FUNCNAME: Adding silent-boot kernel params..."
  remove_legacy_cmdline
  add_cmdline_params

  # The installer rebuilds the initramfs once, after every module has run.
  REBUILD_INITRAMFS=1

  info "Done: preset '${PLYMOUTH_PRESET}' (theme '${THEME}') is now the default. Reboot (after the initramfs rebuild) to see it."
}

# Called by source script. Uninstalls the module.
on_uninstall() {
  local installed_theme
  installed_theme="$(plymouth-set-default-theme 2>/dev/null || true)"

  log "$FUNCNAME: Resetting default theme (currently '${installed_theme:-none}')..."
  reset_default_theme "$installed_theme"

  log "$FUNCNAME: Removing plymouthd.conf overrides..."
  remove_daemon_conf

  log "$FUNCNAME: Removing ${HOOK} from mkinitcpio HOOKS (if this module added it)..."
  remove_hook

  log "$FUNCNAME: Removing silent-boot kernel params..."
  remove_legacy_cmdline
  remove_cmdline_params

  log "$FUNCNAME: Removing theme files..."
  remove_theme "$installed_theme"

  log "$FUNCNAME: Removing packages..."
  uninstall_packages

  # The installer rebuilds the initramfs once, after every module has run.
  REBUILD_INITRAMFS=1

  info "Done: Plymouth removed; initramfs will be rebuilt."
}

# -------------------------------------------------------------------------------------------------
# CORE FUNCTIONS
# -------------------------------------------------------------------------------------------------

# Check for pacman, sudo and git, and that we are not running as root.
check_environment() {
    command -v pacman >/dev/null 2>&1 \
        || die "pacman not found - this script only supports Arch-based systems."

    [[ $EUID -ne 0 ]] \
        || die "Do not run this script as root; it calls sudo where needed."

    command -v sudo >/dev/null 2>&1 \
        || die "sudo not found; it is required to install packages and edit system files."

    command -v git >/dev/null 2>&1 \
        || die "git not found; it is required to fetch themes from ${THEMES_REPO}."
}

# Split PLYMOUTH_PRESET's "theme:extraConfig" entry into THEME/EXTRA_CONFIG.
resolve_preset() {
    [[ -n "${PRESETS[$PLYMOUTH_PRESET]+x}" ]] \
        || die "Unknown preset '${PLYMOUTH_PRESET}' (available: ${!PRESETS[*]})"

    THEME="${PRESETS[$PLYMOUTH_PRESET]%%:*}"
    EXTRA_CONFIG="${PRESETS[$PLYMOUTH_PRESET]#*:}"
}

is_installed() {
    pacman -Qi "$1" >/dev/null 2>&1
}

install_packages() {
    local missing=()
    local pkg

    for pkg in "${PKGS[@]}"; do
        is_installed "$pkg" || missing+=("$pkg")
    done

    if [[ ${#missing[@]} -eq 0 ]]; then
        info "Packages already present: ${PKGS[*]}"
        return
    fi

    info "Installing: ${missing[*]}"

    if [[ $NO_CONFIRM -eq 1 ]]; then
        sudo pacman -S --needed --noconfirm "${missing[@]}"
    else
        sudo pacman -S --needed "${missing[@]}"
    fi
}

uninstall_packages() {
    local installed=()
    local pkg

    for pkg in "${PKGS[@]}"; do
        is_installed "$pkg" && installed+=("$pkg")
    done

    if [[ ${#installed[@]} -eq 0 ]]; then
        warn "None of the listed packages are installed; nothing to remove."
        return
    fi

    info "Removing: ${installed[*]}"
    sudo pacman -Rns --noconfirm "${installed[@]}"
}

# --- theme -----------------------------------------------------------------------------------------

fetch_theme() {
    local theme_dir="${THEMES_DIR}/${THEME}"
    local tmp_dir src pack

    if [[ -d "$theme_dir" ]]; then
        info "Theme '${THEME}' already installed at ${theme_dir}."
        return
    fi

    tmp_dir="$(mktemp -d)"
    # shellcheck disable=SC2064
    trap "rm -rf '${tmp_dir}'" RETURN

    info "Cloning ${THEMES_REPO}..."
    git clone --depth 1 --quiet "$THEMES_REPO" "${tmp_dir}/plymouth-themes"

    src=""
    for pack in pack_1 pack_2 pack_3; do
        if [[ -d "${tmp_dir}/plymouth-themes/${pack}/${THEME}" ]]; then
            src="${tmp_dir}/plymouth-themes/${pack}/${THEME}"
            break
        fi
    done

    [[ -n "$src" ]] \
        || die "Theme '${THEME}' not found in ${THEMES_REPO} (checked pack_1..pack_3)."

    info "Installing theme files to ${theme_dir}..."
    sudo mkdir -p "$theme_dir"
    sudo cp -r "${src}/." "${theme_dir}/"
}

# Only remove themes this module owns - one of PRESETS' values. A
# hand-installed or distro theme left as the default is not ours to delete.
remove_theme() {
    local theme="$1"
    local theme_dir="${THEMES_DIR}/${theme}"
    local preset found=0

    if [[ -z "$theme" || ! -d "$theme_dir" ]]; then
        return
    fi

    for preset in "${!PRESETS[@]}"; do
        [[ "${PRESETS[$preset]%%:*}" == "$theme" ]] && { found=1; break; }
    done

    if [[ $found -eq 0 ]]; then
        warn "Default theme '${theme}' is not one of this module's presets; leaving ${theme_dir} in place."
        return
    fi

    info "Removing ${theme_dir}"
    sudo rm -rf "$theme_dir"
}

reset_default_theme() {
    local current="$1"

    if [[ -z "$current" || "$current" == "text" ]]; then
        info "Default theme is already 'text' (or unset); nothing to reset."
        return
    fi

    info "Resetting default theme from '${current}' to 'text'"
    sudo plymouth-set-default-theme text
}

# --- plymouthd.conf ----------------------------------------------------------------------------------

write_daemon_conf() {
    local tmp

    if [[ -z "$EXTRA_CONFIG" ]]; then
        return
    fi

    tmp="$(mktemp)"
    [[ -f "$PLYMOUTHD_CONF" ]] && cp "$PLYMOUTHD_CONF" "$tmp"

    if grep -qF "$MARK_BEGIN" "$tmp" 2>/dev/null && grep -qxF "$EXTRA_CONFIG" "$tmp"; then
        info "${PLYMOUTHD_CONF} already carries '${EXTRA_CONFIG}'."
        rm -f "$tmp"
        return
    fi

    # Strip a managed block from a previous run (e.g. switching presets)
    # before appending the current one.
    strip_managed_block "$tmp"

    grep -q '^\[Daemon\]' "$tmp" || printf '[Daemon]\n' >> "$tmp"
    {
        printf '%s\n' "$MARK_BEGIN"
        printf '%s\n' "$EXTRA_CONFIG"
        printf '%s\n' "$MARK_END"
    } >> "$tmp"

    info "Setting ${EXTRA_CONFIG} in ${PLYMOUTHD_CONF}"
    sudo mkdir -p "$(dirname "$PLYMOUTHD_CONF")"
    sudo install -m 0644 -o root -g root "$tmp" "$PLYMOUTHD_CONF"
    rm -f "$tmp"
}

remove_daemon_conf() {
    local tmp

    if [[ ! -f "$PLYMOUTHD_CONF" ]] || ! grep -qF "$MARK_BEGIN" "$PLYMOUTHD_CONF"; then
        return
    fi

    tmp="$(mktemp)"
    cp "$PLYMOUTHD_CONF" "$tmp"
    strip_managed_block "$tmp"

    info "Removing managed block from ${PLYMOUTHD_CONF}"
    sudo install -m 0644 -o root -g root "$tmp" "$PLYMOUTHD_CONF"
    rm -f "$tmp"
}

# Strip the MARK_BEGIN/MARK_END block from $1 in place.
strip_managed_block() {
    local file="$1"
    local tmp
    tmp="$(mktemp)"

    awk -v begin="$MARK_BEGIN" -v end="$MARK_END" '
        $0 == begin { skip = 1; next }
        $0 == end   { skip = 0; next }
        !skip       { print }
    ' "$file" > "$tmp"

    mv "$tmp" "$file"
}

# --- mkinitcpio HOOKS --------------------------------------------------------------------------------

read_hooks() {
    grep -oP '^HOOKS=\(\K[^)]*' "$MKINITCPIO_CONF"
}

# Write $1 back as the HOOKS=(...) line.
write_hooks() {
    local hooks="$1" tmp
    tmp="$(mktemp)"
    cp "$MKINITCPIO_CONF" "$tmp"
    sed -i "s|^HOOKS=(.*)|HOOKS=(${hooks})|" "$tmp"
    sudo install -m 0644 -o root -g root "$tmp" "$MKINITCPIO_CONF"
    rm -f "$tmp"
}

# Print the space-separated list $1 with every occurrence of word $2 removed.
drop_word() {
    local out=() w
    for w in $1; do
        [[ "$w" == "$2" ]] || out+=("$w")
    done
    printf '%s' "${out[*]}"
}

# The hook has to run before (sd-)encrypt for a themed LUKS unlock prompt.
# Fixed choice - not exposed as an option.
add_hook() {
    local hooks orig anchor out=() w placed=0

    [[ -f "$MKINITCPIO_CONF" ]] \
        || die "${MKINITCPIO_CONF} not found."

    hooks="$(read_hooks)"
    [[ -n "$hooks" ]] \
        || die "Could not find a HOOKS=(...) line in ${MKINITCPIO_CONF}."
    orig="$hooks"

    # Leftover from earlier versions of this module; mkinitcpio rejects it.
    hooks="$(drop_word "$hooks" sd-plymouth)"

    if [[ " $hooks " == *" ${HOOK} "* ]]; then
        info "${HOOK} is already in HOOKS."
    else
        # Insert before the first of these that is present, else append.
        for anchor in sd-encrypt encrypt filesystems; do
            [[ " $hooks " == *" $anchor "* ]] && break
            anchor=""
        done

        for w in $hooks; do
            if [[ $placed -eq 0 && "$w" == "$anchor" ]]; then
                out+=("$HOOK"); placed=1
            fi
            out+=("$w")
        done
        [[ $placed -eq 1 ]] || out+=("$HOOK")
        hooks="${out[*]}"

        # Remember that the hook is ours, so uninstall leaves a distro-provided
        # one (CachyOS ships it) alone.
        sudo mkdir -p "$(dirname "$HOOK_STATE")"
        sudo touch "$HOOK_STATE"
    fi

    if [[ "$hooks" != "$orig" ]]; then
        info "Updating HOOKS in ${MKINITCPIO_CONF}: (${hooks})"
        write_hooks "$hooks"
    fi
}

remove_hook() {
    local hooks orig

    [[ -f "$MKINITCPIO_CONF" ]] || return

    hooks="$(read_hooks)"
    orig="$hooks"

    hooks="$(drop_word "$hooks" sd-plymouth)"

    if [[ -f "$HOOK_STATE" ]]; then
        hooks="$(drop_word "$hooks" "$HOOK")"
        sudo rm -f "$HOOK_STATE"
    elif [[ " $hooks " == *" ${HOOK} "* ]]; then
        info "${HOOK} was in HOOKS before this module ran; leaving it."
    fi

    if [[ "$hooks" != "$orig" ]]; then
        info "Updating HOOKS in ${MKINITCPIO_CONF}: (${hooks})"
        write_hooks "$hooks"
    fi
}

# --- kernel cmdline ------------------------------------------------------------------------------------

# True when /etc/default/limine defines the kernel cmdline itself.
limine_default_has_cmdline() {
    [[ -f "$LIMINE_DEFAULT" ]] && grep -qE '^[[:space:]]*KERNEL_CMDLINE\[' "$LIMINE_DEFAULT"
}

# Print the SPLASH_PARAMS not already present in the text $1.
missing_params() {
    local text="$1" param out=()
    for param in "${SPLASH_PARAMS[@]}"; do
        [[ " $text " == *" $param "* ]] || out+=("$param")
    done
    printf '%s' "${out[*]}"
}

add_cmdline_params() {
    local current missing tmp

    if limine_default_has_cmdline; then
        # Compare against the cmdline lines outside our managed block.
        tmp="$(mktemp)"
        cp "$LIMINE_DEFAULT" "$tmp"
        strip_managed_block "$tmp"
        current="$(grep -E '^[[:space:]]*KERNEL_CMDLINE\[default\]' "$tmp" | sed -E 's/^[^"]*"//; s/"[[:space:]]*$//' | tr '\n' ' ')"
        missing="$(missing_params "$current")"

        if [[ -z "$missing" ]]; then
            info "${LIMINE_DEFAULT} already carries the silent-boot params."
            # Drop a stale managed block from a previous run, if any.
            if ! cmp -s "$tmp" "$LIMINE_DEFAULT"; then
                sudo install -m 0644 -o root -g root "$tmp" "$LIMINE_DEFAULT"
            fi
            rm -f "$tmp"
            return
        fi

        {
            printf '%s\n' "$MARK_BEGIN"
            printf 'KERNEL_CMDLINE[default]+=" %s"\n' "$missing"
            printf '%s\n' "$MARK_END"
        } >> "$tmp"

        info "Appending '${missing}' to KERNEL_CMDLINE[default] in ${LIMINE_DEFAULT}"
        sudo install -m 0644 -o root -g root "$tmp" "$LIMINE_DEFAULT"
        rm -f "$tmp"
        return
    fi

    if [[ -f "$CMDLINE_FILE" ]] && grep -q 'root=' "$CMDLINE_FILE"; then
        current="$(cat "$CMDLINE_FILE")"
        missing="$(missing_params "$current")"

        if [[ -z "$missing" ]]; then
            info "${CMDLINE_FILE} already carries the silent-boot params."
            return
        fi

        [[ -f "${CMDLINE_FILE}${BAK_SUFFIX}" ]] \
            || sudo cp -a "$CMDLINE_FILE" "${CMDLINE_FILE}${BAK_SUFFIX}"

        info "Appending '${missing}' to ${CMDLINE_FILE}"
        tmp="$(mktemp)"
        printf '%s %s\n' "$current" "$missing" > "$tmp"
        sudo install -m 0644 -o root -g root "$tmp" "$CMDLINE_FILE"
        rm -f "$tmp"
        return
    fi

    warn "Could not find where the bootloader reads kernel params (no KERNEL_CMDLINE in"
    warn "${LIMINE_DEFAULT}, no ${CMDLINE_FILE} with root=). Not creating one - add these"
    warn "by hand for a silent boot: ${SPLASH_PARAMS[*]}"
}

remove_cmdline_params() {
    local tmp

    if [[ -f "$LIMINE_DEFAULT" ]] && grep -qF "$MARK_BEGIN" "$LIMINE_DEFAULT"; then
        tmp="$(mktemp)"
        cp "$LIMINE_DEFAULT" "$tmp"
        strip_managed_block "$tmp"
        info "Removing managed block from ${LIMINE_DEFAULT}"
        sudo install -m 0644 -o root -g root "$tmp" "$LIMINE_DEFAULT"
        rm -f "$tmp"
    fi

    if [[ -f "${CMDLINE_FILE}${BAK_SUFFIX}" ]]; then
        info "Restoring ${CMDLINE_FILE} from backup"
        sudo mv -f "${CMDLINE_FILE}${BAK_SUFFIX}" "$CMDLINE_FILE"
    fi
}

# Earlier versions of this module created /etc/kernel/cmdline holding only the
# splash params. With no root= it is a boot-breaker the moment anything reads
# it, so delete it - but only if every word in it is one of ours.
remove_legacy_cmdline() {
    local w

    [[ -f "$CMDLINE_FILE" ]] || return

    for w in $(cat "$CMDLINE_FILE"); do
        [[ " ${SPLASH_PARAMS[*]} " == *" $w "* ]] || return
    done

    warn "Removing ${CMDLINE_FILE}: it holds only splash params (no root=), left by an older run."
    sudo rm -f "$CMDLINE_FILE"
}
