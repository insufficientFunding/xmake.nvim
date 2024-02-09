local M = {}

local Menu = require("nui.menu")
local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event
local config = require("xmake.config").config

local options = {
   size = { width = 25, height = 20 },
   bottom_text_format = "%s(%s)",
   border_style = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
}

function M.show_config()
   local popup = Popup {
      position = '50%',
      size = { width = 30, height = 15 },
      relative = 'editor',
      border = {
         style = 'rounded',
         padding = { 2, 2 },
         text = {
            top = 'XMake Configuration',
            top_align = 'center',
         },
      },
   }

   popup:mount()

   popup:on(event.BufLeave, function()
      popup:unmount()
   end)

   local project = require('xmake.project').config
   vim.api.nvim_buf_set_lines(popup.bufnr, 0, 5, false, {
      'Verbose: ' .. (config.verbose and 'true' or 'false'),
      'Target:' .. (project.target.name or 'NaN'),
      'Build Mode: ' .. (project.mode or 'NaN'),
      'Platform: ' .. (project.platform or 'NaN'),
      'Architecture: ' .. (project.architecture or 'NaN'),
      'Toolchain: ' .. (project.toolchain or 'NaN'),
   })

end

function M.open_menu(items, text, callbacks)
   local menu_items = {}
   for _, item in pairs(items) do
      table.insert(menu_items, Menu.item(item))
   end

   callbacks = callbacks or {}
   text = text or {}

   return Menu({
      position = '50%',
      size = options.size,
      relative = 'editor',
      border = {
         text = {
            top = text.top,
            top_align = 'center',
            bottom = text.bottom,
            bottom_align = 'right',
         },
         style = options.border_style,
      },
   }, {
      lines = menu_items,
      on_change = callbacks.on_change,
      on_close = callbacks.on_close,
      on_submit = callbacks.on_submit,
      keymap = {
         focus_next = { 'j', '<Down>', '<Tab>' },
         focus_prev = { 'k', '<Up>', '<S-Tab>' },
         submit = { '<CR>', '<Space>' },
         close = { 'q', '<Esc>' },
      },
   })
end

function M.format_bottom_text(x, y)
   if not (x or y) then
      return ""
   end

   return options.bottom_text_format:format(x, y)
end

return M
