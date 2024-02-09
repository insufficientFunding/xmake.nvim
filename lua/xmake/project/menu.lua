local M = {}

local MenuOptions = {
   ['Target'] = require('xmake.project.targets').open,
   ['Build Mode'] = require('xmake.project.mode').open,
   ['Platform'] = require('xmake.project.platform').open,
   ['Architecture'] = require('xmake.project.architecture').open,
   ['Toolchain'] = require('xmake.project.toolchain').open,
}

function M.open()
   local ui = require('xmake.ui')
   local config = require('xmake.config').config
   local project = require('xmake.project')

   ui.open_menu(vim.tbl_keys(MenuOptions), {
         top = 'XMake Configuration',
         bottom = ui.format_bottom_text(project.config.target.name, project.mode),
      },
      {
         on_submit = function(item)
            MenuOptions[item.text]()
         end,
      }):mount()
end

return M
