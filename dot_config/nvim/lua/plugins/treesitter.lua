---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    opts.ensure_installed = {
      "lua",
      "vim",
      "json",
      "yaml",
      "html",
      "css",
      "bash",
      "markdown",
      "dockerfile",
      "go",
      "typescript",
      "javascript",
      "vue",
      "brightscript",
    }

    require("nvim-treesitter.install").prefer_git = true
  end,
}
