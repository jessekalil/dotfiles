-- Local clipboard when available, with OSC 52 forwarding in remote sessions.
-- No terminal clipboard queries by default: many terminals cannot answer them.
local M = {}

local function ancestor_process_named(name)
  local pid = vim.fn.getpid()
  for _ = 1, 16 do
    local ok, status = pcall(vim.fn.readfile, "/proc/" .. pid .. "/status")
    if not ok then
      return false
    end
    local parent
    for _, line in ipairs(status) do
      parent = parent or tonumber(line:match("^PPid:%s+(%d+)"))
    end
    if not parent or parent <= 1 then
      return false
    end
    local found, comm = pcall(vim.fn.readfile, "/proc/" .. parent .. "/comm")
    if found and (comm[1] or ""):find(name, 1, true) then
      return true
    end
    pid = parent
  end
  return false
end

function M.setup()
  -- Respect an explicitly configured clipboard provider.
  if vim.g.clipboard ~= nil then
    return
  end
  local in_tmux = vim.env.TMUX ~= nil
  local in_ssh = vim.env.SSH_TTY ~= nil or vim.env.SSH_CONNECTION ~= nil
  local remote = in_tmux or in_ssh or vim.env.HERDR_PANE_ID ~= nil or ancestor_process_named("herdr")
  local wsl = vim.env.WSL_DISTRO_NAME ~= nil
    or vim.env.WSL_INTEROP ~= nil
    or vim.uv.os_uname().release:lower():find("microsoft", 1, true) ~= nil

  local backend
  if wsl and not in_ssh and vim.fn.executable("win32yank.exe") == 1 then
    backend = "win32yank"
  elseif vim.env.WAYLAND_DISPLAY and vim.fn.executable("wl-copy") == 1 and vim.fn.executable("wl-paste") == 1 then
    backend = "wayland"
  elseif remote and vim.env.DISPLAY and vim.fn.executable("xclip") == 1 then
    backend = "xclip"
  end

  if not remote and not wsl then
    return -- Let Neovim select its native provider (Linux, macOS, Windows).
  end

  local osc52 = require("vim.ui.clipboard.osc52")
  local cache = { ["+"] = { {}, "v" }, ["*"] = { {}, "v" } }
  local function commands(register)
    if backend == "win32yank" then
      return { "win32yank.exe", "-i", "--crlf" }, { "win32yank.exe", "-o", "--lf" }
    elseif backend == "wayland" then
      local copy = { "wl-copy", "--sensitive", "--type", "text/plain" }
      local paste = { "wl-paste", "--no-newline" }
      if register == "*" then
        copy[#copy + 1], paste[#paste + 1] = "--primary", "--primary"
      end
      return copy, paste
    elseif backend == "xclip" then
      local selection = register == "*" and "primary" or "clipboard"
      return { "xclip", "-selection", selection, "-in" }, { "xclip", "-selection", selection, "-out" }
    end
  end

  local function copy(register)
    local emit = osc52.copy(register)
    return function(lines, regtype)
      cache[register] = { vim.deepcopy(lines), regtype }
      local cmd = commands(register)
      if cmd then
        vim.fn.system(cmd, table.concat(lines, "\n") .. (regtype == "V" and "\n" or ""))
      end
      local forward = vim.g.clipboard_osc52 ~= false and vim.g.omarchy_remote_clipboard_osc52 ~= false
      if forward and (remote or not backend) then
        emit(lines)
      end
    end
  end

  local function paste(register)
    return function()
      local _, cmd = commands(register)
      if not cmd and in_tmux and vim.fn.executable("tmux") == 1 then
        cmd = { "tmux", "save-buffer", "-" }
      end
      if cmd then
        local text = vim.fn.system(cmd)
        if vim.v.shell_error == 0 then
          text = text:gsub("\r\n", "\n")
          -- Preserve register type for our own yanks, including block selections.
          local saved = cache[register]
          local original = table.concat(saved[1], "\n") .. (saved[2] == "V" and "\n" or "")
          if text == original then
            return vim.deepcopy(saved)
          end
          local linewise = text:sub(-1) == "\n"
          if linewise then
            text = text:sub(1, -2)
          end
          return { vim.split(text, "\n", { plain = true }), linewise and "V" or "v" }
        end
      elseif vim.g.clipboard_osc52_paste == true then
        return osc52.paste(register)()
      end
      return vim.deepcopy(cache[register])
    end
  end

  vim.g.clipboard = {
    name = "PortableClipboard:" .. (backend or "osc52"),
    copy = { ["+"] = copy("+"), ["*"] = copy("*") },
    paste = { ["+"] = paste("+"), ["*"] = paste("*") },
    cache_enabled = 0,
  }
end

return M
