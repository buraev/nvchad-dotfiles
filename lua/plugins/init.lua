return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require "configs.conform"
    end,
  },
  -- These are some examples, uncomment them if you want to see them work!
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
  },
  {
    "stevearc/dressing.nvim",
    lazy = false,
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("configs.lsp").defaults()
      require "configs.lspconfig"
    end,
  },
  -- The mason spec, and with it `ensure_installed`, lives in plugins/core.lua.
  -- A second spec here could not work: core.lua sets `opts` as a function, and
  -- a function `opts` replaces the merged table rather than extending it, so
  -- whatever this one declared was dropped before mason.setup() ran.
  {
    "nvim-treesitter/nvim-treesitter",
    -- master's predicate/directive handlers predate nvim 0.12's treesitter API
    -- and blew up on every markdown buffer; its README says 0.12 is not
    -- supported. main is the branch that targets 0.12. It dropped the
    -- `nvim-treesitter.configs` API, so highlighting comes from the FileType
    -- hook in lua/autocmds.lua calling vim.treesitter.start(), and indenting
    -- from the indentexpr set there too.
    branch = "main",
    -- main does not support lazy-loading
    lazy = false,
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "tsx",
        "typescript",
        "javascript",
        "go",
        -- the markdown pair is what master's broken handlers used to crash on
        "markdown",
        "markdown_inline",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup()
      require("nvim-treesitter").install(opts.ensure_installed)
    end,
  },
  {
    -- The current block is marked by the snacks chunk guide now, so drop
    -- indent-blankline's own scope line -- otherwise both draw at the same
    -- column. Its plain guides stay, they are the ones matched to VS Code.
    "lukas-reineke/indent-blankline.nvim",
    opts = { scope = { enabled = false } },
  },
  {
    -- VS Code colours bracket pairs by nesting depth on its own, outside the
    -- theme. Without this the braces in `import { x }` stay foreground-grey
    -- instead of gold. Colours are set in themes/atom-one-dark.lua.
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("rainbow-delimiters.setup").setup {
        -- The html query marks the tag NAME as a delimiter, not just the angle
        -- brackets, so <div>, <p> and <span> came out gold/orchid/blue by
        -- nesting depth. That fights the theme twice over: it wants
        -- entity.name.tag red (#e06c75) and meta.tag at plain foreground
        -- (#abb2bf). Same problem the JSX rules had below, but html ships no
        -- parens-only query to switch to, so turn the language off outright --
        -- there is nothing left to colour once the tag rules are gone.
        blacklist = { "html" },
        query = {
          [""] = "rainbow-delimiters",
          -- The default JSX query paints the tag NAME as a delimiter, so
          -- <Widget> came out gold and nested tags purple/blue. VS Code only
          -- ever colours bracket characters, so use the parens-only query.
          tsx = "rainbow-parens",
          javascript = "rainbow-parens",
        },
        highlight = {
          "RainbowDelimiter1",
          "RainbowDelimiter2",
          "RainbowDelimiter3",
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function()
      require "configs.lint"
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    -- Was an adapter named `node2` shelling out to `node-debug2-adapter`. That
    -- binary comes from vscode-node-debug2, which Microsoft archived years ago,
    -- it was never installed, and the mason list asks for js-debug-adapter --
    -- its successor -- instead. So the adapter is now js-debug's `pwa-node`,
    -- which speaks the same DAP over a port. mxsdev/nvim-dap-vscode-js was the
    -- old glue for that and is archived too; js-debug needs no wrapper.
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require "dap"

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
          -- mason drops this in its bin dir, which options.lua puts on PATH
          command = "js-debug-adapter",
          args = { "${port}" },
        },
      }

      -- one attach + one launch per language; js-debug keys off `type`, so the
      -- same pair works for plain js and for ts/tsx once source maps are on
      for _, ft in ipairs { "javascript", "javascriptreact", "typescript", "typescriptreact" } do
        dap.configurations[ft] = {
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to node process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch current file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
        }
      end
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function()
      require("dapui").setup()

      local dap, dapui = require "dap", require "dapui"

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open {}
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close {}
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close {}
      end
    end,
    dependencies = {
      "mfussenegger/nvim-dap",
    },
  },
  {
    -- Deprecated and superseded by lazydev.nvim, which is configured below and
    -- now actually loads. Never ran anyway: no trigger, nothing required it.
    "folke/neodev.nvim",
    enabled = false,
    config = function()
      require("neodev").setup {
        library = { plugins = { "nvim-dap-ui" }, types = true },
      }
    end,
  },
  { "tpope/vim-fugitive" },
  { "rbong/vim-flog", dependencies = {
    "tpope/vim-fugitive",
  }, lazy = false },
  { "sindrets/diffview.nvim", lazy = false },
  {
    url = "https://codeberg.org/andyg/leap.nvim",
    lazy = false,
    config = function()
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
      vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
      vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)")
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    lazy = false,
  },
  {
    "folke/trouble.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
  },

  {
    -- Replaces NvChad's tabufline. Colours are ported in configs/bufferline,
    -- which reads them back from the theme's Tb* groups rather than repeating
    -- the VS Code tab.activeBackground/tab.inactiveBackground values here.
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    config = function()
      require("configs.bufferline").setup()
    end,
  },
  {
    "folke/which-key.nvim",
    enabled = true,
    opts = {
      preset = "helix",
    },
  },

  {
    -- Never loaded, and snacks.notifier now handles notifications since snacks
    -- was fixed -- enabling this too would give two systems owning vim.notify.
    -- It also replaces the cmdline and message UI, which NvChad already styles.
    "folke/noice.nvim",
    enabled = false,
    opts = function(_, opts)
      opts.debug = vim.uv.cwd():find "noice%.nvim"
      opts.debug = false
      opts.routes = opts.routes or {}
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })

      table.insert(opts.routes, 1, {
        filter = {
          ["not"] = {
            event = "lsp",
            kind = "progress",
          },
          cond = function()
            return not focused and false
          end,
        },
        view = "notify_send",
        opts = { stop = false, replace = true },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })
      return opts
    end,
  },

  {
    -- Replaces NvChad's `vscode_colored` statusline. Sections, icons and
    -- colours are ported in configs/lualine; the mutagen component that used
    -- to live here moved there unchanged.
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    config = function()
      require("configs.lualine").setup()
    end,
  },

  {
    -- This spec was written LazyVim-style, where the distro already declares
    -- folke/snacks.nvim. NvChad does not, so it had no url and no load trigger
    -- other than the keys below -- snacks never started, and with it the indent
    -- chunk guide (the line with the arrow pointing at the block). Modules like
    -- indent hook into BufReadPost, so the plugin has to load eagerly.
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    ---@type snacks.Config
    opts = {
      statuscolumn = { folds = { open = false } },
      notifier = { sort = { "added" } },
      scroll = { debug = false },
      image = {
        force = false,
        enabled = true,
        debug = { request = false, convert = false, placement = false },
        math = { enabled = true },
        doc = { inline = true, float = true },
      },
      picker = {
        previewers = {
          diff = { builtin = false },
          git = { builtin = false },
        },
        debug = { scores = false, leaks = false, explorer = false, files = false, proc = false },
        sources = {
          explorer = {
            layout = {
              preset = "sidebar",
              preview = { main = true, enabled = false },
            },
          },
          files_with_symbols = {
            multi = { "files", "lsp_symbols" },
            filter = {
              ---@param p snacks.Picker
              ---@param filter snacks.picker.Filter
              transform = function(p, filter)
                local symbol_pattern = filter.pattern:match "^.-@(.*)$"
                -- store the current file buffer
                if filter.source_id ~= 2 then
                  local item = p:current()
                  if item and item.file then
                    filter.meta.buf = vim.fn.bufadd(item.file)
                  end
                end

                if symbol_pattern and filter.meta.buf then
                  filter.pattern = symbol_pattern
                  filter.current_buf = filter.meta.buf
                  filter.source_id = 2
                else
                  filter.source_id = 1
                end
              end,
            },
          },
        },
        win = {
          list = {
            keys = {
              ["<c-i>"] = { "toggle_input", mode = { "n", "i" } },
            },
          },
          input = {
            keys = {
              ["<c-l>"] = { "toggle_lua", mode = { "n", "i" } },
              ["<c-i>"] = { "toggle_input", mode = { "n", "i" } },
              -- ["<c-t>"] = { "edit_tab", mode = { "n", "i" } },
              -- ["<c-t>"] = { "yankit", mode = { "n", "i" } },
              -- ["<Esc>"] = { "close", mode = { "n", "i" } },
            },
          },
        },
        actions = {
          yankit = { action = "yank", notify = true },
          toggle_lua = function(p)
            local opts = p.opts --[[@as snacks.picker.grep.Config]]
            opts.ft = not opts.ft and "lua" or nil
            p:find()
          end,
        },
      },
      indent = {
        -- indent-blankline already draws the plain guides, in VS Code's own
        -- colours, so take only the chunk overlay from snacks. chunk is a
        -- render mode for scope, so scope has to stay on for it to show.
        indent = { enabled = false },
        scope = { enabled = true },
        chunk = { enabled = true },
      },
      -- snacks enables every module present in opts, and dashboard opens on
      -- UIEnter -- that would put a startup banner back after nvdash was
      -- switched off. Kept off on purpose.
      dashboard = { enabled = false },
    },
    -- stylua: ignore
    keys = {
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Open" },
    },
  },
  {
    "folke/ts-comments.nvim",
    -- had no trigger, so it never loaded: picks the right commentstring per
    -- treesitter node, which is what makes commenting work inside JSX
    event = "VeryLazy",
    opts = {
      langs = {
        dts = "// %s",
      },
    },
  },
  {
    "echasnovski/mini.align",
    opts = {},
    keys = {
      { "ga", mode = { "n", "v" } },
      { "gA", mode = { "n", "v" } },
    },
  },

  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },

  {
    "Wansmer/treesj",
    keys = {
      { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
    },
    opts = { use_default_keymaps = false, max_join_length = 150 },
  },

  { "echasnovski/mini.test", cond = vim.fn.isdirectory "tests" == 1 },

  {
    "folke/lazydev.nvim",
    -- had no trigger either. The opts function also assumed a LazyVim base
    -- spec: opts.library was nil here, and opts.runtime pointed at a neovim
    -- checkout that does not exist on this machine, so it would have errored.
    ft = "lua",
    opts = function(_, opts)
      opts.library = opts.library or {}
      vim.list_extend(opts.library, {
        { path = "${3rd}/luassert/library", words = { "assert" } },
        { path = "${3rd}/busted/library", words = { "describe" } },
        -- lazydev pulls a library in only when a `words` pattern shows up in the
        -- buffer, and it has no rule for `Snacks` on its own -- that rule came
        -- from the LazyVim base spec. Without it mappings.lua reported eleven
        -- "Undefined global `Snacks`", since the plugin sets that global at
        -- runtime and nothing told LuaLS where its annotations live.
        { path = "snacks.nvim", words = { "Snacks" } },
      })
    end,
  },

  {
    -- Builds with deno and cannot start without it. deno is not on this machine,
    -- so the build step failed and <leader>cp opened nothing; gate the whole
    -- spec on the binary so the key is simply unmapped until deno is there.
    "toppair/peek.nvim",
    cond = vim.fn.executable "deno" == 1,
    build = "deno task --quiet build:fast",
    opts = {
      theme = "light",
    },
    keys = {
      {
        "<leader>cp",
        function()
          require("peek").open()
        end,
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    config = function()
      require("todo-comments").setup {
        keywords = {
          FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
          TODO = { icon = " ", color = "todo" },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", color = "perf", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
          TEST = { icon = " ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        },
        colors = {
          error = { "#e06c75" },
          warning = { "#e5c07b" },
          info = { "#61afef" },
          hint = { "#98c379" },
          todo = { "#d19a66" },
          perf = { "#c678dd" },
          test = { "#56b6c2" },
          default = { "#abb2bf" },
        },
      }
    end,
  }, -- To make a plugin not be loaded
  {
    "luckasRanarison/tailwind-tools.nvim",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    init = function()
      -- tailwind-tools.nvim uses APIs Neovim/nvim-lspconfig have deprecated but
      -- not yet removed. Silence only those specific warnings (own config is fine)
      -- until upstream migrates. https://github.com/luckasRanarison/tailwind-tools.nvim
      --   * client.request              -> client:request       (lsp.lua:212/121)
      --   * require('lspconfig') "framework" -> vim.lsp.config   (lsp.lua:147)
      local deprecate = vim.deprecate
      vim.deprecate = function(name, ...)
        if type(name) == "string" and (name == "client.request" or name:find("require('lspconfig')", 1, true)) then
          return
        end
        return deprecate(name, ...)
      end
    end,
    opts = {
      document_color = {
        enabled = true, -- can be toggled by commands
        kind = "inline", -- "inline" | "foreground" | "background"
        inline_symbol = "󰝤 ", -- only used in inline mode
        debounce = 200, -- in milliseconds, only applied in insert mode
      },
      conceal = {
        enabled = false, -- can be toggled by commands
        min_length = nil, -- only conceal classes exceeding the provided length
        symbol = "󱏿", -- only a single character is allowed
        highlight = { -- extmark highlight options, see :h 'highlight'
          fg = "#38BDF8",
        },
      },
      custom_filetypes = {}, -- see the extension section to learn how it works
    },
  },
}
