#!/usr/bin/env bash
#
# packages.sh - install repo and AUR packages from the lists next to this file
#
#   packages.txt      official repo packages, installed with pacman
#   aur-packages.txt  AUR packages, installed with yay
#
# One package per line; blank lines and '#' comments (whole-line or trailing)
# are ignored.

readonly PACKAGES_FILE="$INSTALL_ROOT/packages.txt"
readonly AUR_PACKAGES_FILE="$INSTALL_ROOT/aur-packages.txt"

# Print the package names in list file $1, without comments or blank lines.
read_package_list() {
  [[ -f "$1" ]] || return 0
  sed -e 's/#.*//' -e 's/[[:space:]]*$//' -e 's/^[[:space:]]*//' "$1" | grep -v '^$'
}

mapfile -t packages < <(read_package_list "$PACKAGES_FILE")
mapfile -t aur_packages < <(read_package_list "$AUR_PACKAGES_FILE")

# don't add if on cachyos.. installed by default
[[ "$OS" != "cachyos" ]] && packages+=(fzf git python vim zsh)

on_init() {
  info "initializing module '$(basename "${BASH_SOURCE[0]}")'"

  if [[ ${#aur_packages[@]} -gt 0 ]] && ! check-command yay; then
    fatal "yay not found; it is required to install AUR packages: ${aur_packages[*]}"
  fi
}

on_install() {
  info "installing module '$(basename "${BASH_SOURCE[0]}")'"
  local package

  for package in "${packages[@]}"; do
    if ! check-package "$package"; then
      info "installing package '$package'..."
      sudo pacman -Syq --noconfirm --needed "$package"
    else
      warn "package '$package' already installed... skipping"
    fi
  done

  for package in "${aur_packages[@]}"; do
    if ! check-package "$package"; then
      info "installing AUR package '$package'..."
      yay -Sq --noconfirm --needed "$package"
    else
      warn "AUR package '$package' already installed... skipping"
    fi
  done
}

on_uninstall() {
  info "uninstalling module '$(basename "${BASH_SOURCE[0]}")'"
  local package

  for package in "${aur_packages[@]}" "${packages[@]}"; do
    if check-package "$package"; then
      sudo pacman -Rs --noconfirm "$package"
    else
      warn "package '$package' is not installed... skipping"
    fi
  done
}

on_completed() {
  info "module '$(basename "${BASH_SOURCE[0]}")' completed!"
}
