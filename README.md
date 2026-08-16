# nvim

A standalone Neovim config: [lazy.nvim](https://github.com/folke/lazy.nvim) plus
an in-tree Atom One Dark colorscheme tuned to match VS Code token for token.

It started as the NvChad starter template. Nothing of NvChad is left — options,
mappings, autocmds, plugin specs, LSP defaults and the theme were all ported into
`lua/` and the dependency was dropped. See `git log` for that migration, one
commit per piece.

## Requirements

- Neovim **0.12+** — `nvim-treesitter` is pinned to its `main` branch, which
  drops the `nvim-treesitter.configs` API and needs the 0.12 treesitter runtime
- `git`, a C compiler (for parsers), `ripgrep` and `fd` for Telescope/snacks
- A Nerd Font — icons are used throughout the statusline, tabs and completion menu
- `node` and `deno` if you want `ts_ls`, the DAP JS adapter and `peek.nvim`

## Install

```sh
git clone git@github.com:buraev/nvchad-dotfiles.git ~/.config/nvim
nvim
```

lazy.nvim bootstraps itself on first launch and installs everything in
`lazy-lock.json` (49 plugins). Then, inside nvim:

```
:TSInstallAll   " build the treesitter parsers listed in the plugin spec
:Mason          " install language servers, formatters and linters
```

## Layout

```
init.lua                 leader, lazy bootstrap, theme, load order
lua/
  options.lua            editor defaults (was nvchad.options)
  mappings.lua           keymaps (was nvchad.mappings) + personal maps
  autocmds.lua           User FilePost trigger, treesitter start, :TSInstallAll
  plugins/
    init.lua             personal plugin specs
    core.lua             the specs that used to come from nvchad.plugins
  configs/               per-plugin option tables
  theme/
    palette.lua          named colours, one place per hex value
    groups.lua           ~1750 highlight groups, plain data
    init.lua             applies them, and re-applies after each plugin loads
  icons/                 devicon overrides, lspkind symbols
after/queries/           treesitter query overrides for JS/TS/JSX
```

## Colours

`lua/theme/` replaces base46. base46 compiled a theme to a bytecode cache per
plugin integration and `dofile`'d the pieces during startup; here the groups were
captured once and are just a table, so there is no generation step and no cache.

`theme.setup()` runs before plugins, because some `config` functions read colours
back out of the highlight table (`configs/lualine` reads `St_*`,
`configs/bufferline` reads `Tb*`). It then re-applies on every `LazyLoad` — some
plugins define groups the theme also defines and the last writer wins. A full
re-apply of all groups costs ~0.3 ms.

The queries in `after/queries/` were derived by tokenising the same file with
VS Code's TextMate engine and diffing against what nvim renders, so JSX, imports
and template literals land on the same colours as VS Code. `rainbow-delimiters`
is restricted to bracket characters for the same reason — its default queries
paint tag *names*, which fights the theme.

## Keymaps

Leader is `<Space>`. `;` opens the command line, `jk`/`jj` leave insert mode.

| Key | Action |
| --- | --- |
| `<leader><space>` | smart file picker (snacks) |
| `<leader>ff` / `fa` / `fw` | find files / all files / live grep |
| `<leader>fb` `fo` `fz` `fh` | buffers, oldfiles, fuzzy in buffer, help |
| `<C-n>` / `<leader>e` | toggle / focus nvim-tree |
| `<Tab>` / `<S-Tab>` | next / prev buffer |
| `<leader>x` / `<leader>cx` | close buffer / all buffers |
| `s` `S` `gs` | leap forward / backward / across windows |
| `\` | vertical split |
| `<C-h/j/k/l>` | window nav, falls through to tmux |
| `<leader>fm` | format (conform) |
| `<leader>/` | toggle comment |
| `J` | join/split toggle (treesj) |
| `ga` / `gA` | align (mini.align) |

LSP, once attached: `gd` `gD` `<leader>D` for definition/declaration/type,
`<leader>ra` renames with an inline preview (`inc-rename`), `<leader>ds` sends
diagnostics to the loclist.

Git: `<leader>gl` Flog log, `<leader>gf` file history, `<leader>gc` diff against
`HEAD~1`, `<leader>gt` toggle file in diffview.

Trouble: `<leader>qx` diagnostics, `qw` buffer diagnostics, `qd` symbols,
`qq` LSP references, `ql` loclist, `qt` quickfix, `qo` todos.

Terminals (snacks): `<C-\>` horizontal, `<C-]>` vertical, `<C-f>` float, and
`<A-h>` `<A-v>` `<A-i>` for a second independent set. Each toggle needs its own
`count` — snacks keys terminals by cmd/cwd/env/count, not by window position.
`<leader>pt` picks among live terminals including hidden ones.

Debug: `<leader>ds` start, `db` breakpoint, `dn` step over, `du` toggle dap-ui.

## Tooling

- **LSP** — `lua_ls`, `html`, `cssls`, `ts_ls`, `clangd`, `gopls`, `gradle_ls`,
  `tailwindcss`, `prismals`, configured through `vim.lsp.config`/`vim.lsp.enable`.
  Semantic tokens are disabled on purpose: they fight the treesitter highlights
  the theme is tuned against.
- **Format** — conform on `BufWritePre`; `dprint` when a `dprint.json` is found,
  `prettier` otherwise, `stylua` for Lua.
- **Lint** — nvim-lint; `selene`/`luacheck` only when their config file exists.
- **Complete** — nvim-cmp with LuaSnip, friendly-snippets and snippets from
  `~/.config/nvim/snippets`.

## Making it yours

- Plugins go in `lua/plugins/init.lua`; `lua/plugins/core.lua` holds the ex-NvChad
  specs and is best left alone.
- Colours: change a hex once in `lua/theme/palette.lua` — `groups.lua` refers to
  everything by name.
- `lua/custom/`, `.env` and `*.local` are gitignored for machine-local overrides.

## Credits

- [NvChad](https://github.com/NvChad/NvChad) — the starting point, and the source
  of the options/mappings/autocmds that were ported here
- [LazyVim starter](https://github.com/LazyVim/starter) — the layout NvChad's own
  starter was modelled on
- Atom One Dark, by way of VS Code's Dark+ port of it

Public domain (Unlicense) — see `LICENSE`.
