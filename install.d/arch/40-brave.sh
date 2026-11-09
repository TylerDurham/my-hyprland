on_init() {
  info "initializing module '$(basename "${BASH_SOURCE[0]}")'"
}

on_install() {
  info "installing module '$(basename "${BASH_SOURCE[0]}")'"

  if check-package brave-bin; then
    debug "brave is installed!"
  else
    debug "installing brave..."
    sudo pacman -Sy --noconfirm brave-bin
  fi

  info "installing brave settings"
  sudo install -d -m 755 /etc/brave/policies/{managed,recommended}
  sudo install -m 644 "$INSTALL_ROOT/40-brave.json" /etc/brave/policies/managed/
}

on_uninstall() {
  info "uninstalling module '$(basename "${BASH_SOURCE[0]}")'"
}

on_completed() {
  info "'$(basename ${BASH_SOURCE[0]})' completed!"
}
