local api = vim.api
local cmd = vim.cmd

local config = require('autosave.config')
local autosave = require('autosave')
local utils = require('autosave.utils')

local default_opts = config.opts

-- Used to mark whether the file has been modified
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

function M.save()
  vim.g.auto_save_abort = false

  if autosave.hook_before_saving ~= nil then
    autosave.hook_before_saving()
  end

  if vim.g.auto_save_abort then
    return
  end

  M.do_save()

  if autosave.hook_after_saving ~= nil then
    autosave.hook_after_saving()
  end
end

function M.do_save()
  if utils.assert_return(utils.assert_user_conditions(), true) then
    M.debounced_save()
  end
end

function M.load_autocommands()
  if default_opts['debounce_delay'] == 0 then
    M.debounced_save = M.save_actually
  else
    M.debounced_save = utils.debounce(M.save_actually, default_opts['debounce_delay'])
  end

  local events = table.concat(utils.get_events(), ',')
  api.nvim_exec(
      [[
		aug AUTOSAVE
			au!
			au ]] .. events .. [[ * execute "lua require('autosave.cmd').save()"
		aug END
	]], false
  )
end

function M.unload_autocommands()
  api.nvim_exec(
      [[
		aug AUTOSAVE
			au!
		aug END
	]], false
  )
end

---Save buffer(s)
---
M.save_actually = function()
  if api.nvim_eval('&modified') == 1 then
    if default_opts['write_all_buffers'] then
      cmd('silent! wall')
    else
      cmd('silent! write')
    end

    if get_modified() == nil or get_modified() == false then
      set_modified(true)
    end

    M.send_message()
  end
end

function M.send_message()
  if get_modified() == true then
    set_modified(false)

    local style = default_opts['prompt_style']
    local prompt = default_opts['prompt_message']
    if prompt ~= nil and prompt ~= '' then
      message = type(prompt) == 'function' and prompt() or prompt
      if style == 'stdout' then
        print(message)
      elseif style == 'notify' then
        utils.notify(message)
      end
    end
  end
end

return M
