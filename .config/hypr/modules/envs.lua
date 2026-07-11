-- ###################################
--
-- ███████╗███╗   ██╗██╗   ██╗███████╗
-- ██╔════╝████╗  ██║██║   ██║██╔════╝
-- █████╗  ██╔██╗ ██║██║   ██║███████╗
-- ██╔══╝  ██║╚██╗██║╚██╗ ██╔╝╚════██║
-- ███████╗██║ ╚████║ ╚████╔╝ ███████║
-- ╚══════╝╚═╝  ╚═══╝  ╚═══╝  ╚══════╝
-- ###################################

local home = os.getenv("HOME")

hl.config({
	env = {
		"CLUTTER_BACKEND,wayland",
		"GDK_BACKEND,wayland,x11",
		"MOZ_ENABLE_WAYLAND,1",
		"MY_LIB_DIR," .. home .. "/.local/share/my/lib",
		"NEWT_COLORS" .. home .. "/.config/my/current/nmtui.colors",
		"NEWT_COLORS_FILE," .. home .. "/.config/my/current/nmtui.colors",
		"PATH," .. home .. "/.local/share/my/bin:$PATH",
		"QT_QPA_PLATFORM,wayland",
		"QT_QPA_PLATFORMTHEME,qt6ct",
		"QT_WAYLAND_DISABLE_WINDOWDECORATION,1",
		"SDL_VIDEODRIVER,wayland",
		"XCURSOR_SIZE,24",
		"XCURSOR_THEME,Adwaita",
	},
})

-- hl.env("PATH", home .. "/.local/bin:$PATH")
-- hl.env("USER_LIB_DIR", home .. "/.local/shared/dtd/lib")
