-- Atom One Dark, applied directly.
--
-- This replaces base46, which used to compile a theme into a bytecode cache per
-- plugin integration and `dofile` the pieces at various points during startup.
-- The groups it produced were captured once and now live in theme/groups.lua,
-- so there is no generation step and no cache: the colours are just data.

local M = {}

function M.load()
  vim.o.termguicolors = true
  vim.o.background = "dark"
  vim.g.colors_name = "atom-one-dark"

  local set = vim.api.nvim_set_hl
  for name, spec in pairs(require "theme.groups") do
    set(0, name, spec)
  end
end

function M.setup()
  -- Early, because plugin `config` functions read colours back out of the
  -- highlight table: configs/lualine reads St_*, configs/bufferline reads Tb*.
  M.load()

  -- Late, and again after every plugin: some plugins define groups the theme
  -- also defines, and whoever writes last wins. indent-blankline re-adds the
  -- scope underline this theme deliberately removes, telescope links
  -- TelescopeNormal that the theme leaves clear. base46 dealt with this by
  -- re-loading its cache after each plugin's setup; this is the same idea, only
  -- generic. lazy fires LazyLoad after the plugin's config has run, and a full
  -- re-apply of all 1745 groups measures 0.3 ms, so the cost does not matter.
  vim.api.nvim_create_autocmd("User", {
    pattern = { "LazyLoad", "LazyDone" },
    group = vim.api.nvim_create_augroup("ThemeReapply", { clear = true }),
    callback = function()
      M.load()
    end,
  })
end

return M
