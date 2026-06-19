
hl.window_rule({
  name = "1password",
  match = {
    class = "^(1[p|P]assword)$"
  },
  no_screen_share = true,
  tag = "+modal-window"
})

-- hl.notification.create({ text="1Password window rule set.", timeout=1000 })
