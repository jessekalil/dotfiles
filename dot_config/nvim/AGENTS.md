# Neovim configuration

- `init.lua` bootstraps LazyVim through `lua/config/lazy.lua`.
- Edit the chezmoi source, not just the deployed files. Keep the configuration portable to Linux, WSL, macOS and Windows.
- `lua/plugins/` contains LazyVim specs; do not import the legacy AstroNvim files.
- `lua/config/theme.lua` prioritizes Omarchy's current theme when available and falls back to tokyonight-night elsewhere. Set `vim.g.dotfiles_omarchy_theme = false` to explicitly disable the integration. Never require an Omarchy installation or a machine-specific symlink.
- `lua/config/remote_clipboard.lua` selects WSL/native/remote clipboard behavior. OSC 52 reads are opt-in.
- Automatic formatting and relative line numbers are intentionally disabled.
- Track `lazy-lock.json`; changes to plugin versions must be deliberate.
- Follow `stylua.toml` and preserve existing settings unless the user requests changes.
- Validate startup and both optional-Omarchy and standalone behavior. Run chezmoi's recursive, target-scoped diff/dry-run before applying.
- Legacy source and restore instructions are in `.chezmoitemplates/legacy-nvim-astronvim/` in the chezmoi repository.
