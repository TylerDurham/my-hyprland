
local monitors = require("modules.monitors")
local right_monitor = monitors.right()
local left_monitor = monitors.left()

if right_monitor ~= nil then
	for i = 1, 5 do
		hl.workspace_rule({ workspace = tostring(i), monitor = right_monitor.name, default = true })
	end
end

if left_monitor ~= nil then
	for i = 9, 10 do
		hl.workspace_rule({ workspace = tostring(i), monitor = left_monitor.name, default = true })
	end
end

