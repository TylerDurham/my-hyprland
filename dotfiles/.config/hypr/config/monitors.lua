-- Monitor wiki https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Outputs are defined in variables.lua. Positions are in logical pixels
-- (mode / scale), laid out left to right:
--
--   laptop (1440x960)  |  Dell (1920x1080)  |  BenQ (1920x1280)
--   x = 0                 x = 1440             x = 3360

-- Laptop panel: 2880x1920 / 2 = 1440x960
hl.monitor({
    output   = MONITOR1,
    mode     = "2880x1920@120",
    position = "0x0",
    scale    = 2,
})

-- Dell S2725QS: 2560x1440 / 1.333333 = 1920x1080
hl.monitor({
    output   = MONITOR2,
    mode     = "2560x1440@120",
    position = "1440x0",
    scale    = 1.333333,
})

-- BenQ RD280UG: 3840x2560 / 2 = 1920x1280
-- Note: currently lands at ~100Hz instead of 120Hz (likely dock bandwidth
-- shared with the Dell at 1440p@120).
hl.monitor({
    output   = MONITOR3,
    mode     = "3840x2560@119.99",
    position = "3360x0",
    scale    = 2,
})

-- Fallback for anything else (projectors, other displays)
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})
