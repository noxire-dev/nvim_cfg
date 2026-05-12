# nvim-min: Minimal, Primeagen-style Neovim Config

**Date:** 2026-05-12
**Author:** fatih (noxire)
**Status:** Draft → pending implementation

## Goal

Build a second Neovim config at `~/AppData/Local/nvim-min` (Windows path: `C:\Users\noxire\AppData\Local\nvim-min`) that has a hand-rolled, "rough" feel inspired by ThePrimeagen's `init.lua` ([github.com/ThePrimeagen/init.lua](https://github.com/ThePrimeagen/init.lua)). Run it via `NVIM_APPNAME=nvim-min nvim`, aliased to `mvim`.

Keep the existing config at `~/AppData/Local/nvim` untouched.

## Why

- Day-to-day editor split: nvim for small/quick stuff (configs, single-file edits, remote SSH), Zed for full IDE work.
- Current config is kickstart-derived with heavy UI sugar (snacks suite, mini suite, which-key, blink.cmp, fidget, todo-comments, ufo, etc.). User wants to test a leaner config without losing the current one.
- Parallel install via `NVIM_APPNAME` is the lowest-risk path: zero changes to existing config, easy A/B, easy revert (just `rm -rf nvim-min`).

## Non-goals

- Not deleting or migrating the current `nvim` config.
- Not building feature parity with Zed.
- Not optimizing for absolute plugin minimum — LSP and completion stay in.

## Scope decisions (locked)

| Question | Decision |
|---|---|
| Fresh vs trim vs parallel | **Parallel** at `nvim-min` |
| LSP in this config? | **Yes** — mason + lspconfig + nvim-cmp + conform |
| File picker | **telescope.nvim** (not snacks, not fzf-lua) |
| Colorschemes | **rose-pine** (default) + **tokyonight** + **kanagawa** — switchable |
| AI completion | **copilot.lua**, lazy-loaded via `cmd = "Copilot"`, disabled by default |
| Keep from current | **which-key**, **zen-mode** |
| Shell alias | `mvim` (PowerShell function setting `$env:NVIM_APPNAME`) |
| Namespace | `mvim` — both lua module path and shell alias |

## Directory structure

```
C:\Users\noxire\AppData\Local\nvim-min\
├── init.lua                    # 3-line require chain
├── lua\
│   └── mvim\
│       ├── set.lua             # vim options
│       ├── remap.lua           # non-plugin keymaps
│       ├── lazy_init.lua       # lazy.nvim bootstrap
│       └── lazy\               # plugin specs, one per file
│           ├── colors.lua
│           ├── telescope.lua
│           ├── treesitter.lua
│           ├── harpoon.lua
│           ├── undotree.lua
│           ├── fugitive.lua
│           ├── gitsigns.lua
│           ├── lsp.lua
│           ├── conform.lua
│           ├── copilot.lua
│           ├── zenmode.lua
│           └── whichkey.lua
└── lazy-lock.json              # generated
```

## Plugin list (12 spec files, ~22 packages including completion sources and 3 colorschemes)

**Core / editing:**
1. `folke/lazy.nvim` — plugin manager
2. `nvim-treesitter/nvim-treesitter` — syntax / highlighting (build = `:TSUpdate`)
3. `nvim-telescope/telescope.nvim` — picker
4. `nvim-lua/plenary.nvim` — telescope + harpoon dep
5. `ThePrimeagen/harpoon` (branch `harpoon2`) — file marks
6. `mbbill/undotree` — undo history
7. `lewis6991/gitsigns.nvim` — git gutter signs
8. `tpope/vim-fugitive` — git porcelain
9. `folke/zen-mode.nvim` — centered code mode
10. `folke/which-key.nvim` — keymap discoverability (minimal config)

**LSP / completion:**
11. `neovim/nvim-lspconfig`
12. `mason-org/mason.nvim`
13. `mason-org/mason-lspconfig.nvim`
14. `hrsh7th/nvim-cmp` + `hrsh7th/cmp-nvim-lsp` + `saadparwaiz1/cmp_luasnip` + `L3MON4D3/LuaSnip` (one spec file)
15. `stevearc/conform.nvim` — format on save

**AI:**
16. `zbirenbaum/copilot.lua` — `cmd = "Copilot"`, `auto_trigger = false`

**Colors:**
17. `rose-pine/neovim` + `folke/tokyonight.nvim` + `rebelot/kanagawa.nvim` (one spec file)

## Explicitly dropped from current config

snacks.nvim (entire suite), mini.nvim (entire suite), blink.cmp, flash.nvim, trouble.nvim, todo-comments.nvim, nvim-autopairs, nvim-ufo, guess-indent.nvim, fidget.nvim, nvim-lint, mason-tool-installer.nvim.

Rationale: each of these is either replaced by a leaner alternative (snacks → telescope, blink → nvim-cmp, nvim-lint → lsp diagnostics, mason-tool-installer → manual install) or is UI sugar the minimal config intentionally skips.

## Configuration content

### `init.lua`

```lua
require("mvim.set")
require("mvim.remap")
require("mvim.lazy_init")
```

### `lua/mvim/set.lua`

Standard Prime-style options: relative line numbers, 2-space indent (matches current config), no swap/backup, persistent undo at `stdpath("data") .. "/undodir"`, `incsearch` only (no `hlsearch`), `termguicolors`, `scrolloff = 8`, `signcolumn = "yes"`, `updatetime = 50`, `colorcolumn = "100"`.

Mapleader / maplocalleader set to space at the top of this file (before any plugin loads).

### `lua/mvim/remap.lua`

Non-plugin keymaps:

- `<leader>pv` → `vim.cmd.Ex` (netrw as the explorer)
- Visual `J` / `K` → move selection down / up with reindent
- `J` (normal) → join lines keeping cursor in place (`mzJ\`z`)
- `<C-d>` / `<C-u>` → centered scroll
- `n` / `N` → centered search nav
- `<leader>y` / `<leader>Y` → yank to system clipboard
- `<leader>p` (visual) → paste without yanking
- `<leader>d` → delete to black hole register
- `Q` → `<nop>`
- `<C-h/j/k/l>` → window navigation
- `<leader>s` → project-wide rename of word under cursor (Prime's `:%s/\<word\>/word/gI` pattern)
- `<C-c>` (insert) → `<Esc>`
- `<leader>x` → `chmod +x %` (no-op on Windows but kept for consistency)

### `lua/mvim/lazy_init.lua`

Standard lazy.nvim bootstrap (clone if missing, prepend to rtp, import all specs from `mvim.lazy`).

### Plugin spec files

Each `lua/mvim/lazy/*.lua` returns a single lazy.nvim spec table or a list of them. Conventions:

- Use `event = "VeryLazy"` or `cmd = "..."` or `keys = {...}` for lazy-loading where it makes sense. Don't lazy-load colorschemes or treesitter.
- Each spec's `config = function() ... end` is the only place that plugin's setup runs.
- Buffer-local LSP keymaps live in a single `LspAttach` autocmd inside `lsp.lua`.

**Per-plugin notes:**

- **`colors.lua`** — installs all three colorschemes (`priority = 1000`, `lazy = false`), sets rose-pine as default via `vim.cmd.colorscheme("rose-pine")`. Adds `<leader>tc` keymap → opens telescope's built-in `colorscheme` picker for live preview switching.

- **`telescope.lua`** — keymaps: `<leader>pf` (find_files), `<C-p>` (git_files), `<leader>ps` (grep_string, prompts for text), `<leader>vh` (help_tags), `<leader>vb` (buffers). Default theme: `ivy` for full-width bottom layout.

- **`treesitter.lua`** — ensure_installed: `c`, `lua`, `vim`, `vimdoc`, `go`, `python`, `javascript`, `typescript`, `tsx`, `html`, `css`, `json`, `markdown`, `markdown_inline`, `yaml`. `highlight.enable = true`, `indent.enable = true`.

- **`harpoon.lua`** — same keymaps as current config: `<leader>a` add, `<C-e>` menu, `<leader>1..4` select.

- **`undotree.lua`** — `<leader>u` toggle.

- **`fugitive.lua`** — `<leader>gs` → `:Git`.

- **`gitsigns.lua`** — default opts, on_attach sets `]c` / `[c` for hunk nav and `<leader>hp` for preview hunk.

- **`lsp.lua`** — mason setup, mason-lspconfig with `ensure_installed = { "lua_ls", "gopls", "pyright", "ruff", "ts_ls" }`. Each server configured with `capabilities = require("cmp_nvim_lsp").default_capabilities()`. `LspAttach` autocmd sets: `gd`, `gD`, `gr`, `K`, `<leader>vrn`, `<leader>vca`, `[d`, `]d`. nvim-cmp configured with `cmp-nvim-lsp` + `cmp_luasnip` sources, `<CR>` confirms, `<C-Space>` triggers, `<C-n>` / `<C-p>` nav.

- **`conform.lua`** — same `formatters_by_ft` as current config: lua→stylua, go→goimports+gofumpt, python→ruff_format+ruff_organize_imports, js/ts/json/jsonc/yaml/md/html/css→prettierd. `format_on_save = { timeout_ms = 500, lsp_format = "fallback" }`. Manual format keymap `<leader>f`.

- **`copilot.lua`** — `cmd = "Copilot"`, suggestion = `{ enabled = false, auto_trigger = false }`, panel = `{ enabled = false }`. User runs `:Copilot enable` and `:Copilot auth` to activate.

- **`zenmode.lua`** — `<leader>tz` toggle, same opts as current (`width = 0.72`, hide signcolumn/numbers).

- **`whichkey.lua`** — minimal: `delay = 0`, no icons fluff, group labels for `<leader>p` (project), `<leader>v` (vim/lsp), `<leader>t` (toggle), `<leader>g` (git), `<leader>h` (hunk).

## Shell alias setup

Append to PowerShell `$PROFILE` (`Microsoft.PowerShell_profile.ps1`):

```powershell
function mvim {
    $env:NVIM_APPNAME = 'nvim-min'
    nvim @args
}
```

`Set-Alias` cannot be used because we need to set an env var first; a function is required.

## Verification / acceptance criteria

- `mvim` launches Neovim with no errors on `:checkhealth`.
- `<leader>pf` opens telescope find_files in the cwd.
- `:Telescope colorscheme` shows rose-pine, tokyonight, kanagawa selectable with live preview.
- Opening a `.go` file: `gopls` attaches (`:LspInfo` confirms), `gd` jumps to definition, save triggers gofumpt+goimports.
- Opening a `.py` file: `pyright` + `ruff` both attach, save triggers ruff format.
- `:Copilot` is available; `:Copilot status` reports disabled until user runs `:Copilot enable`.
- `<leader>tz` toggles zen-mode and centers the buffer.
- Original `nvim` config (without `NVIM_APPNAME` set) opens unchanged.

## Risks / known unknowns

- **Mason on Windows:** historically rougher than Linux. Some servers (especially ones requiring node) may need manual install. Workaround: install node-based servers globally via `npm i -g` and let lspconfig find them.
- **Treesitter parsers on Windows:** require a C compiler. User likely already has one (since current config works), but worth confirming during implementation.
- **Copilot auth:** first-time activation requires browser flow via `:Copilot auth`. Documented in acceptance criteria so user knows what to expect.

## Out of scope (explicitly)

- Dashboard / start screen — open to a blank buffer.
- Statusline customization — use Neovim's default.
- Tabline customization — none.
- File explorer beyond netrw.
- Debugger / DAP — Zed handles this.
- Testing framework (neotest) — Zed handles this.

## Implementation order (rough)

1. PowerShell `$PROFILE` alias.
2. Create `nvim-min` directory structure.
3. `init.lua`, `set.lua`, `remap.lua`, `lazy_init.lua` — verify `mvim` launches with zero plugins installed.
4. Add colorschemes spec — verify `:colorscheme rose-pine` works.
5. Add telescope + treesitter — verify `<leader>pf` works.
6. Add LSP spec — verify gopls / pyright / ts_ls attach.
7. Add conform — verify format on save.
8. Add harpoon, undotree, gitsigns, fugitive, zen-mode, which-key — verify keymaps.
9. Add copilot last (no activation).
10. Final acceptance pass against the checklist above.
