-- Atom One Dark — 1:1 port of the VS Code theme
-- Source: akamud.vscode-theme-onedark (themes/OneDark.json), "Atom One Dark"
--
-- Every hex below is copied verbatim from that theme file. The only computed
-- values are the ones VS Code defines with an alpha channel (indent guides,
-- line highlight, find match); those are blended over editor.background
-- (#282c34) so the result is the exact pixel color VS Code renders.

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

-- Places where base46 reuses one palette slot for two different VS Code
-- colors, so the slot alone cannot express both.
M.polish_hl = {
  defaults = {
    -- editor.lineHighlightBackground = #99bbff0a on bg
    CursorLine = { bg = "#2c323c" },
    -- editorGroup.border
    WinSeparator = { fg = "#181a1f" },
    -- editorWidget.border
    FloatBorder = { fg = "#3a3f4b" },
    -- editorSuggestWidget.background / .selectedBackground
    Pmenu = { bg = "#21252b" },
    PmenuSbar = { bg = "#21252b" },
    PmenuSel = { bg = "#2c313a", fg = "#d7dae0" },
    -- The theme leaves editorBracketMatch.* alone, so VS Code uses its own
    -- defaults: an all-but-invisible fill (#0064001a) plus a #888888 border.
    -- A filled bg here would be indistinguishable from Visual and would fight
    -- transparency, so draw the "border" as an underline and let the bracket
    -- keep its own colour, exactly like VS Code does.
    -- fg/bg are cleared explicitly: polish_hl merges into base46's own
    -- MatchWord, which would otherwise keep filling the cell.
    MatchWord = { fg = "NONE", bg = "NONE", bold = true, underline = true, sp = "#888888" },
    -- editor.findMatchHighlightBackground = #528bff3d on bg, and the
    -- current match in its opaque form
    Search = { bg = "#324365", fg = "#abb2bf" },
    IncSearch = { bg = "#528bff", fg = "#282c34" },

    -- Bracket pair colorisation. This is a VS Code editor feature rather than
    -- part of the theme -- Atom One Dark leaves editorBracketHighlight.*
    -- undefined, so VS Code falls back to its own defaults, which cycle
    -- gold -> orchid -> blue. It is what makes the braces in an import yellow.
    RainbowDelimiter1 = { fg = "#ffd700" },
    RainbowDelimiter2 = { fg = "#da70d6" },
    RainbowDelimiter3 = { fg = "#179fff" },
    RainbowDelimiterUnmatched = { fg = "#ff1212" },
  },

  blankline = {
    -- editorIndentGuide.activeBackground
    IblScopeChar = { fg = "#626772" },

    -- With transparency on, base46 marks the start and end line of the current
    -- scope with an underline instead of a background tint. VS Code has no such
    -- underline -- the active indent guide above is the whole indicator.
    ["@ibl.scope.underline.1"] = { underline = false },
    ["@ibl.scope.underline.2"] = { underline = false },
    ["@ibl.scope.underline.3"] = { underline = false },
    ["@ibl.scope.underline.4"] = { underline = false },
    ["@ibl.scope.underline.5"] = { underline = false },
    ["@ibl.scope.underline.6"] = { underline = false },
    ["@ibl.scope.underline.7"] = { underline = false },
  },

  -- base46 maps these to different slots than Atom One Dark does
  syntax = {
    Tag = { fg = "#e06c75" }, -- entity.name.tag
    Include = { fg = "#c678dd" }, -- keyword.control (@keyword.import links here)
  },

  treesitter = {
    ["@tag"] = { fg = "#e06c75" }, -- entity.name.tag
    ["@tag.builtin"] = { fg = "#e06c75" }, -- entity.name.tag
    ["@tag.attribute"] = { fg = "#d19a66" }, -- entity.other.attribute-name

    -- In JSX the grammar splits tags in two: <div> is entity.name.tag (red),
    -- while <Widget> is support.class.component (yellow). treesitter makes the
    -- same split -- lowercase tags end on @tag.builtin, capitalised ones on
    -- @tag -- so this only needs the two to differ for the JSX filetypes.
    ["@tag.tsx"] = { fg = "#e5c07b" }, -- support.class.component
    ["@tag.builtin.tsx"] = { fg = "#e06c75" }, -- entity.name.tag
    ["@tag.javascript"] = { fg = "#e5c07b" },
    ["@tag.builtin.javascript"] = { fg = "#e06c75" },

    -- both set by after/queries/, see the comments there
    ["@variable.import"] = { fg = "#e06c75" }, -- variable.other.readwrite.alias
    ["@variable.object"] = { fg = "#e06c75" }, -- variable.other.object
    ["@tag.delimiter"] = { fg = "#abb2bf" }, -- meta.tag
    ["@variable.parameter"] = { fg = "#abb2bf" }, -- variable.parameter
    ["@type.builtin"] = { fg = "#56b6c2" }, -- support.type

    -- base46 paints these dark red; VS Code leaves brackets, commas and
    -- semicolons at the normal foreground, which changes how a whole file reads
    ["@punctuation.bracket"] = { fg = "#abb2bf" }, -- meta.brace.*
    ["@punctuation.delimiter"] = { fg = "#abb2bf" }, -- punctuation.separator.comma

    -- "source.ts keyword.operator" is cyan, unlike the generic operator rule
    ["@operator.typescript"] = { fg = "#56b6c2" },
    ["@operator.tsx"] = { fg = "#56b6c2" },
    ["@operator.javascript"] = { fg = "#56b6c2" },
  },

  statusline = {
    -- statusBar.foreground
    StatusLine = { fg = "#9da5b4" },
    StText = { fg = "#9da5b4" },
  },

  tbline = {
    -- tab.activeForeground on tab.activeBackground
    TbBufOn = { fg = "#d7dae0" },
    -- tab.inactiveBackground, dimmed foreground
    TbBufOff = { fg = "#9da5b4" },
  },
}

M.type = "dark"

M = require("base46").override_theme(M, "atom-one-dark")

return M
