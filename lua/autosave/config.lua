---@type OptConfig
local defaults = {
  enable = true,
  prompt = {
    enable = true,
    style = 'stdout',
    message = function()
      return 'Autosave: saved at ' .. vim.fn.strftime('%H:%M:%S')
    end,
  },
  events = { 'InsertLeave', 'TextChanged' },
  conditions = {
    exists = true,
    modifiable = true,
    filename_is_not = {},
    filetype_is_not = {},
  },
  write_all_buffers = false,
  debounce_delay = 135,
}

local M = { plugin_name = 'autosave.nvim' }

---@type OptConfig
M.opts = nil

---Assign options
---
---@param opts ASConfig?
M.setup = function(opts)
  M.opts = vim.tbl_deep_extend('force', {}, defaults, opts or {})
end

M.setup()

return M
