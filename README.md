# Autosave.nvim

A NeoVim plugin written in Lua that aims to automatically saving file(s) when changed.

## Requirements

Neovim version >= `0.9.0` (or [nightly](https://github.com/neovim/neovim/releases/tag/nightly))

>
> For Neovim `0.5.0` <= version < `0.9.0`, use tag `v1.0`.

## Features

- Automatically save the current file(s).
- Define conditions that files must meet to be saved (e.g., filetype, existence).
- Specify events that will trigger the plugin.
- Implement custom hooks (e.g., display a message when the plugin is enabled).
- Toggle the plugin's state (enable if disabled, disable if enabled).

**Screenshots**

<details>
<summary>prompt.style = 'stdout'</summary>
<img src="https://user-images.githubusercontent.com/16932133/214277152-21328c1c-438b-4f2b-87cd-ec13277e28b4.png"/>
</details>

<details>
<summary>prompt.style = 'notify'</summary>
<img src="https://user-images.githubusercontent.com/16932133/214277262-5d0237e0-71f1-4c00-bbab-227a55a24228.png"/>
</details>

## Installation

- [Lazy](https://github.com/folke/lazy.nvim)

  ```lua
  -- lua
  require('lazy').setup({
    '0x00-ketsu/autosave.nvim',
    -- lazy-loading on events
    event = { "InsertLeave", "TextChanged" },
    config = function()
      require('autosave').setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  })
  ```

- [Packer](https://github.com/wbthomason/packer.nvim)

  ```lua
  -- Lua
  use {
    '0x00-ketsu/autosave.nvim',
    config = function()
      require('autosave').setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }
  ```

## Setup

Following defaults:

```lua
require('autosave').setup(
    {
        enable = true,
        prompt = {
            enable = true,
            style = 'stdout',
            message = function()
            return 'Autosave: saved at ' .. vim.fn.strftime('%H:%M:%S')
            end,
        },
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
)
```

For details, check out the [Configuration](#Configuration) section.

## Commands

- `:ASToggle`: Toggle the plugin's activation state.
- `:ASEnable`: Activate this plugin.
- `:ASDisable`: Deactivate this plugin.

## Configuration

Although settings already have self-explanatory names, here is where you can find info about each one of them and their classifications!

### General

- **enable**: (`boolean`) if `true`, enables **autosave.nvim** at startup, same as `:ASEnable`.
- **prompt**: (`table`) prompt settings.
- **events**: (`table`): events that will trigger the plugin.
- **write_all_buffers**: (`boolean`) if `true`, writes to all modifiable buffers that meet the `conditions`.
- **debounce_delay**: (number) if greater than `0`, saves the file at most every `debounce_delay` milliseconds, vastly improving editing performance.
If `0` then saves are performed immediately after `events` occur.
It's recommend to leave the default value (`135`), which is just long enough to reduce unnecessary saves, but short enough that you don't notice the delay.

### Conditions

These are the conditions that every file must meet so that it can be saved. If every file to be auto-saved doesn't meet all of the conditions it won't be saved.

- **exists**: (`boolean`) if `true`, enables this condition. If the file doesn't exist it won't save it (e.g. if you `nvim stuff.txt` and don't save the file then this condition won't be met)
- **modifiable**: (`boolean`) if `true`, enables this condition. If the file isn't modifiable, then this condition isn't met.
- **filename_is_not**: (`table`, `string`) if there is one or more filenames (**should be array**) in the `table`, it enables this condition. Use this to exclude filenames that you don't want to automatically save.
- **filetype_is_not**: (`table`, `string`) if there is one or more filetypes (**should be array**) in the `table`, it enables this condition. Use this to exclude filetypes that you don't want to automatically save.

### Hooks

| Function             | Description  |
|----------------------|----------------------------------|
| `hook_before_enable()`     | Executed before the plugin is enabled |
| `hook_after_enable()`      | Executed after the plugin is enabled |
| `hook_before_disable()`    | Executed before the plugin is disabled |
| `hook_after_disable()`     | Executed after the plugin is disabled |
| `hook_before_saving()` | Executed before saving the file(s) |
| `hook_after_saving()`    | Executed after saving the file(s) |

**e.g.**

`hook_after_disable`

```lua
local autosave = require('autosave')
autosave.hook_after_disable = function ()
  print('Do sth after disactivate the plugin')
end
```

`hook_before_saving`

```lua
local autosave = require('autosave')
autosave.hook_before_saving = function ()
    if true then
      vim.g.auto_save_abort = true -- Save will be aborted
    end
end
```

## API

- Check if the plugin is enabled

  `vim.g.autosave_state` (variable type is `boolean`)

  **e.g.**

  ```lua
  local is_enable_autosave = vim.g.autosave_state and ' 💾 ' or ''
  ```

- Enable the plugin

  ```lua
  require('autosave.action').enable()
  ```

- Disable the plugin

  ```lua
  require('autosave.action').disable()
  ```

- Toggle (enable if disabled, disable if enabled) the plugin

  ```lua
  require('autosave.action').toggle()
  ```

## Thanks

- [pocco81/AutoSave.nvim](https://github.com/Pocco81/AutoSave.nvim)

## License

MIT
