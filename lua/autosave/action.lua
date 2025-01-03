local autosave = require('autosave')
local cmd = require('autosave.cmd')

local M = {}

---Toggle (enable if disabled, disable if enabled) the plugin
---
M.toggle = function()
  if vim.g.autosave_state == true then
    M.disable()
  else
    M.enable()
  end
end

---Activate the plugin
---
M.enable = function()
  if autosave.hook_before_enable ~= nil then
    autosave.hook_before_enable()
  end

  cmd.load_autocmds()
  vim.g.autosave_state = true

  if autosave.hook_after_enable ~= nil then
    autosave.hook_after_enable()
  end
end

---Disactivate the plugin
---
M.disable = function()
  if autosave.hook_before_disable ~= nil then
    autosave.hook_before_disable()
  end

  cmd.unload_autocmds()
  vim.g.autosave_state = false

  if autosave.hook_after_disable ~= nil then
    autosave.hook_after_disable()
  end
end

return M
