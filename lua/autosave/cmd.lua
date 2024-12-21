local autosave = require('autosave')
local config = require('autosave.config')
local utils = require('autosave.utils')

---Used to keep track of the buffer's modified status
local modified = false

---Setter method for field `modified`
---
---@param value boolean
local function set_modified(value)
  modified = value
end

---Getter method for field `modified`
---
---@return boolean
local function get_modified()
  return modified
end

local M = {}

---Save buffer(s)
function M.save()
  -- skip if the buffer is readonly
  if vim.bo.readonly then
    return
  end

  if autosave.hook_before_saving ~= nil then
    autosave.hook_before_saving()
  end

  vim.g.auto_save_abort = false
  if vim.g.auto_save_abort then
    return
  end

  M.do_save()

  if autosave.hook_after_saving ~= nil then
    autosave.hook_after_saving()
  end
end

---Save buffer(s) if conditions are met
function M.do_save()
  if utils.assert_return(utils.assert_user_conditions(), true) then
    M.debounced_save()
  end
end

---Load autocmds
function M.load_autocmds()
  local debounce_delay = config.opts.debounce_delay
  if debounce_delay == 0 then
    M.debounced_save = M.save_actually
  else
    M.debounced_save = utils.debounce(M.save_actually, debounce_delay)
  end

  local events = table.concat(utils.get_events(), ',')
  vim.api.nvim_create_autocmd(events, {
    group = 'AUTOSAVE',
    pattern = '*',
    callback = function()
      require('autosave.cmd').save()
    end,
  })
end

---Unload autocmds
function M.unload_autocmds()
  local augroup = 'AUTOSAVE'
  vim.api.nvim_clear_autocmds({ group = augroup })
end

---Save buffer(s) actually
---
---If the buffer is modified, it will be saved.
---If the buffer is not modified, it will not be saved.
M.save_actually = function()
  if vim.api.nvim_eval('&modified') == 1 then
    if config.opts.write_all_buffers then
      vim.cmd('silent! wall')
    else
      vim.cmd('silent! write')
    end

    if get_modified() == nil or get_modified() == false then
      set_modified(true)
    end

    M.send_message()
  end
end

---Send message
function M.send_message()
  if get_modified() == true then
    set_modified(false)

    local prompt = config.opts.prompt
    -- stylua: ignore start
    local message = type(prompt.message) == 'function' and prompt.message() or tostring(prompt.message)
    -- stylua: ignore end
    if prompt.style == 'notify' then
      utils.notify(message)
    else
      print(message)
    end
  end
end

return M
