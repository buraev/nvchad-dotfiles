-- `eslint` used to sit next to prettier in the js/ts lists, but conform has no
-- builtin by that name (only `eslint_d`), so every format of a js/ts buffer
-- logged "Formatter 'eslint' not found". Linting is nvim-lint's job here --
-- configs/lint.lua already runs eslint_d on BufWritePost -- so conform only
-- formats.
local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },

    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
  },

  format_on_save = {
    timeout_ms = 1000,
    -- `lsp_fallback` is the deprecated spelling of this option
    lsp_format = "never",
  },
}

require("conform").setup(options)
