-- Was `require "nvchad.mappings"`; ported so the config no longer depends on
-- NvChad for its default keymaps. Kept in this order on purpose: the defaults
-- come first, so the personal maps further down still win where they overlap
-- (<leader>ds -> dap.continue, <leader>gt -> DiffviewToggleFile).
--
-- Terminal and buffer-line maps below drive snacks.terminal and bufferline.
-- The theme picker and cheatsheet maps went with nvchad/ui.
do
  local map = vim.keymap.set

  map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
  map("i", "<C-e>", "<End>", { desc = "move end of line" })
  map("i", "<C-h>", "<Left>", { desc = "move left" })
  map("i", "<C-l>", "<Right>", { desc = "move right" })
  map("i", "<C-j>", "<Down>", { desc = "move down" })
  map("i", "<C-k>", "<Up>", { desc = "move up" })

  map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
  map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
  map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
  map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

  map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

  map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
  map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

  map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
  map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })

  map({ "n", "x" }, "<leader>fm", function()
    require("conform").format { lsp_fallback = true }
  end, { desc = "general format file" })

  -- global lsp mappings
  map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

  -- buffer line
  map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })

  map("n", "<tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "buffer goto next" })
  map("n", "<S-tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "buffer goto prev" })

  -- Snacks.bufdelete drops the buffer without collapsing the window layout,
  -- which is what nvchad.tabufline.close_buffer did
  map("n", "<leader>x", function()
    Snacks.bufdelete.delete()
  end, { desc = "buffer close" })

  -- Comment
  map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
  map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

  -- nvimtree
  map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
  map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })

  -- telescope
  map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
  map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
  map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
  map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
  map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
  map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
  map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
  map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
  -- was the nvchad "Telescope terms" extension: pick among live terminals,
  -- including hidden ones. dressing.nvim renders the select.
  map("n", "<leader>pt", function()
    local terms = Snacks.terminal.list()
    if #terms == 0 then
      vim.notify("No terminals open", vim.log.levels.INFO)
      return
    end
    vim.ui.select(terms, {
      prompt = "Terminals",
      format_item = function(t)
        return vim.api.nvim_buf_get_name(t.buf)
      end,
    }, function(t)
      if t then
        t:show():focus()
      end
    end)
  end, { desc = "pick hidden term" })

  map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
  map(
    "n",
    "<leader>fa",
    "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
    { desc = "telescope find all files" }
  )

  -- terminal
  map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

  -- new terminals
  map("n", "<leader>h", function()
    Snacks.terminal.open(nil, { win = { position = "bottom" } })
  end, { desc = "terminal new horizontal term" })

  map("n", "<leader>v", function()
    Snacks.terminal.open(nil, { win = { position = "right" } })
  end, { desc = "terminal new vertical term" })

  -- toggleable. snacks keys a terminal by cmd/cwd/env/count -- NOT by window
  -- position -- so every toggle needs its own count or they collapse into one
  -- shared terminal. Counts 1-3 belong to the C-\ / C-] / C-f maps below.
  map({ "n", "t" }, "<A-v>", function()
    Snacks.terminal.toggle(nil, { count = 5, win = { position = "right" } })
  end, { desc = "terminal toggleable vertical term" })

  map({ "n", "t" }, "<A-h>", function()
    Snacks.terminal.toggle(nil, { count = 4, win = { position = "bottom" } })
  end, { desc = "terminal toggleable horizontal term" })

  map({ "n", "t" }, "<A-i>", function()
    Snacks.terminal.toggle(nil, { count = 6, win = { position = "float" } })
  end, { desc = "terminal toggle floating term" })

  -- whichkey
  map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

  map("n", "<leader>wk", function()
    vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
  end, { desc = "whichkey query lookup" })
end

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
--
--
-- require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>cx", function()
  Snacks.bufdelete.all()
end, { desc = "Close All Buffers" })

map("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find Todo" })
map("n", "<leader>qo", "<cmd>TodoTrouble<CR>", { desc = "Todo (Trouble)" })
map("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next Todo Comment" })
map("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous Todo Comment" })
map("n", "\\", "<cmd>:vsplit <CR>", { desc = "Vertical Split" })
map("n", "<c-l>", "<cmd>:TmuxNavigateRight<cr>", { desc = "Tmux Right" })
map("n", "<c-h>", "<cmd>:TmuxNavigateLeft<cr>", { desc = "Tmux Left" })
map("n", "<c-k>", "<cmd>:TmuxNavigateUp<cr>", { desc = "Tmux Up" })
map("n", "<c-j>", "<cmd>:TmuxNavigateDown<cr>", { desc = "Tmux Down" })

-- Trouble

map("n", "<leader>qx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>qw", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
map("n", "<leader>qd", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
map(
  "n",
  "<leader>qq",
  "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
  { desc = "LSP Definitions / references / ... (Trouble)" }
)
map("n", "<leader>ql", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
map("n", "<leader>qt", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

-- Tests
map("n", "<leader>tt", function()
  require("neotest").run.run()
end, { desc = "Run nearest test" })
map("n", "<leader>tf", function()
  require("neotest").run.run(vim.fn.expand "%")
end, { desc = "Run file test" })
map("n", "<leader>to", ":Neotest output<CR>", { desc = "Show test output" })
map("n", "<leader>ts", ":Neotest summary<CR>", { desc = "Show test summary" })

-- Debug
map("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "Toggle Debug UI" })
map("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })
map("n", "<leader>ds", function()
  require("dap").continue()
end, { desc = "Start" })
map("n", "<leader>dn", function()
  require("dap").step_over()
end, { desc = "Step Over" })

-- Git
map("n", "<leader>gl", ":Flog<CR>", { desc = "Git Log" })
map("n", "<leader>gf", ":DiffviewFileHistory<CR>", { desc = "Git File History" })
map("n", "<leader>gc", ":DiffviewOpen HEAD~1<CR>", { desc = "Git Last Commit" })
map("n", "<leader>gt", ":DiffviewToggleFile<CR>", { desc = "Git File History" })

-- Terminal. Counts 1-3 keep these three separate from the A-h/A-v/A-i pair
-- above; snacks would otherwise reuse one terminal for all of them.
local function term_vertical()
  Snacks.terminal.toggle(nil, { count = 2, win = { position = "right", width = 0.4 } })
end
local function term_horizontal()
  Snacks.terminal.toggle(nil, { count = 1, win = { position = "bottom", height = 0.4 } })
end
local function term_float()
  Snacks.terminal.toggle(nil, { count = 3, win = { position = "float" } })
end

map({ "n", "t" }, "<C-]>", term_vertical, { desc = "Toogle Terminal Vertical" })
map({ "n", "t" }, "<C-\\>", term_horizontal, { desc = "Toogle Terminal Horizontal" })
map({ "n", "t" }, "<C-f>", term_float, { desc = "Toogle Terminal Float" })

-- Basic

map("i", "jj", "<ESC>")
map("i", "<C-g>", function()
  return vim.fn["codeium#Accept"]()
end, { expr = true })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
