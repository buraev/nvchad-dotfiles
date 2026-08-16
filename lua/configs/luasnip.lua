-- Ported from NvChad v2.5 (nvchad/configs/luasnip.lua) so the config owns its own plugin setup.
-- Copied byte for byte; the Nerd Font glyphs below are the originals.

-- vscode format
require("luasnip.loaders.from_vscode").lazy_load { exclude = vim.g.vscode_snippets_exclude or {} }
require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.vscode_snippets_path or "" }

-- This config's own snippets, if it grows any. Was called from options.lua on
-- an unconditional path, which both loaded LuaSnip early and pointed at a
-- directory that is not there; guard it and keep it next to the other loaders.
local snippets = vim.fn.stdpath "config" .. "/snippets"
if vim.uv.fs_stat(snippets) then
  require("luasnip.loaders.from_vscode").lazy_load { paths = snippets }
end

-- snipmate format
require("luasnip.loaders.from_snipmate").load()
require("luasnip.loaders.from_snipmate").lazy_load { paths = vim.g.snipmate_snippets_path or "" }

-- lua format
require("luasnip.loaders.from_lua").load()
require("luasnip.loaders.from_lua").lazy_load { paths = vim.g.lua_snippets_path or "" }

-- fix luasnip #258
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    if
      require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
      and not require("luasnip").session.jump_active
    then
      require("luasnip").unlink_current()
    end
  end,
})
