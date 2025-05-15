require("nvchad.options")

-- local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
-- for type, icon in pairs(signs) do
-- 	local hl = "DiagnosticSign" .. type
-- 	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
-- end
-- add yours here!

local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!

vim.opt.relativenumber = true

require("luasnip.loaders.from_vscode").lazy_load({ paths = "~/.config/nvim/snippets" })

local sign_column_hl = vim.api.nvim_get_hl(0, { name = "SignColumn" })

local sign_column_bg = (sign_column_hl.bg ~= nil) and ("#%06x"):format(sign_column_hl.bg) or "bg"
local sign_column_ctermbg = (sign_column_hl.ctermbg ~= nil) and sign_column_hl.ctermbg or "Black"

vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = sign_column_ctermbg, fg = "#8BE9FD", bg = sign_column_bg })
vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = sign_column_ctermbg, fg = "#F1FA8C", bg = sign_column_bg })
vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = sign_column_ctermbg, fg = "#FF5555", bg = sign_column_bg })

vim.fn.sign_define(
	"DapBreakpoint",
	{ text = "󰻃", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
	"DapBreakpointCondition",
	{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
	"DapBreakpointRejected",
	{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
	"DapLogPoint",
	{ text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
)
vim.fn.sign_define("DapStopped", {
	text = "",
	texthl = "DapStopped",
	linehl = "DapStopped",
	numhl = "DapStopped",
})

-- Diffview colour
vim.api.nvim_set_hl(0, "DiffviewDiffText", { bg = "#432004", fg = "#efb100" })
