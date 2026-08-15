-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "atom-one-dark", -- lua/themes/atom-one-dark.lua
  theme_toggle = { "atom-one-dark", "one_light" },

  -- background comes from the terminal; set this to false to get
  -- Atom One Dark's own #282c34 instead
  transparency = true,

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
    DiffChange = {
      --	bg = "#464414",
      -- fg = "none",
    },
    DiffAdd = {
      --bg = "#103507",
      --	fg = "none",
    },
    DiffRemoved = {
      --	bg = "#461414",
      --	fg = "none",
    },
  },
}

M.ui = {
  statusline = {
    theme = "vscode_colored",
  },

  -- bufferline.nvim draws the buffer line now; see configs/bufferline.lua
  tabufline = {
    enabled = false,
  },
}

M.nvdash = {
  -- no NvChad dashboard on startup, open straight into an empty buffer
  load_on_startup = false,
}

return M
