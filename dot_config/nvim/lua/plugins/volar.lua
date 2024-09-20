if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    config = {
      volar = {
        cmd = { "vue-language-server", "--stdio", "--max-old-space-size=4096" },
        settings = {
          vue = {
            server = {
              maxOldSpaceSize = 4096,
            },
          },
        },
      },
    },
  },
}
