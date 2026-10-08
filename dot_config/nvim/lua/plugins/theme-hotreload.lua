return {
  {
    name = "theme-hotreload",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    priority = 1000,
    config = function()
      local group = vim.api.nvim_create_augroup("dotfiles_theme", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "LazyReload",
        callback = function()
          vim.schedule(function()
            local spec = require("config.theme").spec()
            local colorscheme, plugin_name
            for _, plugin in ipairs(spec) do
              if plugin[1] == "LazyVim/LazyVim" then
                colorscheme = plugin.opts and plugin.opts.colorscheme
              elseif plugin[1] then
                plugin_name = plugin.name or require("lazy.core.plugin").Spec.get_name(plugin[1])
              end
            end
            if type(colorscheme) ~= "string" then
              return
            end
            vim.o.background = "dark"
            local plugin = require("lazy.core.config").plugins[plugin_name]
            if plugin and plugin._.loaded then
              require("lazy.core.loader").reload(plugin)
            else
              require("lazy.core.loader").colorscheme(colorscheme)
            end
            vim.cmd.colorscheme(colorscheme)
            vim.cmd("redraw!")
          end)
        end,
      })

      -- lazy.nvim watches spec files, but the Omarchy theme lives outside them.
      local path = require("config.theme").path()
      if path then
        local poll = assert(vim.uv.new_fs_poll())
        poll:start(path, 1000, function(err)
          if not err then
            require("lazy.manage.reloader").reload({ { file = path, what = "changed" } })
          end
        end)
        vim.api.nvim_create_autocmd("VimLeavePre", {
          group = group,
          once = true,
          callback = function()
            poll:stop()
            poll:close()
          end,
        })
      end
    end,
  },
}
