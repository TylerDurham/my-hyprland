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
local MAIN_MOD = g.keybinds.MAIN_MOD -- Sets "Windows" key as main modifier
local TERMINAL = g.programs.TERMINAL
local APP_LAUNCHER = g.programs.APP_LAUNCHER
local FILE_MANAGER = g.programs.FILE_MANAGER
local BROWSER = g.programs.BROWSER
local NOTES = g.programs.NOTES

local monitors = require("modules.monitors")

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more

----------------------
---- APP KEYBINDS ----
----------------------

hl.bind(
  MAIN_MOD .. " + Return",
  hl.dsp.exec_cmd(TERMINAL),
  { description = " Launch Terminal App (" .. TERMINAL .. ")" }
)
hl.bind(
  MAIN_MOD .. " + Space",
  hl.dsp.exec_cmd(APP_LAUNCHER),
  { description = "󱓞 Launch App Launcer (" .. APP_LAUNCHER .. ")" }
)
hl.bind(MAIN_MOD .. " + B", hl.dsp.exec_cmd(BROWSER), { description = "󰖟 Launch Web Browser (" .. BROWSER .. ")" })
hl.bind(MAIN_MOD .. " + Q", hl.dsp.window.close(), { description = "󰅗 Close Current Window" })
hl.bind(
  MAIN_MOD .. " + E",
  hl.dsp.exec_cmd(FILE_MANAGER),
  { description = " Launch File Manager (" .. FILE_MANAGER .. ")" }
)
hl.bind(MAIN_MOD .. " + N", hl.dsp.exec_cmd(NOTES), { description = "󰠮 Launch Notes (" .. NOTES .. ")" })
hl.bind(
  MAIN_MOD .. " + K",
  hl.dsp.exec_cmd("~/.local/bin/hypr-show-keybinds"),
  { description = "󰌌 Show/Search Hyprland Keybinds" }
)

hl.bind(MAIN_MOD .. " + SHIFT + N", hl.dsp.exec_cmd("~/.local/bin/hypr-toggle-nightlight"), { description = "󰖔 Toggle Nightlight on/off." })

----------------------------
---- WORKSPACE KEYBINDS ----
----------------------------
-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(MAIN_MOD .. " + " .. key, hl.dsp.focus({ workspace = i }), { description = "󰖯 Go to Workspace " .. i })
  hl.bind(
    MAIN_MOD .. " + SHIFT + " .. key,
    hl.dsp.window.move({ workspace = i }),
    { description = "󰖲 Move Window to Workspace " .. i }
  )
end

-- Move workspaces to monitors
hl.bind("SUPER + SHIFT + LEFT", hl.dsp.workspace.move({ monitor = "+1" }), { description = " 󰛽 Move current workspace to monitor on left." })
hl.bind("SUPER + SHIFT + RIGHT", hl.dsp.workspace.move({ monitor = "-1" }), { description = " 󰛾 Move current workspae to monitor on right." })

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(MAIN_MOD .. " + mouse:272", hl.dsp.window.drag(), { description = "🖱️ Move window." })
hl.bind(MAIN_MOD .. " + SHIFT + mouse:272", hl.dsp.window.resize(), { description = "🖱️ Resize window." })

hl.bind(MAIN_MOD .. " + bracketright", function()
    hl.dsp.window.cycle_next({ "e+1", 'scrolling'})
end, { description = "Cycle/move to the next non-empty window."})

hl.bind(MAIN_MOD .. " + bracketright", function()
end, { description = "Cycle/move to the previous non-empty window."})

hl.bind(MAIN_MOD .. " + SHIFT + bracketright", function()
    hl.dispatch(hl.dsp.focus({ workspace = "e+1" }))
end, { description = "Cycle/move to the next non-empty workspace."})

hl.bind(MAIN_MOD .. "+ SHIFT + bracketleft", function()
    hl.dispatch(hl.dsp.focus({ workspace = "e-1" }))
end, { description = "Cycle/move to the previous non-empty workspace."})

-----------------------
---- MEDIA/ETC. KEYBINDS ----
-----------------------------

hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("swayosd-client --output-volume raise"),
  { description = "󰝝 Raise the Media/Audio Volume", locked = true, repeating = true }
)
hl.bind(
  "XF86AudioLowerVolume",
  hl.dsp.exec_cmd("swayosd-client --output-volume lower"),
  { description = "󰝞 Lower the Media/Audio Volume", locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMute",
  hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"),
  { description = "󰝟 Mute the Media/Audio Volume", locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMicMute",
  hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"),
  { description = "󰍭 Mute the Input/Microphone Volume", locked = true, repeating = true }
)
hl.bind(
  "XF86MonBrightnessUp",
  hl.dsp.exec_cmd("swayosd-client --brightness raise"),
  { description = "󰛨 Increase Screen Brightness", locked = true, repeating = true }
)
hl.bind(
  "XF86MonBrightnessDown",
  hl.dsp.exec_cmd("swayosd-client --brightness lower"),
  { description = "󰹏 Decrease Screen Brightness", locked = true, repeating = true }
)

-- Requires playerctl
hl.bind(
  "XF86AudioNext",
  hl.dsp.exec_cmd("playerctl next"),
  { description = "󰒭 Next Media/Audio Track", locked = true }
)
hl.bind(
  "XF86AudioPause",
  hl.dsp.exec_cmd("playerctl play-pause"),
  { description = "󰐎 Pause Media/Audio Track", locked = true }
)
hl.bind(
  "XF86AudioPlay",
  hl.dsp.exec_cmd("playerctl play-pause"),
  { description = "󰐎 Play Media/Audio Track", locked = true }
)
hl.bind(
  "XF86AudioPrev",
  hl.dsp.exec_cmd("playerctl previous"),
  { description = "󰒮 Previous Media/Audio Track", locked = true }
)

hl.bind("SUPER + ALT + G", hl.dsp.exec_cmd("bash -c 'printenv USER_LIB_DIR > /tmp/hypr-env-test.txt'"))

