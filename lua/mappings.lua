-- Was `require "nvchad.mappings"`; ported so the config no longer depends on
-- NvChad for its default keymaps. Kept in this order on purpose: the defaults
-- come first, so the personal maps further down still win where they overlap
-- (<leader>ds -> dap.continue, <leader>gt -> DiffviewToggleFile).
--
-- Calls into nvchad.tabufline / nvchad.term / nvchad.themes are still here;
-- they are replaced by bufferline and snacks.terminal in later steps.
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
  map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })

  map({ "n", "x" }, "<leader>fm", function()
    require("conform").format { lsp_fallback = true }
  end, { desc = "general format file" })

  -- global lsp mappings
  map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

  -- tabufline
  map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })

  map("n", "<tab>", function()
    require("nvchad.tabufline").next()
  end, { desc = "buffer goto next" })

  map("n", "<S-tab>", function()
    require("nvchad.tabufline").prev()
  end, { desc = "buffer goto prev" })

  map("n", "<leader>x", function()
    require("nvchad.tabufline").close_buffer()
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
  map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })

  map("n", "<leader>th", function()
    require("nvchad.themes").open()
  end, { desc = "telescope nvchad themes" })

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
    require("nvchad.term").new { pos = "sp" }
  end, { desc = "terminal new horizontal term" })

  map("n", "<leader>v", function()
    require("nvchad.term").new { pos = "vsp" }
  end, { desc = "terminal new vertical term" })

  -- toggleable
  map({ "n", "t" }, "<A-v>", function()
    require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
  end, { desc = "terminal toggleable vertical term" })

  map({ "n", "t" }, "<A-h>", function()
    require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
  end, { desc = "terminal toggleable horizontal term" })

  map({ "n", "t" }, "<A-i>", function()
    require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
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
  require("nvchad.tabufline").closeAllBufs()
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

-- Terminal
map("n", "<C-]>", function()
  require("nvchad.term").toggle { pos = "vsp", size = 0.4 }
end, { desc = "Toogle Terminal Vertical" })
map("n", "<C-\\>", function()
  require("nvchad.term").toggle { pos = "sp", size = 0.4 }
end, { desc = "Toogle Terminal Horizontal" })
map("n", "<C-f>", function()
  require("nvchad.term").toggle { pos = "float" }
end, { desc = "Toogle Terminal Float" })
map("t", "<C-]>", function()
  require("nvchad.term").toggle { pos = "vsp" }
end, { desc = "Toogle Terminal Vertical" })
map("t", "<C-\\>", function()
  require("nvchad.term").toggle { pos = "sp" }
end, { desc = "Toogle Terminal Horizontal" })
map("t", "<C-f>", function()
  require("nvchad.term").toggle { pos = "float" }
end, { desc = "Toogle Terminal Float" })

-- Basic

map("i", "jj", "<ESC>")
map("i", "<C-g>", function()
  return vim.fn["codeium#Accept"]()
end, { expr = true })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
