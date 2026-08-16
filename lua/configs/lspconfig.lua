local configs = require "configs.lsp"

local servers = { "html", "cssls", "ts_ls", "clangd", "gopls", "gradle_ls", "tailwindcss", "prismals" }

for _, server in ipairs(servers) do
  -- `commands.OrganizeImports` used to be declared here with a description and
  -- no function behind it, so :OrganizeImports never existed. ts_ls exposes the
  -- same thing as a code action (source.organizeImports), reachable on `gra`.
  local opts = {
    on_attach = configs.on_attach,
    capabilities = configs.capabilities,
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
