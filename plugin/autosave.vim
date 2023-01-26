if exists("g:loaded_autosave")
    finish
endif
let g:loaded_autosave = 1

" Register commands
command! ASToggle lua require('autosave.action').toggle()
command! ASEnable lua require('autosave.action').enable()
command! ASDisable lua require('autosave.action').disable()
