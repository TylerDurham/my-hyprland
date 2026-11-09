# 70-tty-font.sh - set the console font to Terminus
#
# The mkinitcpio `consolefont` hook bakes vconsole.conf's FONT into the
# initramfs at build time, so early boot (e.g. the LUKS prompt) won't pick up
# a change until the image is rebuilt. Rather than rebuilding here, this module
# sets REBUILD_INITRAMFS=1 and the installer rebuilds once after all modules.

readonly VCONSOLE_CONF=/etc/vconsole.conf

# Set FONT=$1 in vconsole.conf. Requests an initramfs rebuild only when the
# file actually changes.
set_console_font() {
  local font="$1"

  if grep -qx "FONT=$font" "$VCONSOLE_CONF" 2>/dev/null; then
    debug "console font already '$font'... skipping"
    return
  fi

  if grep -q '^FONT=' "$VCONSOLE_CONF" 2>/dev/null; then
    sudo sed -i "s/^FONT=.*/FONT=$font/" "$VCONSOLE_CONF"
  else
    echo "FONT=$font" | sudo tee -a "$VCONSOLE_CONF" > /dev/null
  fi

  info "console font set to '$font'"
  REBUILD_INITRAMFS=1
}

on_install() {
  sudo pacman -Sy --noconfirm --needed terminus-font
  set_console_font ter-132b
}

on_uninstall() {
  set_console_font default8x16
}
