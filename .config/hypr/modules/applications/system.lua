
hl.window_rule({
  name = "modal-utility-window",
  match = {
    class = "^(blueman-manager|nm-connection-editor|org.pulseaudio.pavucontrol)$"
  },
  tag = "+modal-window",
})
