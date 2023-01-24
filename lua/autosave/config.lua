local defaults = {
  enable = true,
  prompt_style = 'stdout',
  prompt_message = function()
    return 'Autosave: saved at ' .. vim.fn.strftime('%H:%M:%S')
  end,
  events = {'InsertLeave', 'TextChanged'},
  conditions = {
    exists = true,
    modifiable = true,
    filename_is_not = {},
    filetype_is_not = {}
  },
  write_all_buffers = false,
  debounce_delay = 135
}

local M = {plugin_name = 'autosave.nvim'}

M.setup = function(opts)
  M.opts = vim.tbl_deep_extend('force', {}, defaults, opts or {})
end

M.setup()

return M
