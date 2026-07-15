#!/usr/bin/env bash

source "$(git rev-parse --show-toplevel)/install.d/envs.sh"

init "$@"

MODULES=(
  "mkdirs.sh"
  "stow.sh"
)

for MOD in "${MODULES[@]}"; do
  CMD="$MY_INSTALL_DIR/install.d/$MOD"
  if [[ -z "$REVERT" ]]; then
    info "Installing module '$CMD'..."
    $CMD
  else
    warn "Reverting module '$CMD'..."
    $CMD -r
  fi
done

