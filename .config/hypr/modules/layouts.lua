hl.config({ general = { layout = "scrolling" } })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
  dwindle = {
    preserve_split = true, -- You probably want this
  },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
  master = {
    new_status = "master",
  },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
  scrolling = {
    fullscreen_on_one_column = true,
    column_width = 1.0,
    explicit_column_widths = "0.8",
    follow_min_visible = false
  },
})

hl.gesture({ fingers = 3, direction = "horizontal", scale = 1.5, action = "scroll_move" })
hl.gesture({ fingers = 3, mods = "SHIFT", direction = "horizontal", scale = 1.5, action = "workspace" })
hl.gesture({ fingers = 3, direction = "down", scale = 1.5, mods = "ALT", action = "close" })
hl.gesture({ fingers = 4, direction = "pinchout", scale = 1.5, action = "fullscreen" })
