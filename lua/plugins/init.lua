return {
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		config = function()
			require("configs.conform")
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
			require("configs.lspconfig")
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
		opts = {
			filesystem = {
				filtered_items = {
					visible = true,
				},
			},
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
		"mfussenegger/nvim-lint",
		event = "VeryLazy",
		config = function()
			require("configs.lint")
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("configs.lspconfig")
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

			local dap, dapui = require("dap"), require("dapui")

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end
		end,
		dependencies = {
			"mfussenegger/nvim-dap",
		},
	},
	{
		"folke/neodev.nvim",
		config = function()
			require("neodev").setup({
				library = { plugins = { "nvim-dap-ui" }, types = true },
			})
		end,
	},
	{ "tpope/vim-fugitive" },
	{ "rbong/vim-flog", dependencies = {
		"tpope/vim-fugitive",
	}, lazy = false },
	{ "sindrets/diffview.nvim", lazy = false },
	{
		"ggandor/leap.nvim",
		lazy = false,
		config = function()
			require("leap").add_default_mappings(true)
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
	},

	{ "akinsho/bufferline.nvim", opts = { options = { separator_style = "slope" } } },
	{
		"folke/which-key.nvim",
		enabled = true,
		opts = {
			preset = "helix",
			debug = vim.uv.cwd():find("which%-key"),
			win = {},
			spec = {},
		},
	},

	{
		"folke/noice.nvim",
		opts = function(_, opts)
			opts.debug = vim.uv.cwd():find("noice%.nvim")
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
		"nvim-lualine/lualine.nvim",
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
					local lines = vim.fn.systemlist("mutagen project list")
					local status = {}
					local name = nil
					for _, line in ipairs(lines) do
						local n = line:match("^Name: (.*)")
						if n then
							name = n
						end
						local s = line:match("^Status: (.*)")
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

			local error_color = { fg = Snacks.util.color("DiagnosticError") }
			local ok_color = { fg = Snacks.util.color("DiagnosticInfo") }
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
		"snacks.nvim",
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
								local symbol_pattern = filter.pattern:match("^.-@(.*)$")
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
				chunk = { enabled = true },
			},
			dashboard = { example = "github" },
			gitbrowse = {
				open = function(url)
					vim.fn.system(" ~/dot/config/hypr/scripts/quake")
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
		"neovim/nvim-lspconfig",
		opts = {
			diagnostics = { virtual_text = { prefix = "icons" } },
			capabilities = {
				workspace = {
					didChangeWatchedFiles = {
						dynamicRegistration = false,
					},
				},
			},
			servers = {
				lua_ls = {
					-- cmd = { "/home/folke/projects/lua-language-server/bin/lua-language-server" },
					-- single_file_support = true,
					settings = {
						Lua = {
							misc = {
								-- parameters = { "--loglevel=trace" },
							},
							hover = { expandAlias = false },
							type = {
								castNumberToInteger = true,
								inferParamType = true,
							},
							diagnostics = {
								disable = { "incomplete-signature-doc", "trailing-space" },
								-- enable = false,
								groupSeverity = {
									strong = "Warning",
									strict = "Warning",
								},
								groupFileStatus = {
									["ambiguity"] = "Opened",
									["await"] = "Opened",
									["codestyle"] = "None",
									["duplicate"] = "Opened",
									["global"] = "Opened",
									["luadoc"] = "Opened",
									["redefined"] = "Opened",
									["strict"] = "Opened",
									["strong"] = "Opened",
									["type-check"] = "Opened",
									["unbalanced"] = "Opened",
									["unused"] = "Opened",
								},
								unusedLocalExclude = { "_*" },
							},
						},
					},
				},
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
						local root = LazyVim.root.get({ normalize = true })
						if root ~= vim.uv.cwd() then
							return false
						end
						return vim.fs.find({ "selene.toml" }, { path = root, upward = true })[1]
					end,
				},
				luacheck = {
					condition = function(ctx)
						local root = LazyVim.root.get({ normalize = true })
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

	{ "echasnovski/mini.test", cond = vim.fn.isdirectory("tests") == 1 },

	{
		"folke/lazydev.nvim",
		opts = function(_, opts)
			opts.debug = true
			opts.runtime = "~/projects/neovim/runtime"
			vim.list_extend(opts.library, {
				-- { path = "wezterm-types", mods = { "wezterm" } },
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
			require("todo-comments").setup()
		end,
	}, -- To make a plugin not be loaded
	{
		"luckasRanarison/tailwind-tools.nvim",
		lazy = false,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
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
