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
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp",
        "prettier",
        "eslint-lsp",
        "gopls",
        "js-debug-adapter",
        "ts_ls",
        "tailwindcss-language-server",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    -- NvChad v2.5 drives the classic `nvim-treesitter.configs` API, which
    -- only exists on master. The main branch dropped it, so ensure_installed
    -- and highlight below were being ignored and no parser ever got built.
    branch = "master",
    -- overrides NvChad's ":TSUpdate | TSInstallAll", which builds every parser
    build = ":TSUpdate",
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
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
      },
    },
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
    "mfussenegger/nvim-dap",
    config = function()
      local ok, dap = pcall(require, "dap")
      if not ok then
        return
      end
      dap.configurations.typescript = {
        {
          type = "node2",
          name = "node attach",
          request = "attach",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
        },
      }
      dap.adapters.node2 = {
        type = "executable",
        command = "node-debug2-adapter",
        args = {},
      }
    end,
    dependencies = {
      "mxsdev/nvim-dap-vscode-js",
    },
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
    -- Would replace NvChad's tabufline, whose TbBufOn/TbBufOff are matched to
    -- VS Code's tab.activeBackground/tab.inactiveBackground. Never loaded, so
    -- nothing changes by saying so explicitly. Flip to true to switch, but the
    -- tab colours would then need porting to bufferline's own groups.
    "akinsho/bufferline.nvim",
    enabled = false,
    opts = { options = { separator_style = "slope" } },
  },
  {
    "folke/which-key.nvim",
    enabled = true,
    opts = {
      preset = "helix",
      debug = vim.uv.cwd():find "which%-key",
      win = {},
      spec = {},
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
    -- Would replace NvChad's statusline, where StatusLine/StText are matched to
    -- VS Code's statusBar colours. Also written LazyVim-style: the opts function
    -- appends to opts.sections.lualine_x, which only exists if a base spec
    -- defined it, so enabling this as-is would error on a nil index.
    "nvim-lualine/lualine.nvim",
    enabled = false,
    opts = function(_, opts)
      ---@type table<string, {updated:number, total:number, enabled: boolean, status:string[]}>
      local mutagen = {}

      local function mutagen_status()
        local cwd = vim.uv.cwd() or "."
        mutagen[cwd] = mutagen[cwd]
          or {
            updated = 0,
            total = 0,
            enabled = vim.fs.find("mutagen.yml", { path = cwd, upward = true })[1] ~= nil,
            status = {},
          }
        local now = vim.uv.now() -- timestamp in milliseconds
        local refresh = mutagen[cwd].updated + 10000 < now
        if #mutagen[cwd].status > 0 then
          refresh = mutagen[cwd].updated + 1000 < now
        end
        if mutagen[cwd].enabled and refresh then
          ---@type {name:string, status:string, idle:boolean}[]
          local sessions = {}
          local lines = vim.fn.systemlist "mutagen project list"
          local status = {}
          local name = nil
          for _, line in ipairs(lines) do
            local n = line:match "^Name: (.*)"
            if n then
              name = n
            end
            local s = line:match "^Status: (.*)"
            if s then
              table.insert(sessions, {
                name = name,
                status = s,
                idle = s == "Watching for changes",
              })
            end
          end
          for _, session in ipairs(sessions) do
            if not session.idle then
              table.insert(status, session.name .. ": " .. session.status)
            end
          end
          mutagen[cwd].updated = now
          mutagen[cwd].total = #sessions
          mutagen[cwd].status = status
          if #sessions == 0 then
            vim.notify("Mutagen is not running", vim.log.levels.ERROR, { title = "Mutagen" })
          end
        end
        return mutagen[cwd]
      end

      local error_color = { fg = Snacks.util.color "DiagnosticError" }
      local ok_color = { fg = Snacks.util.color "DiagnosticInfo" }
      table.insert(opts.sections.lualine_x, {
        cond = function()
          return mutagen_status().enabled
        end,
        color = function()
          return (mutagen_status().total == 0 or mutagen_status().status[1]) and error_color or ok_color
        end,
        function()
          local s = mutagen_status()
          local msg = s.total
          if #s.status > 0 then
            msg = msg .. " | " .. table.concat(s.status, " | ")
          end
          return (s.total == 0 and "󰋘 " or "󰋙 ") .. msg
        end,
      })
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
        debug = { scores = false, leaks = false, explorer = false, files = false, proc = true },
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
      profiler = {
        runtime = "~/projects/neovim/runtime/",
        presets = {
          on_stop = function()
            Snacks.profiler.scratch()
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
      gitbrowse = {
        open = function(url)
          vim.fn.system " ~/dot/config/hypr/scripts/quake"
          vim.ui.open(url)
        end,
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Open" },
      { "<leader>dd", function() Snacks.picker.grep({search = "^(?!\\s*--).*\\b(bt|dd)\\(", args = {"-P"}, live = false, ft = "lua"}) end, desc = "Debug Searcher" },
      { "<leader>t", function() Snacks.scratch({ icon = " ", name = "Todo", ft = "markdown", file = "~/dot/TODO.md" }) end, desc = "Todo List" },
      {
        "<leader>dpd",
        desc = "Debug profiler",
        function()
          do return {
            a = {
              b = {
                c =  123,
              },
            },
          } end
          if not Snacks.profiler.running() then
            Snacks.notify("Profiler debug started")
            Snacks.profiler.start()
          else
            Snacks.profiler.debug()
            Snacks.notify("Profiler debug stopped")
          end
        end,
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["javascript"] = { "dprint", "prettier" },
        ["javascriptreact"] = { "dprint" },
        ["typescript"] = { "dprint", "prettier" },
        ["typescriptreact"] = { "dprint" },
      },
      formatters = {
        dprint = {
          condition = function(_, ctx)
            return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
          end,
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        lua = { "selene", "luacheck" },
      },
      linters = {
        selene = {
          condition = function(ctx)
            local root = LazyVim.root.get { normalize = true }
            if root ~= vim.uv.cwd() then
              return false
            end
            return vim.fs.find({ "selene.toml" }, { path = root, upward = true })[1]
          end,
        },
        luacheck = {
          condition = function(ctx)
            local root = LazyVim.root.get { normalize = true }
            if root ~= vim.uv.cwd() then
              return false
            end
            return vim.fs.find({ ".luacheckrc" }, { path = root, upward = true })[1]
          end,
        },
      },
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
    "zbirenbaum/copilot.lua",
    optional = true,
    opts = {
      filetypes = { ["*"] = true },
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
      })
    end,
  },

  { "markdown-preview.nvim", enabled = false },

  {
    "toppair/peek.nvim",
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
