-- Was `require "nvchad.autocmds"`; ported so the config no longer depends on
-- NvChad. Behaviour kept identical to NvChad v2.5.

local autocmd = vim.api.nvim_create_autocmd

-- `User FilePost` is the lazy-load trigger for indent-blankline, gitsigns and
-- nvim-lspconfig. It fires once, after the UI is up and a real file buffer
-- exists, so those plugins stay out of startup but are ready by the time the
-- first file is on screen. The augroup deletes itself after firing.
autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("NvFilePost", { clear = true }),
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

    if not vim.g.ui_entered and args.event == "UIEnter" then
      vim.g.ui_entered = true
    end

    if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
      vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
      vim.api.nvim_del_augroup_by_name "NvFilePost"

      vim.schedule(function()
        -- re-fire FileType: plugins that attach on it were not loaded yet when
        -- the buffer was first read
        vim.api.nvim_exec_autocmds("FileType", {})

        if vim.g.editorconfig then
          require("editorconfig").config(args.buf)
        end
      end)
    end
  end,
})

autocmd("FileType", {
  pattern = "*",
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- Came from nvchad.tabufline.lazyload: without it the quickfix buffer stays
-- listed and shows up as a tab in the buffer line.
autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-- Builds every parser listed in the nvim-treesitter spec's ensure_installed.
vim.api.nvim_create_user_command("TSInstallAll", function()
  local spec = require("lazy.core.config").plugins["nvim-treesitter"]
  local opts = type(spec.opts) == "table" and spec.opts or {}
  require("nvim-treesitter").install(opts.ensure_installed)
end, {})
