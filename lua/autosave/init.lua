local config = require('autosave.config')

local M = {}

---@param opts Config?
M.setup = function(opts)
  config.setup(opts)
  if config.opts.enable == true then
    vim.g.autosave_state = true
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
