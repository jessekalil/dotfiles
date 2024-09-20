return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    mappings = {
      n = {
        -- mappings seen under group name "Undo"
        ["<Leader>um"] = { "<cmd>WindowsMaximize<cr>", desc = "Maximize Window" },
        ["<Leader>u="] = { "<cmd>WindowsEqual<cr>", desc = "Equalize Windows" },
        ["<Leader>c"] = {
          function()
            local bufs = vim.fn.getbufinfo { buflisted = 1 }
            require("astrocore.buffer").close(0)
            if require("astrocore").is_available "alpha-nvim" and not bufs[2] then require("alpha").start() end
          end,
          desc = "Close buffer",
        },
      },
    },
  },
}
