-- ###################################################################
--
-- ███╗   ███╗ ██████╗ ███╗   ██╗██╗████████╗ ██████╗ ██████╗ ███████╗
-- ████╗ ████║██╔═══██╗████╗  ██║██║╚══██╔══╝██╔═══██╗██╔══██╗██╔════╝
-- ██╔████╔██║██║   ██║██╔██╗ ██║██║   ██║   ██║   ██║██████╔╝███████╗
-- ██║╚██╔╝██║██║   ██║██║╚██╗██║██║   ██║   ██║   ██║██╔══██╗╚════██║
-- ██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██║   ██║   ╚██████╔╝██║  ██║███████║
-- ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝
-- ###################################################################

local str = require("modules.lib.strings")

local M = {}

M.config = {
	right = {
		output = "desc:LG Electronics LG ULTRAGEAR 404MXCR52499",
		mode = "2560x1440@120.0",
		position = "1924x0",
		scale = 1.33,
	},
	left = {
		output = "desc:Dell Inc. DELL S2725QS 7DCMT84",
		mode = "2560x1440@120.0",
		position = "0x0",
		scale = 1.33,
	},
}

M.get_ref_by_desc = function(desc)
	local description = str.trim(str.substr_after("desc:", desc))
	for _, monitor in ipairs(hl.get_monitors()) do
		if monitor.description == description then
			return monitor
		end
	end
	return nil
end

M.get_ref = function(monitor)
	return M.get_ref_by_desc(monitor.output)
end

M.right = function()
	return M.get_ref(M.config.right)
end

M.left = function()
	return M.get_ref(M.config.left)
end

if M.config ~= nil then
	local right_monitor = M.config.right
	local left_monitor = M.config.left

	if right_monitor ~= nil then
		hl.monitor(right_monitor)
	end
	if left_monitor ~= nil then
		hl.monitor(left_monitor)
	end
end

M.monitor_status = function()
	local r_monitor = M.right()
	local l_monitor = M.left()

	local buffer = {}
  table.insert(buffer, "RIGHT MONITOR")
  table.insert(buffer, "\tID: " .. r_monitor.id)
	table.insert(buffer, "\tNAME: " .. r_monitor.name)
	table.insert(buffer, "\tDESCRIPTION: " .. r_monitor.description)
  table.insert(buffer, "")
  table.insert(buffer, "LEFT MONITOR")
	table.insert(buffer, "\tID: " .. l_monitor.id)
	table.insert(buffer, "\tNAME: " .. l_monitor.name)
	table.insert(buffer, "\tDESCRIPTION: " .. l_monitor.description)

	hl.notification.create({
		text = table.concat(buffer, "\n"),
    timeout = 5000
	})
end

return M
