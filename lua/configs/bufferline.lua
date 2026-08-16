-- Replaces NvChad's tabufline. The colours are not hardcoded here: they are
-- read back from the Tb* highlight groups the theme defines, so
-- lua/themes/atom-one-dark.lua stays the single place tab colours live.
--
-- Backgrounds come out as "NONE" because base46 transparency is on, which is
-- what the terminal background is supposed to show through.

local M = {}

local function group(name)
  local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
  return {
    fg = hl.fg and ("#%06x"):format(hl.fg) or "NONE",
    bg = hl.bg and ("#%06x"):format(hl.bg) or "NONE",
  }
end

function M.setup()
  local fill = group "TbFill"
  local on, off = group "TbBufOn", group "TbBufOff"
  local on_mod, off_mod = group "TbBufOnModified", group "TbBufOffModified"
  local on_close, off_close = group "TbBufOnClose", group "TbBufOffClose"
  local tab_on, tab_off, tab_close = group "TbTabOn", group "TbTabOff", group "TbTabCloseBtn"

  require("bufferline").setup {
    options = {
      mode = "buffers",
      separator_style = "slope",
      -- tabufline stayed hidden while a single buffer was open
      always_show_bufferline = false,
      show_close_icon = false,
      offsets = {
        {
          filetype = "NvimTree",
          text = "",
          highlight = "Directory",
          separator = true,
        },
      },
    },

    highlights = {
      fill = fill,

      background = off,
      buffer_visible = off,
      buffer_selected = { fg = on.fg, bg = on.bg, bold = false, italic = false },

      modified = off_mod,
      modified_visible = off_mod,
      modified_selected = on_mod,

      close_button = off_close,
      close_button_visible = off_close,
      close_button_selected = on_close,

      separator = { fg = fill.bg, bg = off.bg },
      separator_visible = { fg = fill.bg, bg = off.bg },
      separator_selected = { fg = fill.bg, bg = on.bg },

      indicator_selected = { fg = on.fg, bg = on.bg },
      indicator_visible = off,

      tab = tab_off,
      tab_selected = tab_on,
      tab_close = tab_close,
      tab_separator = { fg = fill.bg, bg = tab_off.bg },
      tab_separator_selected = { fg = fill.bg, bg = tab_on.bg },

      duplicate = off,
      duplicate_visible = off,
      duplicate_selected = { fg = on.fg, bg = on.bg, italic = false },

      trunc_marker = off,
      offset_separator = { fg = fill.bg, bg = fill.bg },
    },
  }
end

return M
