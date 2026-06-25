#!/usr/bin/env bash

OUTPUT=""

on-exit() {

  if (( $? > 0 )); then
    msg="An error has occured while changing the wallpaper: \n$OUTPUT"
    notify-send -i dialog-warning "Error!" "$msg"
  fi
}

cache-thumbnail() {
  # Get the thumbnail for the selected wallpaper
  OUTPUT=$(sys-cache-thumbnail -i $1)
  echo "$OUTPUT" 
}

select-wallpaper() {
  # Get a wallpaper
  OUTPUT=$(hypr-select-wallpaper -d "$MY_WALLPAPER_DIR" 2>&1)
  echo "$OUTPUT"
}

set-wallpaper() {
  OUTPUT=$(hypr-set-wallpaper -i "$1" 2>&1)
  echo "$OUTPUT"
}

trap on-exit EXIT

# Load libs
source $MY_LIB_DIR/bash/require.sh logger 

set -eoEu pipefail

wallpaper=$(select-wallpaper)

if [[ -z "$wallpaper" ]]; then
  warn "No wallpaper selected."
  exit 
fi

echo$(set-wallpaper $wallpaper)

thumbnail=$(cache-thumbnail "$wallpaper")

notify-send -i $thumbnail "Success!" "Wallpaper changed to '$thumbnail'"



