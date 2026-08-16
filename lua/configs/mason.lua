-- Ported from NvChad v2.5 (nvchad/configs/mason.lua) so the config owns its own
-- plugin setup. The Nerd Font glyphs below are the originals.
--
-- `ensure_installed` is NOT a mason.nvim option -- mason.nvim only knows PATH,
-- ui, registries and friends. NvChad read this key off the spec itself and
-- installed from it via :MasonInstallAll, and that went away with NvChad, so
-- the list sat here doing nothing. plugins/core.lua now consumes the key and
-- reimplements the command; it is stripped before mason.setup() sees it.

return {
  ensure_installed = {
    "lua-language-server",
    "stylua",
    "html-lsp",
    "css-lsp",
    "prettier",
    "eslint-lsp",
    -- the daemon configs/lint.lua actually shells out to; eslint-lsp above is
    -- the language server and does not provide this binary
    "eslint_d",
    "gopls",
    "js-debug-adapter",
    -- was "ts_ls", which is the lspconfig server name; mason's package is this
    "typescript-language-server",
    "tailwindcss-language-server",
  },

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
