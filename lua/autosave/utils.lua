local api = vim.api
local fn = vim.fn

local config = require('autosave.config')

local default_opts = config.opts

local M = {}

---Display a notification to the user.
---
---@param message string
M.notify = function(message)
  local level = vim.log.levels.INFO
  local ok, notify = pcall(require, 'notify')
  if ok then
    vim.notify = notify
    vim.notify(message, level, { title = config.plugin_name })
  else
    vim.notify(message, level)
  end
end

---@return table
M.get_events = function()
  if next(default_opts['events']) == nil or default_opts['events'] == nil then
    return default_opts['events']
  else
    return default_opts['events']
  end
end

---Trailing debounce: every call resets the timer, so `lfn` only runs once the
---caller has been quiet for `duration` ms. This coalesces a burst of events
---(e.g. rapid insert<->normal switches during a long edit) into a single call
---that lands only after you pause, instead of firing on a fixed cadence.
---
---@param lfn function
---@param duration integer milliseconds of quiescence before `lfn` runs
---@return function
M.debounce = function(lfn, duration)
  local timer = (vim.uv or vim.loop).new_timer()

  return function()
    timer:stop()
    timer:start(duration, 0, function()
      timer:stop()
      -- The timer callback runs off the main loop; hop back before `lfn`
      -- touches buffers/vim APIs.
      vim.schedule(lfn)
    end)
  end
end

---@return table
M.assert_user_conditions = function()
  local sc_exists, sc_filename, sc_filetype, sc_modifiable = true, true, true, true

  for condition, value in pairs(default_opts['conditions']) do
    if condition == 'exists' then
      if value == true then
        if fn.filereadable(fn.expand('%:p')) == 0 then
          sc_exists = false
          break
        end
      end
    elseif condition == 'modifiable' then
      if value == true then
        if api.nvim_eval([[&modifiable]]) == 0 then
          sc_modifiable = false
          break
        end
      end
    elseif condition == 'filename_is_not' then
      local filename_is_not = default_opts['conditions']['filename_is_not']
      if not (next(filename_is_not) == nil) then
        if vim.tbl_contains(filename_is_not, vim.fn.expand('%:t')) == true then
          sc_filename = false
          break
        end
      end
    elseif condition == 'filetype_is_not' then
      local filetype_is_not = default_opts['conditions']['filetype_is_not']
      if not (next(filetype_is_not) == nil) then
        if vim.tbl_contains(filetype_is_not, vim.bo.filetype) == true then
          sc_filetype = false
          break
        end
      end
    end
  end

  return { sc_exists, sc_filename, sc_filetype, sc_modifiable }
end

---Return true for every x in values is equal with expected.
---If the values is empty, return true.
---
---@param values table
---@param expected any
---@return boolean
M.assert_return = function(values, expected)
  for _, value in pairs(values) do
    if value ~= expected then
      return false
    end
  end

  return true
end

return M
