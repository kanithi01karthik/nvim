# Neovim Configuration

A personal Neovim configuration built on top of [LazyVim](https://www.lazyvim.org/) with custom integrations for **Google Antigravity Chat**, **WezTerm code execution**, **GitHub Copilot**, and **local Ollama AI**.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Directory Structure](#directory-structure)
- [Core Setup](#core-setup)
- [Plugin Reference](#plugin-reference)
- [Custom Integrations](#custom-integrations)
  - [Antigravity Chat Sidepane](#antigravity-chat-sidepane)
  - [Dual-Mode Code Runner](#dual-mode-code-runner)
  - [Debugger Pipeline](#debugger-pipeline)
  - [AI Autocompletion (Copilot + Ollama)](#ai-autocompletion-copilot--ollama)
- [Keybinding Reference](#keybinding-reference)
- [WezTerm Configuration](#wezterm-configuration)
- [Snippets](#snippets)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

| Tool                                                  | Purpose                        |
| ----------------------------------------------------- | ------------------------------ |
| [Neovim](https://neovim.io/) ≥ 0.10                   | Editor                         |
| [WezTerm](https://wezfurlong.org/wezterm/)            | Terminal emulator              |
| [Antigravity CLI (`agy`)](https://antigravity.google) | AI chat agent                  |
| [Node.js](https://nodejs.org/)                        | Required by many LSP servers   |
| [Python 3](https://python.org/)                       | Python execution & Pyright LSP |
| GCC / G++                                             | C/C++ compilation              |
| [fzf](https://github.com/junegunn/fzf) ≥ 0.53         | Fuzzy finder backend           |
| [Ollama](https://ollama.com/)                         | Local AI models (optional)     |
| [JetBrains Mono](https://www.jetbrains.com/lp/mono/)  | Terminal font                  |

---

## Directory Structure

```
~/.config/nvim/
├── init.lua                  # Entry point: leader key, netrw disable, module loading
├── lazy-lock.json            # Plugin version lockfile
├── lazyvim.json              # LazyVim metadata
├── .wezterm.lua              # WezTerm terminal configuration
├── .zshrc                    # Shell config stub
├── snippets/
│   └── cpp.json              # Competitive programming C++ snippets
└── lua/
    ├── vim-opts.lua           # Editor options & transparency settings
    ├── keymaps.lua            # All custom keybindings
    ├── config/
    │   └── lazy.lua           # Lazy.nvim bootstrap & plugin spec loading
    ├── plugins/
    │   ├── autopairs.lua      # Auto-close brackets/quotes
    │   ├── conform.lua        # Code formatting (stylua, prettierd, clang-format)
    │   ├── copilot.lua        # GitHub Copilot ghost-text completions
    │   ├── debug.lua          # Debugger pipeline configuration
    │   ├── fzf-lua.lua        # Fuzzy finder (custom fzf binary path)
    │   ├── lint.lua           # Async linting (eslint_d)
    │   ├── live-server.nvim.lua # Live web server preview
    │   ├── lsp.lua            # LSP servers (lua_ls, pyright, clangd, ts_ls, etc.)
    │   ├── lualine.lua        # Statusline
    │   ├── neo-tree.lua       # File explorer with transparent background
    │   ├── ollama.lua         # Local AI via Ollama (gen.nvim + minuet-ai)
    │   ├── runner.lua         # Dual-mode (buffer/terminal) code runner
    │   ├── telescope.lua      # Telescope + ast-grep extension
    │   ├── theme.lua          # Catppuccin Mocha colorscheme
    │   ├── treesitter.lua     # Syntax highlighting
    │   └── which-key.lua      # Keybinding popup helper
    └── utils/
        ├── antigravity.lua    # Antigravity Chat sidepane integration
        ├── keydebug.lua       # Key capture debugging utility
        ├── lazy.lua           # Safe module loading helpers
        └── telescope.lua      # Telescope picker wrappers
```

---

## Core Setup

### `init.lua`

Sets the leader key to `<Space>`, disables netrw (in favor of Neo-tree), and loads three modules in order:

1. **`vim-opts`** — Editor options and UI transparency
2. **`keymaps`** — All custom keybindings
3. **`config.lazy`** — Lazy.nvim bootstrap and plugin loading

### `vim-opts.lua`

- System clipboard integration (`unnamedplus`)
- Opaque popups/floats (`pumblend=0`, `winblend=0`)
- Transparent main editor background with opaque floating windows
- Dark background mode
- Extra sign column padding

### `config/lazy.lua`

Bootstraps [lazy.nvim](https://github.com/folke/lazy.nvim) from GitHub, imports LazyVim's default plugin set, then loads all specs from `lua/plugins/`.

---

## Plugin Reference

| Plugin                            | File                   | Purpose                                                      |
| --------------------------------- | ---------------------- | ------------------------------------------------------------ |
| `windwp/nvim-autopairs`           | `autopairs.lua`        | Auto-close brackets, quotes, tags                            |
| `stevearc/conform.nvim`           | `conform.lua`          | Formatting: stylua, prettierd, clang-format                  |
| `github/copilot.vim`              | `copilot.lua`          | Inline AI ghost-text completions                             |
| `ibhagwan/fzf-lua`                | `fzf-lua.lua`          | Fuzzy finder with custom fzf binary                          |
| `mfussenegger/nvim-lint`          | `lint.lua`             | Async linting with eslint_d                                  |
| `barrettruth/live-server.nvim`    | `live-server.nvim.lua` | Live web development preview                                 |
| `neovim/nvim-lspconfig`           | `lsp.lua`              | LSP: lua_ls, pyright, clangd, ts_ls, eslint, emmet, ast_grep |
| `nvim-lualine/lualine.nvim`       | `lualine.lua`          | Statusline (auto theme)                                      |
| `nvim-neo-tree/neo-tree.nvim`     | `neo-tree.lua`         | File explorer (transparent bg, auto-open on dirs)            |
| `David-Kunz/gen.nvim`             | `ollama.lua`           | Ollama chat (qwen2.5-coder:7b)                               |
| `milanglacier/minuet-ai.nvim`     | `ollama.lua`           | Ollama inline completions                                    |
| `CRAG666/code_runner.nvim`        | `runner.lua`           | Dual-mode (buffer/terminal) code execution                   |
| `jay-babu/mason-nvim-dap.nvim`    | `debug.lua`            | Auto-install debug adapters (JS, Python, Java, C/C++)         |
| `rcarriga/nvim-dap-ui`            | `debug.lua`            | UI interface layout for nvim-dap                             |
| `mfussenegger/nvim-dap`           | `debug.lua`            | Core DAP client and compiler configurations                  |
| `nvim-telescope/telescope.nvim`   | `telescope.lua`        | Fuzzy finder + ast-grep extension                            |
| `catppuccin/nvim`                 | `theme.lua`            | Catppuccin Mocha colorscheme                                 |
| `nvim-treesitter/nvim-treesitter` | `treesitter.lua`       | Syntax highlighting / parsing                                |
| `folke/which-key.nvim`            | `which-key.lua`        | Keybinding discovery popup                                   |

---

## Custom Integrations

### Antigravity Chat Sidepane

**File:** `lua/utils/antigravity.lua`

Wraps the Google Antigravity CLI (`agy`) inside a native WezTerm split pane on the right side of the screen when running under WezTerm. This completely bypasses any vertical split scroll rendering glitches inside Neovim. It falls back to a native Neovim split pane when running outside of WezTerm.

#### How It Works

1. **Toggle Open:** Press `<leader>ac` → checks if an `agy` pane is open in the current WezTerm tab. If not, WezTerm opens a vertical split pane on the right (30% width) and launches `agy`.
2. **Toggle Close:** Press `<leader>ac` again from Neovim, or type `/exit` / press `Ctrl+D` inside the chat pane → the pane is automatically killed and closed.
3. **Focus Switching:** Use your WezTerm pane switching keys (e.g. `Alt+S` then `l`/`j`) to navigate between Neovim and the chat pane.

#### Technical Details

- **Zero Neovim rendering bugs:** Because WezTerm multiplexes the layout, scrolling inside the chat pane is handled natively and will never cause the adjacent Neovim buffer splits to render black screens or glitch.
- **No exit blocking:** Quitting Neovim (`:wqa` / `:qa`) is never blocked by the chat session, as the `agy` process runs in a native terminal pane independent of Neovim's process tree.
- **Smart Fallbacks:** If launched outside of WezTerm, it falls back to a clean, vertical Neovim terminal split buffer on the right, configured with a `QuitPre` autocmd to safely clean up the process on exit.

---

### Dual-Mode Code Runner

**File:** [runner.lua](file:///home/karthik-kanithi/.config/nvim/lua/plugins/runner.lua)

Configures the `code_runner.nvim` plugin to run C, C++, and Python files using one of two execution pipelines. You can toggle between these modes at any time by pressing `<leader>rt`.

#### 1. Buffer I/O Mode (Default)
Useful for writing code with copy-pasted or predefined inputs without spawning external windows.

- **How It Works**:
  1. Press `<leader>rr` in a source file.
  2. The current file is automatically saved.
  3. Two scratch buffers are opened at the bottom:
     - `[Input]` pane on the left (height: 12 lines) where you can type or paste program inputs.
     - `[Output]` pane on the right.
  4. Paste/type your inputs in the `[Input]` pane, then press `<CR>` (Enter) in Normal Mode to run.
  5. The output streams in real-time to the `[Output]` pane and auto-scrolls to the end.
  6. Press `q` in Normal Mode on either pane to instantly terminate the job and close both buffers.

#### 2. Terminal Mode (Interactive)
Useful for interactive code execution (e.g., standard input prompting via terminal prompts) or running scripts that require full terminal emulation.

- **How It Works**:
  1. Toggle to Terminal Mode with `<leader>rt`.
  2. Press `<leader>rr` in a source file.
  3. The current file is automatically saved.
  4. WezTerm opens a native bottom split pane (30% height) executing the program interactively.
  5. Interactive terminal prompts (`std::cin`, `scanf`, `input()`, etc.) work natively.
  6. Press `Enter` in the terminal pane to close it when execution finishes.

#### Compiler Pipelines

| Language       | Compile Command             | Target Binary    |
| -------------- | --------------------------- | ---------------- |
| C (`.c`)       | `gcc {file} -o /tmp/{name}` | `/tmp/{name}`    |
| C++ (`.cpp`)   | `g++ {file} -o /tmp/{name}` | `/tmp/{name}`    |
| Python (`.py`) | —                           | `python3 {file}` |

---

### Debugger Pipeline

**File:** [debug.lua](file:///home/karthik-kanithi/.config/nvim/lua/plugins/debug.lua)

Configures the Neovim debugging environment via `nvim-dap`, `mason-nvim-dap.nvim`, and `nvim-dap-ui` for seamless automated debug adapter management and a visual debug layout.

#### Features
- **Auto-Installation**: Automatically downloads and installs debug adapters for Python, JS/TS, C/C++/Rust, and Java via Mason.
- **Automated UI**: `nvim-dap-ui` automatically opens when a debugger session starts (`attach`/`launch`) and closes when terminated or exited.
- **Language Configurations**:
  - **JS/TS**: Configured using `js-debug-adapter` (adapter `pwa-node`) to launch scripts.
  - **Python**: Integrated with `debugpy` pointing to the virtualenv python runner.
  - **Java**: Runs with `java-debug-adapter` to attach to JVM (`:5005`) or launch Java main classes.
  - **C/C++/Rust**: Configured with `codelldb` to launch compiled binaries.

---

### AI Autocompletion (Copilot + Ollama)

A hybrid setup combining cloud and local AI:

| Tool                   | Purpose                       | Trigger                    |
| ---------------------- | ----------------------------- | -------------------------- |
| **GitHub Copilot**     | Inline ghost-text suggestions | Automatic as you type      |
| **Ollama (gen.nvim)**  | Interactive AI chat           | `<leader>oo`               |
| **Ollama (minuet-ai)** | Local inline completions      | Automatic on `InsertEnter` |
| **Antigravity**        | Full agentic AI assistant     | `<leader>ac`               |

Copilot's default `<Tab>` mapping is disabled; use `<C-J>` to accept suggestions.

---

## Keybinding Reference

### General

| Key          | Mode   | Action                   |
| ------------ | ------ | ------------------------ |
| `<leader>W`  | Normal | Save file                |
| `<leader>xr` | Normal | Find and replace in file |

### Line Movement

| Key             | Mode                 | Action                      |
| --------------- | -------------------- | --------------------------- |
| `<Alt-j>`       | Normal/Insert/Visual | Move line(s) down           |
| `<Alt-k>`       | Normal/Insert/Visual | Move line(s) up             |
| `<Shift-Alt-j>` | Normal/Visual        | Copy/duplicate line(s) down |
| `<Shift-Alt-k>` | Normal/Visual        | Copy/duplicate line(s) up   |

### Search & Navigation

| Key          | Mode   | Action                        |
| ------------ | ------ | ----------------------------- |
| `<leader>sg` | Normal | Live grep (Telescope)         |
| `<leader>ag` | Normal | AST-grep search (Telescope)   |
| `<C-n>`      | Normal | Toggle Neo-tree file explorer |

### AI & Chat

| Key          | Mode            | Action                           |
| ------------ | --------------- | -------------------------------- |
| `<leader>ac` | Normal/Terminal | Toggle Antigravity Chat sidepane |
| `<leader>oo` | Normal/Visual   | Ollama chat (gen.nvim)           |
| `<C-J>`      | Insert          | Accept Copilot suggestion        |
| `<leader>ct` | Normal          | Toggle Copilot on/off            |
| `<leader>cp` | Normal/Insert   | Accept Copilot suggestion        |

### Code Execution

| Key          | Mode   | Action                                   |
| ------------ | ------ | ---------------------------------------- |
| `<leader>rr` | Normal | Save and run code (using current mode)   |
| `<leader>rt` | Normal | Toggle Code Runner mode (Buffer/Terminal)|

### Debugging (!!WIP!)

| Key          | Mode   | Action                        |
| ------------ | ------ | ----------------------------- |
| `<leader>kk` | Normal | Capture raw key bytes (debug) |

### Mouse

| Key          | Action                              |
| ------------ | ----------------------------------- |
| Middle click | Disabled (redirected to left click) |

---

## WezTerm Configuration

**File:** `.wezterm.lua`

| Setting            | Value                |
| ------------------ | -------------------- |
| Font               | JetBrains Mono, 14pt |
| Color scheme       | Osaka Jade           |
| Opacity            | 80%                  |
| Decorations        | None (borderless)    |
| Tab bar            | Hidden               |
| Cursor             | Blinking bar         |
| Shell              | zsh (login)          |
| Close confirmation | Never prompt         |

### WezTerm Keybindings

| Key                  | Action                             |
| -------------------- | ---------------------------------- |
| `Alt+S` (Leader)     | Activate leader chord (1s timeout) |
| `Leader → W`         | Split pane up                      |
| `Leader → A`         | Split pane left                    |
| `Leader → S`         | Split pane down                    |
| `Leader → D`         | Split pane right                   |
| `Leader → Backspace` | Close current pane                 |
| `Ctrl+L`             | Next pane                          |
| `Ctrl+J`             | Previous pane                      |

---

## Snippets

### C++ Competitive Programming (`snippets/cpp.json`)

| Trigger  | Description                                                                     |
| -------- | ------------------------------------------------------------------------------- |
| `solven` | Multi-test-case template with includes, type aliases, loop macros, and fast I/O |
| `solve`  | Single-case template with the same boilerplate                                  |

## Both include: `bits/stdc++.h`, type aliases (`ll`, `vi`, `vll`), range-for macros, and fast I/O setup.

## Troubleshooting

### Antigravity Chat: Black screen on adjacent split when scrolling

This is resolved! The configuration now runs the Antigravity Chat in a native WezTerm split-pane layout, which completely isolates the scrolling rendering processes from Neovim. If running under the fallback vertical terminal split, check that you are running a modern terminal emulator, or update WezTerm.

### Antigravity Chat: Can't `:wqa` to exit

The `QuitPre` autocmd should handle this automatically. If it still blocks:

- Use `:qa!` to force-quit
- Or close the chat pane first with `<leader>ac`

### Code Runner: Buffer issues

- If buffers from a previous execution are left open, they are automatically cleaned up the next time you trigger `<leader>rr`.
- Pressing `q` in Normal Mode in either the `[Input]` or `[Output]` buffer will cleanly terminate the running process and wipe out both buffers.

### Copilot: Suggestions not appearing

- Check status: `:Copilot status`
- Toggle on/off: `<leader>ct`
- Ensure you're authenticated: `:Copilot setup`
