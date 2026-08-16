-- Replaces NvChad's `vscode_colored` statusline. The layout follows the order
-- nvchad.stl.utils used for the vscode theme:
--   mode, file, git | lsp progress | diagnostics, lsp, cursor, cwd
--
-- Colours are read back from the theme's St_* highlight groups rather than
-- repeated here, so lua/themes/atom-one-dark.lua stays the one place they live.
-- Icons are the exact code points NvChad used.
--
-- One deliberate deviation: NvChad centred the LSP progress message between two
-- statusline separators. lualine has no true centre section, so it sits at the
-- end of the left group instead.

local M = {}

local icons = {
  file = "󰈚",
  branch = "",
  added = "  ",
  changed = "  ",
  removed = "  ",
  lsp = "   LSP ~ ",
  lsp_short = "   LSP ",
  error = " ",
  warn = " ",
  hint = "󰛩 ",
  info = "󰋼 ",
  cwd = "󰉖 ",
  mutagen_ok = "󰋘 ",
  mutagen_busy = "󰋙 ",
}

local function colour(group, key)
  local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
  return hl[key] and ("#%06x"):format(hl[key]) or nil
end

-- LSP progress: the same LspProgress handler nvchad.stl.utils installed
local spinners = { "", "󰪞", "󰪟", "󰪠", "󰪡", "󰪢", "󰪣", "󰪤", "󰪥", "" }
local lsp_msg = ""

local function lsp_progress_autocmd()
  vim.api.nvim_create_autocmd("LspProgress", {
    pattern = { "begin", "report", "end" },
    callback = function(args)
      if not args.data or not args.data.params then
        return
      end

      local data = args.data.params.value
      local progress = ""

      if data.percentage then
        local idx = math.max(1, math.floor(data.percentage / 10))
        progress = spinners[idx] .. " " .. data.percentage .. "%% "
      end

      local loaded = data.message and string.match(data.message, "^(%d+/%d+)") or ""
      lsp_msg = data.kind == "end" and "" or (progress .. (data.title or "") .. " " .. loaded)
      vim.cmd.redrawstatus()
    end,
  })
end

-- mutagen sync status, carried over unchanged from the previous lualine spec
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
  local now = vim.uv.now()
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
        table.insert(sessions, { name = name, status = s, idle = s == "Watching for changes" })
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

local function theme()
  local text = { fg = colour("StText", "fg"), bg = "NONE" }
  local cwd = { fg = colour("St_cwd", "fg"), bg = colour("St_cwd", "bg") }

  local function mode(group)
    return { fg = colour(group, "fg"), bg = colour(group, "bg"), gui = "bold" }
  end

  local function row(a)
    return { a = a, b = text, c = text, x = text, y = text, z = cwd }
  end

  return {
    normal = row(mode "St_NormalMode"),
    insert = row(mode "St_InsertMode"),
    visual = row(mode "St_VisualMode"),
    replace = row(mode "St_ReplaceMode"),
    command = row(mode "St_CommandMode"),
    terminal = row(mode "St_TerminalMode"),
    inactive = { a = text, b = text, c = text, x = text, y = text, z = text },
  }
end

function M.setup()
  lsp_progress_autocmd()

  require("lualine").setup {
    options = {
      theme = theme(),
      globalstatus = true, -- matches laststatus=3
      component_separators = "",
      section_separators = "",
    },

    sections = {
      lualine_a = { "mode" },

      lualine_b = {
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { "filename", path = 0, symbols = { modified = "", readonly = "", unnamed = "Empty" } },
      },

      lualine_c = {
        { "branch", icon = icons.branch },
        { "diff", symbols = { added = icons.added, modified = icons.changed, removed = icons.removed } },
        {
          function()
            return lsp_msg
          end,
          cond = function()
            return vim.o.columns >= 120 and lsp_msg ~= ""
          end,
          color = { fg = colour("St_LspMsg", "fg") },
        },
      },

      lualine_x = {
        {
          cond = function()
            return mutagen_status().enabled
          end,
          color = function()
            local bad = mutagen_status().total == 0 or mutagen_status().status[1]
            return { fg = Snacks.util.color(bad and "DiagnosticError" or "DiagnosticInfo") }
          end,
          function()
            local s = mutagen_status()
            local msg = s.total
            if #s.status > 0 then
              msg = msg .. " | " .. table.concat(s.status, " | ")
            end
            return (s.total == 0 and icons.mutagen_ok or icons.mutagen_busy) .. msg
          end,
        },
        {
          "diagnostics",
          symbols = { error = icons.error, warn = icons.warn, hint = icons.hint, info = icons.info },
          diagnostics_color = {
            error = { fg = colour("St_lspError", "fg") },
            warn = { fg = colour("St_lspWarning", "fg") },
            hint = { fg = colour("St_LspHints", "fg") },
            info = { fg = colour("St_LspHints", "fg") },
          },
        },
        {
          function()
            for _, client in ipairs(vim.lsp.get_clients { bufnr = 0 }) do
              return vim.o.columns > 100 and (icons.lsp .. client.name) or icons.lsp_short
            end
            return ""
          end,
          color = { fg = colour("St_Lsp", "fg") },
        },
      },

      lualine_y = {
        function()
          return "Ln " .. vim.fn.line "." .. ", Col " .. vim.fn.virtcol "."
        end,
      },

      lualine_z = {
        {
          function()
            local name = vim.uv.cwd() or ""
            return icons.cwd .. (name:match "([^/\\]+)[/\\]*$" or name)
          end,
          cond = function()
            return vim.o.columns > 85
          end,
        },
      },
    },

    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { { "filename", path = 0 } },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },

    extensions = { "nvim-tree", "quickfix", "trouble" },
  }
end

return M
