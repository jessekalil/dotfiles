# Portable LazyVim configuration

The Omarchy-based configuration is managed by chezmoi and also works without
Omarchy, including WSL. `init.lua` loads `lua/config/lazy.lua`.

## Requirements

- A Neovim version supported by the locked LazyVim revision (currently >= 0.11.2), Git, and network access on first plugin installation.
- A C compiler and tree-sitter CLI for parser installation; ripgrep and fd for search.
- A Nerd Font in the terminal for icons. Language servers and formatters are installed separately through Mason as needed.
- Plugin revisions are recorded in `lazy-lock.json`; use `:Lazy restore` to restore them. The former optional `gthelding/monokai-pro.nvim` theme was removed because its repository is unavailable.
- Automatic formatting and relative line numbers are disabled; Neo-tree is enabled.

## Theme

Omarchy's current theme has priority when available. Outside Omarchy, the
default is **tokyonight-night**. The generated theme at
`${XDG_STATE_HOME:-~/.local/state}/omarchy/current/theme/neovim.lua` is loaded
instead and watched for changes. `lua/plugins/theme.lua` is a regular portable
file, not a symlink. Missing Omarchy themes fall back to tokyonight-night.
Set `vim.g.dotfiles_omarchy_theme = false` before bootstrap to explicitly disable
the integration and always use tokyonight-night.
Transparency is reapplied on ColorScheme.

## Clipboard

- Normal local sessions use Neovim's native provider detection.
- WSL prefers `win32yank.exe` on PATH, then Wayland (WSLg with wl-clipboard).
  For reliable Windows clipboard read/write, install win32yank and ensure WSL
  interoperability is enabled. Otherwise OSC 52 copies through a compatible
  terminal; `p` reads the last Neovim yank, not external Windows clipboard data.
- tmux, SSH and herdr sessions forward copies with OSC 52, while using a local
  provider when available. Without a local provider, tmux paste reads its buffer;
  other sessions paste the last Neovim yank.
- Set `vim.g.clipboard_osc52 = false` to disable OSC 52 forwarding.
  `vim.g.clipboard_osc52_paste = true` opts into terminal clipboard queries when
  no local/tmux provider exists; unsupported terminals may time out.
- Terminal paste (usually Ctrl+Shift+V) is available independently of the provider.

## Chezmoi and backup

Edit `dot_config/nvim` in the chezmoi source. Preview and apply only this target:

```sh
chezmoi diff --recursive ~/.config/nvim
chezmoi apply --dry-run --verbose --recursive ~/.config/nvim
chezmoi apply --recursive ~/.config/nvim
```

When replacing an existing AstroNvim installation, move its deployed config
directory aside first: unmanaged old files in `lua/plugins` must not remain.
This source intentionally does not use `exact_` directories, which could remove
unmanaged files automatically.

The original AstroNvim source is preserved in
`.chezmoitemplates/legacy-nvim-astronvim/`, including `BACKUP.md` with restore
instructions. It is never deployed by chezmoi.
