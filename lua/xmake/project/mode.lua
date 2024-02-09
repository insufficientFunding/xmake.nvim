local M = {}

local Command = require('xmake.command')
local Log = require('xmake.logging')

function M.open(callback)
   local ui = require('xmake.ui')
   local project = require('xmake.project')
   local options = require('xmake.project.options')

   ui.open_menu(options.build_modes, {
         top = 'XMake Build Mode',
         bottom = ui.format_bottom_text(project.config.target.name, project.mode),
      },
      {
         on_submit = function(item)
            project.config.mode = item.text

            if type(callback) == 'function' then
               callback(item.text)
            end

            Command.execute({ 'xmake', 'config', '--mode=' .. item.text }, function()
               Log.info('Changed build mode to ' .. item.text)
            end)
         end,
      }):mount()
end

return M
