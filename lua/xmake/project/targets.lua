local M = {}

local Command = require('xmake.command')
local Log = require('xmake.logging')

function M.open(callback)
   local ui = require('xmake.ui')
   local project = require('xmake.project')
   local options = require('xmake.project.options')

   ui.open_menu(options.targets, {
         top = 'XMake Targets',
         bottom = ui.format_bottom_text(project.config.target.name, project.config.mode),
      },
      {
         on_submit = function(item)
            if type(callback) == 'function' then
               callback(item.text)
            else
               project.config.target.name = item.text
            end

            require('xmake.autocmd.project').rebuild()

            Log.info(string.format('Target: %s', project.config.target.name))
         end,
      }):mount()
end

return M
