-- #############################################################################
--
--  █████╗ ██╗   ██╗████████╗ ██████╗ ███████╗████████╗ █████╗ ██████╗ ████████╗
-- ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝
-- ███████║██║   ██║   ██║   ██║   ██║███████╗   ██║   ███████║██████╔╝   ██║
-- ██╔══██║██║   ██║   ██║   ██║   ██║╚════██║   ██║   ██╔══██║██╔══██╗   ██║
-- ██║  ██║╚██████╔╝   ██║   ╚██████╔╝███████║   ██║   ██║  ██║██║  ██║   ██║
-- ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝
-- #############################################################################

hl.on("hyprland.start", function()
  hl.exec_cmd("/usr/lib/gnome-keyring-daemon --start --components=secrets")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("hyprsunset")
  -- hl.exec_cmd("nm-applet --indicator")
  hl.exec_cmd("awww-daemon")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  hl.exec_cmd("swaync")
  hl.exec_cmd("swayosd-server")
  hl.exec_cmd("waybar") -- Execute waybar, hyprpaper, firefox
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("awww img ~/.config/my/background")
end)
