# AGENTS.md

## Read First
- Treat `init.lua` as the bootstrap only; `lua/lazy_setup.lua` is the real entrypoint for plugin wiring.
- Prefer executable config over comments or old plugin state.

## Repo Layout
- `lua/community.lua` controls AstroCommunity packs.
- `lua/plugins/astrocore.lua` owns Treesitter installs and keymaps.
- `lua/plugins/astrolsp.lua` owns LSP behavior, formatting, and handlers.
- `lua/plugins/astroui.lua` owns theme and UI icons.
- `lua/plugins/user.lua` is for local extras.

## Important Gotchas
- `lua/plugins/mason.lua`, `lua/plugins/none-ls.lua`, and `lua/polish.lua` are disabled by an early `return`; edits there do nothing until that guard is removed.
- AstroNvim will auto-enable installed Mason LSPs; an installed server can still start even if it is not listed in `ensure_installed`.
- If you want to stop one server, remove the Mason package or add a no-op handler in `lua/plugins/astrolsp.lua`.
- `:Mason` shows what is installed on disk, not what this repo currently asks for.

## Style
- Follow `.stylua.toml`: 2-space indent, double quotes, no call parentheses when Stylua would omit them.
- Keep Lua changes minimal; preserve the existing AstroNvim/Lazy spec shape.

## Verification
- There is no repo test suite or build pipeline here.
- For config changes, validate by starting Neovim and checking the affected plugin/LSP behavior.
