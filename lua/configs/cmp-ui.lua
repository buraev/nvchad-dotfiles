-- Ported from NvChad v2.5 (ui/nvchad/cmp/{init,format}.lua), merged into one
-- file. The `nvconfig` lookups became the literal defaults NvChad shipped:
-- style "default", icons on the right, abbr capped at 60, LSP colour swatches on.

local cmp_ui = {
  icons_left = false,
  style = "default",
  abbr_maxwidth = 60,
  format_colors = { lsp = true, icon = "󱓻" },
}

local api = vim.api
local icon = cmp_ui.format_colors.icon .. " "

local hlcache = {}

local function format_color_lsp(entry, item, kind_txt)
  local color = entry.completion_item.documentation

  if color and type(color) == "string" and color:match "^#%x%x%x%x%x%x$" then
    local hl = "hex-" .. color:sub(2)

    if not hlcache[hl] then
      api.nvim_set_hl(0, hl, { fg = color })
      hlcache[hl] = true
    end

    item.kind = ((cmp_ui.icons_left and icon) or (" " .. icon)) .. kind_txt
    item.kind_hl_group = hl
    item.menu_hl_group = hl
  end
end

local cmp_style = cmp_ui.style

local atom_styled = cmp_style == "atom" or cmp_style == "atom_colored"
local fields = (atom_styled or cmp_ui.icons_left) and { "kind", "abbr", "menu" } or { "abbr", "kind", "menu" }

local M = {
  formatting = {
    format = function(entry, item)
      local icons = require "icons.lspkind"
      local icon = icons[item.kind] or ""
      local kind = item.kind or ""

      if atom_styled then
        item.menu = kind
        item.menu_hl_group = "LineNr"
        item.kind = " " .. icon .. " "
      elseif cmp_ui.icons_left then
        item.menu = kind
        item.menu_hl_group = "CmpItemKind" .. kind
        item.kind = icon
      else
        item.kind = " " .. icon .. " " .. kind
        item.menu_hl_group = "comment"
      end

      if kind == "Color" and cmp_ui.format_colors.lsp then
        format_color_lsp(entry, item, (not (atom_styled or cmp_ui.icons_left) and kind) or "")
      end

      if #item.abbr > cmp_ui.abbr_maxwidth then
        item.abbr = string.sub(item.abbr, 1, cmp_ui.abbr_maxwidth) .. "…"
      end

      return item
    end,

    fields = fields,
  },

  window = {
    completion = {
      scrollbar = false,
      side_padding = atom_styled and 0 or 1,
      winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None,FloatBorder:CmpBorder",
      border = atom_styled and "none" or "single",
    },

    documentation = {
      border = "single",
      winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder",
    },
  },
}

return M
