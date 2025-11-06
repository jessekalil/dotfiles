if true then return {} end

-- Configuração básica de números de linha (híbrido nativo)
vim.opt.number = true
vim.opt.relativenumber = true

return {
  "rebelot/heirline.nvim",
  opts = function(_, opts)
    local status = require "astroui.status"

    opts.statuscolumn = {
      init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
      status.component.foldcolumn(),
      status.component.numbercolumn(),
      status.component.signcolumn(),
    }
  end,
}
