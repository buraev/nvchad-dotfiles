local configs = require "configs.lsp"

local servers = { "html", "cssls", "ts_ls", "clangd", "gopls", "gradle_ls", "tailwindcss", "prismals" }

for _, server in ipairs(servers) do
  local opts = {
    on_attach = configs.on_attach,
    capabilities = configs.capabilities,
    commands = {
      OrganizeImports = {
        description = "Organize Imports",
      },
    },
  }

  if server == "gopls" then
    opts.settings = {
      gopls = {
        completeUnimported = true,
        usePlaceholders = true,
        analyses = {
          unusedparams = true,
        },
      },
    }
  end

  vim.lsp.config(server, opts)
end

vim.lsp.enable(servers)
