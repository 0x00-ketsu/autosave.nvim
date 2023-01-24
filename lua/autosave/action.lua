local autosave = require('autosave')
local autocmd = require('autosave.cmd')

local M = {}

---Toggle (enable if disabled, disable if enabled) the plugin
---
M.toggle = function()
  if (vim.g.autosave_state == true) then
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

  autocmd.load_autocommands()
  vim.g.autosave_state = true

  if autosave.hook_after_enable ~= nil then
    autosave.hook_after_enable()
  end
end

---Disactivate the plugin
---
M.disable = function()
  if (autosave.hook_before_disable ~= nil) then
    autosave.hook_before_disable()
  end

  autocmd.unload_autocommands()
  vim.g.autosave_state = false

  if (autosave.hook_after_disable ~= nil) then
    autosave.hook_after_disable()
  end
end

return M
