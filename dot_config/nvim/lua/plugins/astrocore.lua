---@type LazySpec
return {
  "AstroNvim/astrocore",
  -- version = false,
  -- branch = "v3",
  ---@type AstroCoreOpts
  opts = {
    treesitter = {
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
      highlight = true,
    },
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        -- ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        -- ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
        --
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
        ["<Leader>le"] = { "<cmd>EslintFixAll<cr>", desc = "Eslint Fix All" },
        ["<Leader>xm"] = { ":%s/\\r//g<cr>", desc = "Remove Windows Line Endings" },
      },
    },
  },
}
