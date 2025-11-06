---@type LazySpec
return {
  "andweeb/presence.nvim",
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      -- customize the dashboard header
      opts.section.header.val = {
        -- "              ██  ██    ██       ",
        -- "              ██  ██  ██         ",
        -- "              ██  ████           ",
        -- "              ██  ██  ██         ",
        -- "         ███████  ██    ██       ",
        -- " ",
        "    ███    ██ ██    ██ ██ ███    ███",
        "    ████   ██ ██    ██ ██ ████  ████",
        "    ██ ██  ██ ██    ██ ██ ██ ████ ██",
        "    ██  ██ ██  ██  ██  ██ ██  ██  ██",
        "    ██   ████   ████   ██ ██      ██",
      }
      return opts
    end,
  },

  -- You can disable default plugins as follows:
  { "kevinhwang91/nvim-ufo", enabled = true },
  {
    "nvzone/typr",
    dependencies = "nvzone/volt",
    opts = {},
    cmd = { "Typr", "TyprStats" },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        disabled_filetypes = {
          statusline = { "alpha", "neo-tree", "lazy", "mason", "toggleterm", "TelescopePrompt" },
        },
      },
      sections = {
        lualine_a = { "mode", "tabs" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { --[["lsp_status",]]
          "fileformat",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
}
