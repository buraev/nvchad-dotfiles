-- Plugin specs that used to come from `import = "nvchad.plugins"`. Fields are
-- kept as NvChad v2.5 had them (load events, commands, dependency sets), so
-- removing the import changes nothing about when things load. The per-plugin
-- option tables live in lua/configs/, ported byte for byte.

return {
  "nvim-lua/plenary.nvim",

  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      return { override = require "icons.devicons" }
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "User FilePost",
    opts = {
      indent = { char = "│", highlight = "IblChar" },
      scope = { char = "│", highlight = "IblScopeChar" },
    },
    config = function(_, opts)
      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require("ibl").setup(opts)
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "configs.nvimtree"
    end,
  },

  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
    config = function(_, opts)
      require("which-key").setup(opts)
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = function()
      return require "configs.gitsigns"
    end,
  },

  {
    -- NvChad points at mason-org/mason.nvim, the renamed home, but the tree on
    -- disk was cloned from williamboman and lazy keys plugins by repo name.
    -- Keeping the old URL avoids a re-clone for what is the same plugin.
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonInstallAll" },
    opts = function()
      return require "configs.mason"
    end,
    -- Replaces NvChad's :MasonInstallAll, which is what used to read
    -- `ensure_installed`. Same shape as the TSInstallAll command in autocmds.lua.
    config = function(_, opts)
      local ensure_installed = opts.ensure_installed or {}
      -- copy rather than clear the key: `opts` is the table configs.mason
      -- returns, and package.loaded hands the same one back on every require
      local setup_opts = {}
      for k, v in pairs(opts) do
        if k ~= "ensure_installed" then
          setup_opts[k] = v
        end
      end
      require("mason").setup(setup_opts)

      -- Package:install() is fire-and-forget and prints nothing unless the Mason
      -- window happens to be open, so the command reports for itself: what it
      -- queued, then one line per package as it lands. Without that a run that
      -- worked is indistinguishable from a command that did nothing.
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        local registry = require "mason-registry"
        -- refresh first, otherwise get_package errors on a cold registry
        registry.refresh(function()
          local pending = {}

          for _, name in ipairs(ensure_installed) do
            local ok, pkg = pcall(registry.get_package, name)
            if not ok then
              vim.schedule(function()
                vim.notify("mason: no such package " .. name, vim.log.levels.WARN)
              end)
            elseif not pkg:is_installed() then
              pending[#pending + 1] = { name = name, pkg = pkg }
            end
          end

          if #pending == 0 then
            vim.schedule(function()
              vim.notify("mason: ensure_installed is already complete", vim.log.levels.INFO)
            end)
            return
          end

          local left = #pending
          local names = table.concat(
            vim.tbl_map(function(p)
              return p.name
            end, pending),
            ", "
          )
          vim.schedule(function()
            vim.notify(("mason: installing %d -- %s"):format(left, names))
          end)

          for _, p in ipairs(pending) do
            p.pkg:install(nil, function(success, err)
              left = left - 1
              vim.schedule(function()
                if success then
                  vim.notify(("mason: %s installed (%d to go)"):format(p.name, left))
                else
                  vim.notify(("mason: %s failed -- %s"):format(p.name, tostring(err)), vim.log.levels.ERROR)
                end
              end)
            end)
          end
        end)
      end, { desc = "Install everything in configs.mason ensure_installed" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
  },

  -- completion, loaded on first insert
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "configs.luasnip"
        end,
      },

      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "https://codeberg.org/FelipeLema/cmp-async-path.git",
      },
    },
    opts = function()
      return require "configs.cmp"
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    opts = function()
      return require "configs.telescope"
    end,
  },

  -- nvim-treesitter itself is specced in plugins/init.lua: it sits on the
  -- `main` branch, which does not support lazy-loading, so the load event and
  -- command list NvChad set here would be wrong.
}
