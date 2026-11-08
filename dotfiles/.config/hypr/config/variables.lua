-- Hyprland default apps

TERMINAL     = "kitty"
FILE_MANAGER = "nautilus"
BROWSER      = "brave"
EDITOR       = "gnome-text-editor --new-window"
CALCULATOR   = "gnome-calculator"

-- Monitors
-- Left to right. External monitors are matched by description so they keep
-- their settings regardless of which port/dock connector they land on.
MONITOR1 = "eDP-1"                                     -- laptop panel (left)
MONITOR2 = "desc:Dell Inc. DELL S2725QS 7DCMT84"       -- Dell (middle)
MONITOR3 = "desc:BNQ BenQ RD280UG EMF6T00620087"       -- BenQ (right)
PRIMARY_MONITOR = MONITOR3

-- Workspaces
NUM_WPM = 10 -- Number of workspaces per monitor (Max 10)
