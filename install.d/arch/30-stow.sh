SOURCE="$REPO_ROOT/dotfiles"
TARGET="$HOME/"

on_init() {
  info "initializing module '$(basename ${BASH_SOURCE[0]})'"
}

on_install() {
  info "installing module '$(basename ${BASH_SOURCE[0]})'"
  debug "stowing '$SOURCE' to '$TARGET'..."
  stow -v --no-folding --dir "$SOURCE" -S . -t "$TARGET"
}

on_uninstall() {
  info "uninstalling module '$(basename "${BASH_SOURCE[0]}")'"

  debug "un-stowing '$SOURCE' to '$TARGET'..."
  stow -v --no-folding --dir "$SOURCE" -D . -t "$TARGET"
}

on_completed() {
  info "'$(basename ${BASH_SOURCE[0]})' completed!"
}
