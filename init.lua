vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- Colours before plugins: see lua/theme/init.lua for why it also re-applies
-- itself after each plugin loads.
require("theme").setup()

-- load plugins
require("lazy").setup({
  { import = "plugins" },
}, lazy_config)

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)
