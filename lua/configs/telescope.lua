-- Ported from NvChad v2.5 (nvchad/configs/telescope.lua) so the config owns its own plugin setup.
-- Copied byte for byte; the Nerd Font glyphs below are the originals.

return {
  defaults = {
    prompt_prefix = "   ",
    selection_caret = " ",
    entry_prefix = " ",
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
      },
      width = 0.87,
      height = 0.80,
    },
    mappings = {
      n = { ["q"] = require("telescope.actions").close },
    },
  },

  extensions = {},
}
