local config = require('autosave.config')

local M = {}

---Entrance
---
---@param opts nil | table
M.setup = function(opts)
  config.setup(opts)

  opts = config.opts
  if opts['enable'] == true then
    vim.g.autosave_statte = true
    require('autosave.action').enable()
  else
    vim.g.autosave_state = false
  end
end

-- Hook function before activate the plugin
M.hook_before_enable = nil
-- Hook function after activate the plugin
M.hook_after_enable = nil

-- Hook function before disactivate the plugin
M.hook_before_disable = nil
-- Hook function after disactivate the plugin
M.hook_after_disable = nil

-- Hook function before saving
M.hook_before_saving = nil
-- Hook function after saving
M.hook_after_saving = nil

return M
