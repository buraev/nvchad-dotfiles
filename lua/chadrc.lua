-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.ui = {
	theme = "Onedark",
	transparency = true,
	statusline = {
		theme = "vscode_colored",
	},
	nvdash = {
		load_on_startup = true,
	},

	hl_override = {
		Comment = { italic = true },
		["@comment"] = { italic = true },
		DiffChange = {
			bg = "#464414",
			fg = "none",
		},
		DiffAdd = {
			bg = "#103507",
			fg = "none",
		},
		DiffRemoved = {
			bg = "#461414",
			fg = "none",
		},
	},

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },
}

return M
