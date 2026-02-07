local options = {
	formatters_by_ft = {
		lua = { "stylua" },

		css = { "prettier" },
		html = { "prettier" },
		json = { "prettier" },

		javascript = { "prettier", "eslint" },
		javascriptreact = { "prettier", "eslint" },
		typescript = { "prettier", "eslint" },
		typescriptreact = { "prettier", "eslint" },
	},

	format_on_save = {
		timeout_ms = 1000,
		lsp_fallback = false,
	},
}

require("conform").setup(options)
