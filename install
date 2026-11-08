#!/usr/bin/env bash
#
# install - detect the OS and run the matching installer in ./install.d
#
# USAGE:
#   ./install [-r|--remove] [-s|--select]
#
# OPTIONS:
#   -r, --remove   uninstall modules (in reverse order) instead of installing
#   -s, --select   pick which modules to run interactively
#   -h, --help     show this help
#
# Options are passed through unchanged to install.d/<os>/install.
# Kept bash 3.2 compatible, since that is what stock macOS runs this with.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for arg in "$@"; do
  case "$arg" in
    -h|--help) sed -n '3,13s/^# \{0,1\}//p' "${BASH_SOURCE[0]}"; exit 0 ;;
  esac
done

OS="$(sys-get-os || true)"

case "$OS" in
  macos)                          TARGET=macos ;;
  arch|cachyos|endeavour|manjaro) TARGET=arch ;;
  *) echo "unsupported OS '$OS'; available: $(ls "$REPO_ROOT/install.d" | tr '\n' ' ')" >&2; exit 1 ;;
esac

INSTALLER="$REPO_ROOT/install.d/$TARGET/install"
[[ -x "$INSTALLER" ]] || { echo "installer not found: $INSTALLER" >&2; exit 1; }

# The OS installers locate the repo with 'git rev-parse', so run from inside it.
cd "$REPO_ROOT"
exec "$INSTALLER" "$@"

