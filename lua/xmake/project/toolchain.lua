local M = {}

local Command = require('xmake.command')
local Log = require('xmake.logging')

function M.open(callback)
   local ui = require('xmake.ui')
   local project = require('xmake.project')
   local options = require('xmake.project.options')

   ui.open_menu(options.toolchains, {
         top = 'XMake Toolchain',
         bottom = project.config.toolchain,
      },
      {
         on_submit = function(item)
            project.config.toolchain = item.text

            if type(callback) == 'function' then
               callback(item.text)
            end

            Command.execute({ 'xmake', 'config', '--mode=' .. item.text }, function()
               Log.info('Changed toolchain to ' .. item.text)
            end)
         end,
      }):mount()
end

return M
