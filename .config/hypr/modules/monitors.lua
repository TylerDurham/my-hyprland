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

M = {
	config = {
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
	},
	get_ref_by_desc = function(desc)
		local description = str.trim(str.substr_after("desc:", desc))
		for _, monitor in ipairs(hl.get_monitors()) do
			if monitor.description == description then
				return monitor
			end
		end
		return nil
	end,
	get_ref = function(monitor)
		return M.get_ref_by_desc(monitor.output)
	end,
	right = function()
		return M.get_ref(M.config.right)
	end,
	left = function()
		return M.get_ref(M.config.right)
	end,
}

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

return M
