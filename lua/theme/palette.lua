-- Colour palette for the Atom One Dark port, lifted verbatim (comments and
-- all) from the base46 theme file this config used to carry. It is the single
-- place a colour is named; lua/theme/groups.lua refers to these by name.

local M = {}

M.base_30 = {
  white = "#abb2bf", -- editor.foreground
  darker_black = "#21252b", -- sideBar.background
  black = "#282c34", -- editor.background
  black2 = "#21252b", -- editorGroupHeader.tabsBackground
  one_bg = "#2c313a", -- list.activeSelectionBackground
  one_bg2 = "#333842", -- activityBar.background
  one_bg3 = "#3a3f4b", -- editorWidget.border
  grey = "#636d83", -- editorLineNumber.foreground
  grey_fg = "#5c6370", -- comment
  grey_fg2 = "#828997", -- source.css property-name
  light_grey = "#5c6370", -- comment
  red = "#e06c75", -- variable, entity.name.tag
  baby_pink = "#e06c75",
  pink = "#be5046", -- variable.interpolation
  line = "#3c4049", -- editorIndentGuide.background (#abb2bf26 on bg)
  green = "#98c379", -- string
  vibrant_green = "#98c379",
  nord_blue = "#528bff", -- editorCursor.foreground / focusBorder
  blue = "#61afef", -- entity.name.function
  yellow = "#e5c07b", -- entity.name.type, support.class
  sun = "#e5c07b",
  purple = "#c678dd", -- keyword, storage
  dark_purple = "#c678dd",
  teal = "#56b6c2",
  orange = "#d19a66", -- constant, constant.numeric, attribute-name
  cyan = "#56b6c2", -- support.type, support.function, escapes
  -- the vscode_colored statusline runs this through lighten(+1), and
  -- #1f2329 is the value that comes out as statusBar.background (#21252b)
  statusline_bg = "#1f2329",
  lightbg = "#2c313a", -- statusBarItem.hoverBackground
  pmenu_bg = "#61afef",
  folder_bg = "#61afef",
}

M.base_16 = {
  base00 = "#282c34", -- editor.background
  base01 = "#2c313a", -- list.activeSelectionBackground
  base02 = "#3e4451", -- editor.selectionBackground
  base03 = "#5c6370", -- comment
  base04 = "#9da5b4", -- statusBar.foreground
  base05 = "#abb2bf", -- editor.foreground
  base06 = "#b6bdca",
  base07 = "#d7dae0", -- list.activeSelectionForeground
  base08 = "#e06c75", -- red
  base09 = "#d19a66", -- orange
  base0A = "#e5c07b", -- yellow
  base0B = "#98c379", -- green
  base0C = "#56b6c2", -- cyan
  base0D = "#61afef", -- blue
  base0E = "#c678dd", -- purple
  base0F = "#be5046", -- dark red
}

-- flat lookup so groups.lua can say p.blue instead of p.base_30.blue
local flat = {}
for _, tbl in ipairs { M.base_30, M.base_16 } do
  for k, v in pairs(tbl) do
    flat[k] = v
  end
end

return setmetatable(M, { __index = flat })
