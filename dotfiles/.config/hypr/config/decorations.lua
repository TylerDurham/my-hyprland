-- Look and feel configuration

hl.config({
	general = {
		gaps_in = 10,
		gaps_out = 10,
		border_size = 2,
		extend_border_grab_area = 10,
		resize_on_border = true,
		-- Border/group colors come from Noctalia's generated noctalia.lua
		-- (required at the end of hyprland.lua).
	},
	decoration = {
		dim_special = 0.3,
		rounding = 6,
		active_opacity = 0.9,
		inactive_opacity = 0.70,
		fullscreen_opacity = 1,
		blur = {
			size = 5,
			passes = 2,
			special = true,
		},
	},
})
