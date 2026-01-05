---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
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
    },
  },
}
