---@class Config
---@field enable boolean
---@field prompt Config.prompt
---@field events string[]
---@field conditions Config.conditions
---@field write_all_buffers boolean
---@field debounce_delay number

---@class Config.prompt
---@field enable boolean
---@field style string
---@field message string | fun(): string

---@class Config.conditions
---@field exists boolean
---@field modifiable boolean
---@field filename_is_not string[]
---@field filetype_is_not string[]
