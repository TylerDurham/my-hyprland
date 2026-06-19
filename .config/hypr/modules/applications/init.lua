require("modules.applications.1password")
require("modules.applications.system")
require("modules.applications.plex")

-- local config_dir = os.getenv("HOME") .. ".config/hypr/modules/applications"
--
-- for file in io.popen('ls "' .. config_dir .. '"/*.lua 2>/dev/null'):lines() do
--   local basename = file:match("([^/]+)%.lua$")
--
--   if basename ~= "init" then
--     local func, err  = require(file)
--     if func then
--       func()
--     else
--       hl.notification("Error loading " .. basename .. ": " .. err)
--     end
--   end
-- end
--
--
