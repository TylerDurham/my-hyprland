``` figlet
  __  __                 _   _                  _                 _ 
 |  \/  |_   _          | | | |_   _ _ __  _ __| | __ _ _ __   __| |
 | |\/| | | | |  _____  | |_| | | | | '_ \| '__| |/ _` | '_ \ / _` |
 | |  | | |_| | |_____| |  _  | |_| | |_) | |  | | (_| | | | | (_| |
 |_|  |_|\__, |         |_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_|
         |___/                 |___/|_|                             
```
<div align="center">
  <img src="https://github.com/TylerDurham/my-hyprland/blob/master/media/wayland.png?raw=true" height="200"/>
  <img src="https://github.com/TylerDurham/my-hyprland/blob/master/media/hyprland.png?raw=true" height="200"/>
</div> 

---

My [Hyprland](https://hyprland.org/) desktop configuration recently updated to take advantage of 
Hyprland 0.55's [Lua configuration](https://wiki.hypr.land/Configuring/Start). 

This started out as my minimal extra configuration for the wonderful [Omarchy](https://omarchy.org), but when I moved to NixOs, I had to expand a bit.

<div align="center">***Terminal running btop***</div>
<div align="center">
  <img src="https://github.com/TylerDurham/my-hyprland/blob/master/media/terminal-btop.png?raw=true" width="600"/>
</div>


<div align="center">***Hyperlock Screen***</div>
<div align="center">
  <img src="https://github.com/TylerDurham/my-hyprland/blob/master/media/hyprlock.png?raw=true" width="600"/>
</div>

## Features

- **Lua-based modular config** — each concern (keybinds, monitors, look & feel, windows, workspaces) lives in its own file under `.config/hypr/modules/`
- **6 complete themes** — Lovely Day, Hackerman, Catppuccin, Matte Black, Osaka Jade, Everforest — each with matched colors for Waybar, Rofi, VSCode, Neovim, and more
- **Searchable keybinds** — press `SUPER + K` to fuzzy-search every keybind in Rofi
- **Dual-monitor workspace layout** — workspaces 1–5 on the right monitor, 9–10 on the left
- **Touchpad gestures** — 3-finger swipe to scroll windows or switch workspaces, 4-finger pinch to fullscreen
- **Night light** — automatic warm color temperature at sunset via `hyprsunset` (toggle with `SUPER + SHIFT + N`)
- **Interactive wallpaper picker** — browse and set wallpapers with thumbnail previews via Rofi (`SUPER + SHIFT + W`); supports recursive directory selection
- **System control menu** — lock, suspend, logout, reboot, or shutdown from a Rofi icon grid (`SUPER + SHIFT + S`)
- **OSD feedback** — volume, microphone, and brightness overlays via `swayosd`
- **Auto-idle + lock** — brightness dims at 5 min, screen locks at 10 min, display off at 15 min
- **Clipboard history** — persistent clipboard via `cliphist` + `wl-paste`

---

## Screenshots

| Theme | Preview |
|-------|---------|
| Lovely Day | `.local/share/my/themes/lovely-day/backgrounds/` |
| Hackerman | `.local/share/my/themes/hackerman/backgrounds/` |
| Catppuccin | `.local/share/my/themes/catppuccin/backgrounds/` |
| Matte Black | `.local/share/my/themes/matte-black/backgrounds/` |
| Osaka Jade | `.local/share/my/themes/osaka-jade/backgrounds/` |
| Everforest | `.local/share/my/themes/everforest/backgrounds/` |

---

## Dependencies

### Required

| Package | Purpose |
|---------|---------|
| `hyprland` | Wayland compositor |
| `hyprlock` | Lock screen |
| `hypridle` | Idle daemon |
| `hyprsunset` | Night light |
| `waybar` | Status bar |
| `rofi` | App launcher + keybind search |
| `swaync` | Notification daemon |
| `swayosd` | Volume / brightness OSD |
| `ghostty` | Terminal emulator |
| `brave` | Browser |
| `nautilus` | File manager |
| `obsidian` | Notes |
| `playerctl` | Media key control |
| `jq` | JSON parsing (used by keybind scripts) |
| `swww` | Wallpaper daemon |
| `cliphist` | Clipboard history |
| `wl-clipboard` | Wayland clipboard (`wl-paste`) |
| `imagemagick` | Image processing (wallpaper + screenshots) |
| `hyprpolkitagent` | Authentication agent |
| `gnome-keyring` | Secrets manager |

## Optional Dependancies

| Name                                                      | Description             |
|-----------------------------------------------------------|-------------------------|
| [my-shell](https://github.com/TylerDurham/my-shell)       | My `shell` dotfiles.    |
| [my-hyprland](https://github.com/TylerDurham/my-nixos)    | My `NixOS` dotfiles. |
| [my-neovim](https://github.com/TylerDurham/my-neovim)     | My `NeoVim` dotfiles.   |


| Package | Purpose |
|---------|---------|
| Nerd Fonts (JetBrainsMono) | Required by Rofi and Waybar themes |

---

## Installation

> These are dotfiles — stow or symlink them into your home directory. No installer script exists yet; manual placement is straightforward.

**1. Clone the repo**

```bash
git clone https://github.com/TylerDurham/my-hyprland.git
cd my-hyprland
```

**2. Copy (or symlink) config files into `$HOME`**

```bash
# Using GNU stow (recommended)
stow --target="$HOME" .

# Or copy manually
cp -r .config .local ~
```

**3. Ensure the custom scripts are executable**

```bash
chmod +x ~/.local/share/my/bin/hypr-*
```

**4. Add the scripts to your PATH**

The Hyprland config automatically prepends `~/.local/share/my/bin` to `$PATH`. To use the scripts outside of Hyprland, add this to your shell profile:

```bash
export PATH="$HOME/.local/share/my/bin:$PATH"
export MY_LIB_DIR="$HOME/.local/share/my/lib"
```

**5. Set an active theme**

```bash
hypr-set-current-theme lovely-day   # or hackerman, catppuccin, matte-black, osaka-jade, everforest
```

**6. Install web apps (optional)**

Installs a curated set of web apps (Excalidraw, Logos, Gitea, GitHub, Claude.ai) as standalone browser-backed desktop entries:

```bash
./install-webapps.sh
```

**7. Start Hyprland**

```bash
Hyprland
```

---

## Keybinds

> Press **`SUPER + K`** at any time to search keybinds interactively in Rofi.

### Applications

| Keybind | Action |
|---------|--------|
| `SUPER + Return` | Open terminal (Ghostty) |
| `SUPER + Space` | Open app launcher (Rofi) |
| `SUPER + B` | Open browser (Brave) |
| `SUPER + E` | Open file manager (Nautilus) |
| `SUPER + N` | Open notes (Obsidian) |
| `SUPER + K` | Search keybinds |
| `SUPER + Q` | Close focused window |

### System / Theme

| Keybind | Action |
|---------|--------|
| `SUPER + SHIFT + N` | Toggle night light |
| `SUPER + SHIFT + S` | Open system control menu (lock, suspend, logout, reboot, shutdown) |
| `SUPER + SHIFT + W` | Select and set wallpaper |

### Workspace Navigation

| Keybind | Action |
|---------|--------|
| `SUPER + 1–9` | Switch to workspace |
| `SUPER + [` | Cycle to next non-empty window |
| `SUPER + SHIFT + [` | Next non-empty workspace |
| `SUPER + SHIFT + ]` | Previous non-empty workspace |

### Window Management

| Keybind | Action |
|---------|--------|
| `SUPER + SHIFT + 1–9` | Move window to workspace |
| `SUPER + SHIFT + ←` | Move workspace to left monitor |
| `SUPER + SHIFT + →` | Move workspace to right monitor |
| `SUPER + LMB drag` | Move window |
| `SUPER + SHIFT + LMB drag` | Resize window |

### Media Keys

| Key | Action |
|-----|--------|
| `XF86AudioRaiseVolume` | Volume up |
| `XF86AudioLowerVolume` | Volume down |
| `XF86AudioMute` | Toggle mute |
| `XF86AudioMicMute` | Toggle mic mute |
| `XF86MonBrightnessUp` | Brightness up |
| `XF86MonBrightnessDown` | Brightness down |
| `XF86AudioNext` | Next track |
| `XF86AudioPlay` | Play / Pause |
| `XF86AudioPrev` | Previous track |

### Touchpad Gestures

| Gesture | Action |
|---------|--------|
| 3-finger swipe left/right | Scroll / move windows |
| 3-finger swipe left/right + SHIFT | Switch workspaces |
| 3-finger swipe down + ALT | Close window |
| 4-finger pinch out | Toggle fullscreen |

---

## Themes

Themes live under `.local/share/my/themes/`. Each theme contains:

```
theme-name/
├── backgrounds/       # Wallpaper variants
├── colors.toml        # Color palette (accent, background, foreground, …)
├── icons.theme        # Icon set
├── btop.theme         # btop system monitor
├── neovim.lua         # Neovim colorscheme
├── vscode.json        # VS Code theme
├── waybar.css         # Waybar stylesheet
└── rofi.rasi          # Rofi stylesheet (where applicable)
```

**Switch themes at runtime:**

```bash
hypr-set-current-theme <theme-name>
```

This updates the wallpaper, color symlinks, and restarts Waybar and SwayOSD automatically.

---

## Project Structure

```
.
├── .config/
│   ├── hypr/
│   │   ├── hyprland.lua          # Main entry point
│   │   ├── hypridle.conf         # Idle / lock timeouts
│   │   ├── hyprlock.conf         # Lock screen appearance
│   │   ├── hyprsunset.conf       # Night light schedule
│   │   └── modules/
│   │       ├── autostart.lua     # Startup applications
│   │       ├── globals.lua       # Default programs and modifier key
│   │       ├── keybinds.lua      # All keyboard bindings
│   │       ├── layouts.lua       # Tiling layout config
│   │       ├── looknfeel.lua     # Gaps, borders, blur, animations
│   │       ├── monitors.lua      # Monitor layout and scaling
│   │       ├── windows.lua       # Window rules and floats
│   │       ├── workspaces.lua    # Workspace-to-monitor assignment
│   │       └── applications/     # Per-app window rules
│   ├── rofi/                     # Rofi launcher themes and modules
│   │   └── modules/              # JSON module definitions (system, etc.)
│   └── swayosd/                  # OSD styling
└── .local/share/my/
    ├── bin/                      # Custom shell scripts
    ├── lib/                      # Shared bash libraries
    └── themes/                   # Color themes
```

---

## Customisation

Default programs are defined in `.config/hypr/modules/globals.lua`:

```lua
g.programs = {
  TERMINAL     = "ghostty",
  FILE_MANAGER = "nautilus",
  APP_LAUNCHER = "~/.local/share/my/bin/hypr-launch-applications",
  BROWSER      = "brave",
  NOTES        = "obsidian",
}

g.keybinds = {
  MAIN_MOD = "SUPER",
}
```

---

## License

MIT
