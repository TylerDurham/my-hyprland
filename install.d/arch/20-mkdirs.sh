# Keep GNU stow from owning these directories
DIRECTORIES=(
  "$HOME/.local/share/$PREFIX/bin"
)

on_init() {
  info "initializing module '$(basename "${BASH_SOURCE[0]}")'"
}

on_install() {
  info "installing module '$(basename "${BASH_SOURCE[0]}")'"
  for dir in "${DIRECTORIES[@]}"; do
    debug "creating directory at '$dir'..."
    mkdir -p "$dir"
  done
}

on_uninstall() {
  info "uninstalling module '$(basename "${BASH_SOURCE[0]}")'"
  # Only remove directories that are empty, so user files (e.g. custom
  # Claude commands or local config) are never deleted.
  for dir in "${DIRECTORIES[@]}"; do
    [[ -d "$dir" ]] || continue
    if rmdir "$dir" 2>/dev/null; then
      debug "removed empty directory '$dir'"
    else
      warn "'$dir' is not empty... leaving it in place" 2>&1 | indent
    fi
  done
}

on_completed() {
  info "'$(basename ${BASH_SOURCE[0]})' completed!"
}

