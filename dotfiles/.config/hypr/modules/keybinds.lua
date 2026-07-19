-- ##############################################################
--
-- ██╗  ██╗███████╗██╗   ██╗██████╗ ██╗███╗   ██╗██████╗ ███████╗
-- ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔══██╗██║████╗  ██║██╔══██╗██╔════╝
-- █████╔╝ █████╗   ╚████╔╝ ██████╔╝██║██╔██╗ ██║██║  ██║███████╗
-- ██╔═██╗ ██╔══╝    ╚██╔╝  ██╔══██╗██║██║╚██╗██║██║  ██║╚════██║
-- ██║  ██╗███████╗   ██║   ██████╔╝██║██║ ╚████║██████╔╝███████║
-- ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝
-- ##############################################################

local g = require("modules.globals")
local MAIN_MOD    = g.keybinds.MAIN_MOD
local TERMINAL    = g.programs.TERMINAL
local APP_LAUNCHER = g.programs.APP_LAUNCHER
local FILE_MANAGER = g.programs.FILE_MANAGER
local BROWSER     = g.programs.BROWSER
local NOTES       = g.programs.NOTES

local monitors = require("modules.monitors")
local layouts = require("modules.layouts")

----------------------------------
---- APPLICATIONS ----------------
----------------------------------

hl.bind(MAIN_MOD .. " + Return", hl.dsp.exec_cmd(TERMINAL),      { description = " Launch Terminal (" .. TERMINAL .. ")" })
hl.bind(MAIN_MOD .. " + Space",  hl.dsp.exec_cmd(APP_LAUNCHER),  { description = "󱓞 Launch App Launcher" })
hl.bind(MAIN_MOD .. " + B",      hl.dsp.exec_cmd(BROWSER),       { description = "󰖟 Launch Browser (" .. BROWSER .. ")" })
hl.bind(MAIN_MOD .. " + E",      hl.dsp.exec_cmd(FILE_MANAGER),  { description = " Launch File Manager (" .. FILE_MANAGER .. ")" })
hl.bind(MAIN_MOD .. " + N",      hl.dsp.exec_cmd(NOTES),         { description = "󰠮 Launch Notes (" .. NOTES .. ")" })
hl.bind(MAIN_MOD .. " + K",      hl.dsp.exec_cmd("~/.local/share/my/bin/hypr-show-keybinds"), { description = "󰌌 Show Keybinds" })

----------------------------------
---- SCREENSHOTS -----------------
----------------------------------

hl.bind(MAIN_MOD .. " + Print",         hl.dsp.exec_cmd("screenshot"),      { locked=true, description = " Screenshot (fullscreen)" })
hl.bind(MAIN_MOD .. " + SHIFT + Print", hl.dsp.exec_cmd("screenshot area"), { locked=true, description = " Screenshot (region select)" })

----------------------------------
---- WINDOWS ---------------------
----------------------------------

hl.bind(MAIN_MOD .. " + Q",            hl.dsp.window.close(),   { description = "󰅗 Close Current Window" })
hl.bind(MAIN_MOD .. " + mouse:272",    hl.dsp.window.drag(),    { description = "󰇘 Drag Window" })
hl.bind(MAIN_MOD .. " + SHIFT + mouse:272", hl.dsp.window.resize(), { description = "󰙕 Resize Window" })

-- Cycle through non-empty windows
hl.bind(MAIN_MOD .. " + L", function()
	hl.dispatch(hl.dsp.window.cycle_next({ "e+1", "scrolling" }))
end, { description = "󰒭 Cycle to Next Window" })

hl.bind(MAIN_MOD .. " + H", function()
	hl.dispatch(hl.dsp.window.cycle_next({ "e-1", "scrolling" }))
end, { description = "󰒮 Cycle to Previous Window" })

----------------------------------
---- LAYOUTS ---------------------
----------------------------------

-- Cycle scrolling -> dwindle -> master -> scrolling
hl.bind(MAIN_MOD .. " + SHIFT + Space", layouts.cycle, { description = "󰕰 Cycle Window Layout" })

----------------------------------
---- WORKSPACES ------------------
----------------------------------

-- Switch to workspace / move window to workspace (1–10, key 0 = workspace 10)
for i = 1, 10 do
	local key = i % 10
	hl.bind(MAIN_MOD .. " + " .. key,         hl.dsp.focus({ workspace = i }),        { description = "󰖯 Go to Workspace " .. i })
	hl.bind(MAIN_MOD .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }),  { description = "󰖲 Move Window to Workspace " .. i })
end

-- Cycle through non-empty workspaces
hl.bind(MAIN_MOD .. " + SHIFT + bracketright", function()
	hl.dispatch(hl.dsp.focus({ workspace = "e+1" }))
end, { description = "󰒭 Cycle to Next Workspace" })

hl.bind(MAIN_MOD .. " + SHIFT + bracketleft", function()
	hl.dispatch(hl.dsp.focus({ workspace = "e-1" }))
end, { description = "󰒮 Cycle to Previous Workspace" })

-- Move current workspace to a different monitor
hl.bind("SUPER + SHIFT + LEFT",  hl.dsp.workspace.move({ monitor = "+1" }), { description = "󰛽 Move Workspace to Left Monitor" })
hl.bind("SUPER + SHIFT + RIGHT", hl.dsp.workspace.move({ monitor = "-1" }), { description = "󰛾 Move Workspace to Right Monitor" })

----------------------------------
---- GESTURES --------------------
----------------------------------

hl.gesture({ fingers = 3, direction = "horizontal", scale = 1.5, action = "scroll_move" })
hl.gesture({ fingers = 3, direction = "horizontal", scale = 1.5, mods = "SHIFT", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down",       scale = 1.5, mods = "ALT",   action = "close" })
hl.gesture({ fingers = 4, direction = "pinchout",   scale = 1.5, action = "fullscreen" })

----------------------------------
---- SYSTEM ----------------------
----------------------------------

hl.bind(MAIN_MOD .. " + SHIFT + S", hl.dsp.exec_cmd("rofi-launch-module ~/.config/rofi/modules/system.json"), { description = "󰒲 System Control Menu" })
hl.bind(MAIN_MOD .. " + SHIFT + N", hl.dsp.exec_cmd("~/.local/bin/hypr-toggle-nightlight"),                  { description = "󰖔 Toggle Nightlight" })
hl.bind(MAIN_MOD .. " + SHIFT + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/change-wallpaper.sh"),           { description = " Change Wallpaper" })

-- Monitor diagnostics
hl.bind("SUPER + CTRL + SHIFT + M", monitors.monitor_status, { description = "󰍺 Show Monitor Status" })

----------------------------------
---- MEDIA -----------------------
----------------------------------

-- Volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"),      { description = "󰝝 Volume Up",        locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"),      { description = "󰝞 Volume Down",      locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"),{ description = "󰝟 Mute Toggle",      locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"), { description = "󰍭 Mic Mute Toggle",  locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness raise"), { description = "󰛨 Brightness Up",   locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"), { description = "󰹏 Brightness Down", locked = true, repeating = true })

-- Playback (requires playerctl)
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { description = "󰐎 Play/Pause", locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { description = "󰐎 Pause",      locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { description = "󰒭 Next Track",  locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { description = "󰒮 Prev Track",  locked = true })

----------------------------------
---- DEBUG -----------------------
----------------------------------

hl.bind("SUPER + ALT + G", hl.dsp.exec_cmd("bash -c 'printenv USER_LIB_DIR > /tmp/hypr-env-test.txt'"))
