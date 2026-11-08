#!/usr/bin/env bash

packages=(
  nautilus
  libappindicator
)

# don't add if on cachyos.. installed by default
[[ "$OS" != "cachyos" ]] && packages+=(fzf)
[[ "$OS" != "cachyos" ]] && packages+=(git)
[[ "$OS" != "cachyos" ]] && packages+=(python)
[[ "$OS" != "cachyos" ]] && packages+=(vim)
[[ "$OS" != "cachyos" ]] && packages+=(zsh)

on_init() {
  info "initializing module '$(basename "${BASH_SOURCE[0]}")'"
}

on_install() {
  info "installing module '$(basename "${BASH_SOURCE[0]}")'"
  for package in "${packages[@]}"; do
    if ! check-package "$package"; then
      info "installing package '$package'..."
      sudo pacman -Syq --noconfirm "$package"
    else
      warn "package '$package' already installed... skipping"
    fi
  done
}

on_uninstall() {
  info "uninstalling module '$(basename "${BASH_SOURCE[0]}")'"
  for package in "${packages[@]}"; do
    if check-package "$package"; then
      sudo pacman -Rs --noconfirm "$package"
    else
      warn "package '$package' is not installed... skipping"
    fi
  done
}

on_completed() {
  info "module '$(basename $module)' completed!"
}
