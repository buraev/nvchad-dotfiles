-- Ported from NvChad v2.5 (nvchad/configs/mason.lua) so the config owns its own plugin setup.
-- Copied byte for byte; the Nerd Font glyphs below are the originals.

return {
  PATH = "skip",

  ui = {
    icons = {
      package_pending = " ",
      package_installed = " ",
      package_uninstalled = " ",
    },
  },

  max_concurrent_installers = 10,
}
