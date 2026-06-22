
local monitors = require("modules.monitors")
local right_monitor = monitors.right()
local left_monitor = monitors.left()

if right_monitor ~= nil then
	for i = 1, 5 do
		hl.workspace_rule({ workspace = tostring(i), monitor = right_monitor.name, default = (i == 1), persistent = true })
	end
end

if left_monitor ~= nil then
	for i = 9, 10 do
		hl.workspace_rule({ workspace = tostring(i), monitor = left_monitor.name, default = (i == 9), persistent = true })
	end
end

-- When the dock monitor is removed, close any workspaces that aren't in the
-- known set (1-5, 9-10) so they don't pile up on the primary monitor.
local known_workspaces = { [1]=true,[2]=true,[3]=true,[4]=true,[5]=true,[9]=true,[10]=true }

hl.on("monitor.removed", function()
	for _, ws in ipairs(hl.get_workspaces()) do
    hl.notification.create({
      text = "Orphaned workspace: " .. tostring(ws.id),
      timeout = 3000
    })
		-- if not known_workspaces[ws.id] then
		-- 	hl.dispatch(hl.dsp.workspace.close({ workspace = tostring(ws.id) }))
		-- end
	end
end)

