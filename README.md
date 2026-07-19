# nvim config

Personal Neovim config built on [LazyVim](https://www.lazyvim.org/), covering
Python, TypeScript/JavaScript, Rust, Go, and Lua, plus GitHub Copilot +
Copilot Chat. Designed to be cloned onto any machine and just work — nothing
in this repo is OS-specific; `lazy.nvim` and `mason.nvim` handle fetching the
right binaries per platform on first launch.

## What's included

- **Base**: LazyVim core — LSP (`nvim-lspconfig` + `mason.nvim`), Treesitter,
  [Snacks](https://github.com/folke/snacks.nvim) (fuzzy finder/picker, file
  explorer, dashboard, and more), gitsigns, lualine, which-key, trouble.nvim
  (diagnostics list), `conform.nvim` (format-on-save), `tokyonight`
  colorscheme, `blink.cmp` (completion engine)
- **AI**: GitHub Copilot suggestions + Copilot Chat, wired into `blink.cmp`
- **Languages**: Python, TypeScript/JavaScript/JSON, Rust, Go — Lua support
  ships in LazyVim core, no extra needed
- **Markdown**: `marksman` LSP, `markdownlint-cli2` + `markdown-toc`
  formatting/linting, `render-markdown.nvim` (in-buffer rendering) and
  `markdown-preview.nvim` (live browser preview)

## Prerequisites

Required on every machine, regardless of OS:

- **Neovim >= 0.9** (developed/tested on 0.12.x)
- **git** — used by lazy.nvim to fetch plugins
- **A C compiler** — needed by Treesitter to compile parsers.
  - macOS/Linux: `clang` or `gcc` (usually already present, or one
    `xcode-select --install` / `apt install build-essential` away)
  - Windows: install **MinGW-w64 GCC** —
    `winget install --id=BrechtSanders.WinLibs.POSIX.UCRT -e`. `zig cc` is
    nvim-treesitter's official cross-platform recommendation, but on
    Windows it currently fails on
    this setup — the tree-sitter build tool passes it a Rust-style MSVC
    target triple (`x86_64-pc-windows-msvc`) that zig's own CLI can't
    parse, so MinGW GCC is the one that actually works here
- **ripgrep** and **fd** — required for Snacks' live grep / find files.
  Without `fd`, file finding falls back to a plain `find` command that
  doesn't work correctly on Windows. Install with:
  - macOS: `brew install ripgrep fd`
  - Linux: your package manager (e.g. `apt install ripgrep fd-find`)
  - Windows: `winget install --id BurntSushi.ripgrep.MSVC -e` and
    `winget install --id sharkdp.fd -e`
- **A [Nerd Font](https://www.nerdfonts.com/)** installed and selected in
  your terminal — otherwise icons in the UI (statusline, file explorer,
  completion menu, etc.) render as boxes

Required only for the language tooling you actually use (Mason installs
these automatically on first launch, but each one needs its runtime present
on `PATH` first):

- **Node.js + npm** — for JS/TS tooling (`typescript-language-server`,
  `prettier`, `biome`, `eslint`, JSON schema completion)
- **Python 3 + pip** — for `pyright`, `ruff`, `debugpy`. On Windows, watch
  out for the Microsoft Store's `python`/`python3` PATH stub — it looks
  like Python is installed but isn't; install the real thing with
  `winget install --id Python.Python.3.13 -e`
- **Go** — for `gopls`, `goimports`, `gofumpt`, `golangci-lint`, `delve`.
  `winget install --id GoLang.Go -e` on Windows
- **Rust + cargo** — not required for `rust-analyzer` itself (Mason fetches
  a prebuilt binary), but recommended so you can actually build/run Rust
  projects from the terminal

If a runtime is missing, the corresponding Mason install just fails quietly
in `:Mason` / `:checkhealth mason` — everything else keeps working.

## Install on a new machine

1. Install Neovim, git, and the prerequisites above.
2. Clone this repo into Neovim's config directory for your OS:
   - Linux/macOS: `~/.config/nvim`
   - Windows: `%LOCALAPPDATA%\nvim`
3. Launch `nvim`. On first run, lazy.nvim bootstraps itself, installs every
   plugin pinned in `lazy-lock.json`, and Mason downloads the LSP
   servers/formatters/debuggers declared by the language extras.
4. Run `:checkhealth`, `:checkhealth lazy`, and `:checkhealth mason` to
   confirm nothing's missing for your platform.

**Windows gotcha:** if you just installed Go/Python/a C compiler with
winget and Neovim still reports it missing, that's a stale `PATH` — Windows
only updates already-open terminals' environment on restart. Close the
terminal fully and open a new one before launching `nvim` again.

## Using it

Everything below is a LazyVim default, not custom to this config — the full
reference is [lazyvim.org/keymaps](https://www.lazyvim.org/keymaps). Leader
is `<space>`.

### Finding things (Snacks picker)

| Key | Action |
| --- | --- |
| `<leader><space>` / `<leader>ff` | Find files |
| `<leader>/` / `<leader>sg` | Live grep |
| `<leader>e` | Toggle file explorer |
| `<leader>fm` | Open mini.files at current file |
| `<leader>fp` | Switch project — picks from recent + detected repos, `cd`s into it. Inside the picker: `<C-e>`/`<C-f>`/`<C-g>` open the explorer/find-files/grep scoped to the highlighted project without leaving the picker |

### LSP

| Key | Action |
| --- | --- |
| `gd` | Goto definition |
| `gr` | References |
| `K` | Hover docs |
| `<leader>cr` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>cf` | Format buffer (also happens automatically on save) |
| `]d` / `[d` | Next/prev diagnostic |
| `<leader>xx` | Diagnostics list (Trouble) |

### Git (gitsigns)

| Key | Action |
| --- | --- |
| `<leader>gd` | Git diff (hunks) |
| `]h` / `[h` | Next/prev hunk |

### Markdown (in `.md` buffers)

| Key | Action |
| --- | --- |
| `<leader>cp` | Toggle live browser preview |
| `<leader>um` | Toggle in-buffer rendering |

### AI (Copilot)

| Key | Action |
| --- | --- |
| `<leader>aa` | Toggle Copilot Chat |
| `<leader>ax` | Clear Copilot Chat |
| `<leader>aq` | Quick Copilot Chat prompt |
| `<leader>ap` | Copilot prompt actions |
| `<leader>ab` | Add current buffer to Copilot Chat context |
| `<leader>as` (visual) | Add selection to Copilot Chat context |
| `Alt+]` / `Alt+[` | Cycle inline Copilot suggestions |

`<leader>ab`/`<leader>as` are custom (`lua/plugins/copilot-chat.lua`), not a
LazyVim default — they open the chat and drop `#buffer`/`#selection` on the
prompt line for you, same idea as VSCode's "add file/selection to chat".
Beyond that, type `#file:path/to/file` directly in the chat input (`<Tab>`
after `#` for path completion) to attach any other file.

Press `<space>` and wait — which-key pops up a menu of every available
leader binding, which is the fastest way to discover the rest.

## Structure

- `init.lua` — entrypoint, just `require("config.lazy")`
- `lua/config/lazy.lua` — lazy.nvim bootstrap + the plugin/extras spec
- `lua/config/options.lua`, `keymaps.lua`, `autocmds.lua` — personal
  overrides layered on top of LazyVim's own defaults
- `lua/plugins/` — your own custom plugin specs; add files here to extend or
  override anything from LazyVim/the extras
- `lua/plugins/snacks.lua` — where `<leader>fp` (project switcher) looks for
  projects: `dev` scans two levels deep under each listed parent for a repo
  root (`.git`, etc.); `projects` is an explicit list for standalone repos
  that don't live under one of those parents. Add new parent folders/repos
  here as you add them on disk
- `lazy-lock.json` — pins exact plugin commits; **commit changes to this
  file** after running `:Lazy update` so every machine stays in sync
- `lazyvim.json` — LazyVim's own state file (install version, seen
  changelog entries, extras enabled via `:LazyExtras`)

## Troubleshooting

- **"C compiler missing" at startup** — see the Windows gotcha above; most
  likely a stale `PATH` in your current terminal after installing GCC/zig.
  Confirm with `gcc --version` (or `cl`/`clang`) in a fresh terminal.
- **A Mason package won't install** — check `:Mason` for the specific
  error, or `~/.local/share/nvim/mason.log` (Linux/macOS) /
  `%LOCALAPPDATA%\nvim-data\mason.log` (Windows). Usually a missing runtime
  (Go/Python/Node) — see Prerequisites above.
- **Icons show as boxes/question marks** — your terminal isn't using a
  Nerd Font.
- **`<leader>cp` (markdown preview) does nothing** — its install step can
  fail silently with no visible error, leaving the plugin only half set up.
  Rerun it manually from the plugin's `app` directory
  (`%LOCALAPPDATA%\nvim-data\lazy\markdown-preview.nvim\app` on Windows,
  `~/.local/share/nvim/lazy/markdown-preview.nvim/app` on Linux/macOS):
  - **Windows**: `install.cmd` downloads a prebuilt binary from GitHub
    releases; this can fail if that API call gets rate-limited, with no
    visible error. Fix: find the latest tag at
    `https://github.com/iamcco/markdown-preview.nvim/releases/latest`,
    then run `install.cmd <tag>` (e.g. `install.cmd v0.0.10`) — passing the
    tag explicitly skips the auto-detection step that can fail. Make sure
    the binary ends up in `app\bin\`, not wherever your shell's current
    directory happens to be — the script uses relative paths.
  - **macOS/Linux**: `install.sh` runs `npm install` (or `yarn install`) in
    that directory to build `app/node_modules`. If it's missing, rerun
    `sh install.sh` there directly, or `npm install` if that also fails.
