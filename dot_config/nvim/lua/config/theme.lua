local M = {}

function M.path()
  if vim.g.dotfiles_omarchy_theme == false then
    return nil
  end
  local state = vim.env.XDG_STATE_HOME or (vim.fn.expand("~") .. "/.local/state")
  local path = state .. "/omarchy/current/theme/neovim.lua"
  return vim.fn.filereadable(path) == 1 and path or nil
end

function M.spec()
  local path = M.path()
  if path then
    local ok, spec = pcall(dofile, path)
    if ok and type(spec) == "table" then
      return spec
    end
    vim.schedule(function()
      vim.notify("Cannot load Omarchy theme; using tokyonight-night", vim.log.levels.WARN)
    end)
  end
  return {
    { "folke/tokyonight.nvim", priority = 1000 },
    { "LazyVim/LazyVim", opts = { colorscheme = "tokyonight-night" } },
  }
end

return M
