local M = {}

local Command = require('xmake.command')
local Log = require('xmake.logging')

function M.open(callback)
   local ui = require('xmake.ui')
   local project = require('xmake.project')
   local options = require('xmake.project.options')

   ui.open_menu(options.platforms_and_architectures[project.config.platform], {
         top = 'XMake Architecture',
         bottom = ui.format_bottom_text(project.config.platform, project.config.architeture),
      },
      {
         on_submit = function(item)
            project.config.architecture = item.text

            if type(callback) == 'function' then
               callback(item.text)
            end

            Command.execute({ 'xmake', 'config', '--arch=' .. item.text }, function()
               Log.info('Changed architeture to ' .. item.text)
            end)
         end,
      }):mount()
end

return M
