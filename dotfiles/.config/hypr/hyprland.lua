-- CachyOS Hyprland Configuration

require("config.animations")
require("config.autostart")
require("config.colors")
require("config.decorations")
require("config.variables")
require("config.environment")
require("config.inputs")
require("config.binds")
require("config.misc")
require("config.monitors")
require("config.windowrules")
require("config.workspaces")

-- For Noctalia Color templates
pcall(function()
    local noctalia = require("noctalia")
    noctalia.apply_theme()

    -- Active border: gradient from the theme's primary color into surface.
    -- Built from Noctalia's exported colors so it follows theme changes.
    local c = noctalia.colors
    hl.config({
        general = {
            col = {
                active_border = { colors = { c.primary, c.surface }, angle = 30 },
            },
        },
    })
end)
