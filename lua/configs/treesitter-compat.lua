-- Neovim 0.12 removed the `all = false` compatibility mode for treesitter
-- predicate/directive handlers: the `match` table a handler receives now always
-- maps a capture id to a *list* of nodes, never to a single node.
--
-- nvim-treesitter master (the only branch that still ships the classic
-- `nvim-treesitter.configs` API NvChad v2.5 drives, see plugins/init.lua) still
-- registers its handlers with `{ force = true, all = false }` and then treats
-- `match[id]` as one node. On 0.12 that hands a plain Lua table to
-- `vim.treesitter.get_node_text`, which dies with
--   attempt to call method 'range' (a nil value)
-- Markdown trips it on every buffer, because queries/markdown/injections.scm
-- runs `#set-lang-from-info-string!` on each fenced code block.
--
-- Re-register the affected handlers with the 0.12 calling convention. Drop this
-- file once nvim-treesitter is migrated to the `main` branch.

local M = {}

local query = require "vim.treesitter.query"

-- Old `all = false` behaviour handed back the *last* node of a capture.
local function one(match, id)
  local nodes = match[id]
  if type(nodes) ~= "table" then
    return nodes
  end
  return nodes[#nodes]
end

local function node_text(node, bufnr)
  local ok, text = pcall(vim.treesitter.get_node_text, node, bufnr)
  if ok then
    return text
  end
end

local html_script_type_languages = {
  ["importmap"] = "json",
  ["module"] = "javascript",
  ["application/ecmascript"] = "javascript",
  ["text/ecmascript"] = "javascript",
}

local injection_language_aliases = {
  ex = "elixir",
  pl = "perl",
  sh = "bash",
  uxn = "uxntal",
  ts = "typescript",
}

local function parser_from_info_string(alias)
  local match = vim.filetype.match { filename = "a." .. alias }
  return match or injection_language_aliases[alias] or alias
end

function M.setup()
  -- Load the plugin's own registrations first; ours must win afterwards.
  if not pcall(require, "nvim-treesitter.query_predicates") then
    return
  end

  if vim.fn.has "nvim-0.12" ~= 1 then
    return
  end

  local opts = { force = true }

  query.add_predicate("nth?", function(match, _, _, pred)
    local node = one(match, pred[2])
    local n = tonumber(pred[3])
    if node and n and node:parent() and node:parent():named_child_count() > n then
      return node:parent():named_child(n) == node
    end
    return false
  end, opts)

  query.add_predicate("is?", function(match, _, bufnr, pred)
    local node = one(match, pred[2])
    if not node then
      return true
    end
    local locals = require "nvim-treesitter.locals"
    local _, _, kind = locals.find_definition(node, bufnr)
    return vim.tbl_contains({ unpack(pred, 3) }, kind)
  end, opts)

  query.add_predicate("kind-eq?", function(match, _, _, pred)
    local node = one(match, pred[2])
    if not node then
      return true
    end
    return vim.tbl_contains({ unpack(pred, 3) }, node:type())
  end, opts)

  query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
    local node = one(match, pred[2])
    if not node then
      return
    end
    local type_attr_value = node_text(node, bufnr)
    if not type_attr_value then
      return
    end
    local configured = html_script_type_languages[type_attr_value]
    if configured then
      metadata["injection.language"] = configured
    else
      local parts = vim.split(type_attr_value, "/", {})
      metadata["injection.language"] = parts[#parts]
    end
  end, opts)

  query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
    local node = one(match, pred[2])
    if not node then
      return
    end
    local text = node_text(node, bufnr)
    if not text then
      return
    end
    metadata["injection.language"] = parser_from_info_string(text:lower())
  end, opts)

  query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
    local id = pred[2]
    local node = one(match, id)
    if not node then
      return
    end
    local text = node_text(node, bufnr) or ""
    metadata[id] = metadata[id] or {}
    metadata[id].text = string.lower(text)
  end, opts)
end

return M
