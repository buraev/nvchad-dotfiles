-- Was `require "nvchad.options"`; inlined so the config no longer depends on
-- NvChad for its editor defaults. Values kept identical to NvChad v2.5.
local opt = vim.opt
local g = vim.g

vim.o.laststatus = 3
vim.o.showmode = false
vim.o.splitkeep = "screen"

vim.o.clipboard = "unnamedplus"
vim.o.cursorline = true
vim.o.cursorlineopt = "number" -- overridden to "both" further down

-- Indenting
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2

opt.fillchars = { eob = " " }
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.mouse = "a"

-- Numbers
vim.o.number = true
vim.o.numberwidth = 2
vim.o.ruler = false

-- disable nvim intro
opt.shortmess:append "sI"

vim.o.signcolumn = "yes"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.timeoutlen = 400
vim.o.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
vim.o.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH

-- local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
-- for type, icon in pairs(signs) do
-- 	local hl = "DiagnosticSign" .. type
-- 	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
-- end
-- add yours here!

local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!

vim.opt.relativenumber = true

require("luasnip.loaders.from_vscode").lazy_load { paths = "~/.config/nvim/snippets" }

local sign_column_hl = vim.api.nvim_get_hl(0, { name = "SignColumn" })

-- "bg" here would mean "Normal's background", which does not exist when
-- base46 transparency is on -- nvim_set_hl then errors out and aborts init
local sign_column_bg = (sign_column_hl.bg ~= nil) and ("#%06x"):format(sign_column_hl.bg) or "NONE"
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
