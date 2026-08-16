-- Was `require "nvchad.configs.lspconfig"`; ported so the config no longer
-- depends on NvChad for its LSP defaults.
--
-- One deliberate change: <leader>ra used nvchad.lsp.renamer (a floating input
-- box). It now drives inc-rename.nvim, which was already installed but had no
-- keybinding, and previews the rename in-place as you type.

local M = {}
local map = vim.keymap.set

M.on_attach = function(_, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")

  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")

  map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")

  map("n", "<leader>ra", function()
    return ":IncRename " .. vim.fn.expand "<cword>"
  end, { buffer = bufnr, desc = "LSP Rename", expr = true })
end

-- semantic tokens fight the treesitter highlights the theme is tuned against
M.on_init = function(client, _)
  if client:supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

M.diagnostic_config = function()
  local x = vim.diagnostic.severity

  vim.diagnostic.config {
    virtual_text = { prefix = "" },
    signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
    underline = true,
    float = { border = "single" },
  }
end

M.defaults = function()
  M.diagnostic_config()

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      M.on_attach(_, args.buf)
    end,
  })

  local lua_lsp_settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        library = {
          vim.fn.expand "$VIMRUNTIME/lua",
          vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
          "${3rd}/luv/library",
        },
      },
    },
  }

  vim.lsp.config("*", { capabilities = M.capabilities, on_init = M.on_init })
  vim.lsp.config("lua_ls", { settings = lua_lsp_settings })
  vim.lsp.enable "lua_ls"
end

return M
