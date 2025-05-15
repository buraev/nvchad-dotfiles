vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("ts_fix_imports", { clear = true }),
  desc = "Add missing imports and remove unused imports for TS",
  pattern = { "*.ts", "*.tsx" },
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {
      only = { "source.addMissingImports.ts", "source.removeUnused.ts" },
    }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.kind == "source.addMissingImports.ts" then
          vim.lsp.buf.code_action {
            apply = true,
            context = {
              only = { "source.addMissingImports.ts" },
            },
          }
          vim.cmd "write"
        else
          if r.kind == "source.removeUnused.ts" then
            vim.lsp.buf.code_action {
              apply = true,
              context = {
                only = { "source.removeUnused.ts" },
              },
            }
            vim.cmd "write"
          end
        end
      end
    end
  end,
})
