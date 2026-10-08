# Legacy AstroNvim backup

This directory preserves the 16 source-state files previously managed at
`dot_config/nvim`, unchanged, from commit
`2866ff8` (the Neovim tree is identical to remote commit
`875de30f2d06fb8f164c7516e5090831e197736a`).

The backup is inside `.chezmoitemplates`, so chezmoi does not deploy it.
Names such as `dot_neoconf.json` retain their original chezmoi encoding.
`AGENTS.md` describes the legacy AstroNvim tree only.

## Restore

1. Preserve the current LazyVim source and deployed configuration elsewhere.
2. Replace the chezmoi `dot_config/nvim` tree with this directory's original
   files, excluding this `BACKUP.md`.
3. Move the deployed `~/.config/nvim` aside before applying, so leftover
   LazyVim spec files cannot be imported by AstroNvim.
4. Review `chezmoi diff --recursive ~/.config/nvim` and
   `chezmoi apply --dry-run --verbose --recursive ~/.config/nvim`.
5. Apply that target and validate startup with a separate Neovim data directory
   before reusing existing plugins or Mason packages.

Alternatively, recover the original source directly from the Git commit above.
The old repository ignored `lazy-lock.json`; this is a configuration backup,
not an archive of the legacy plugin binaries or exact plugin revisions.
