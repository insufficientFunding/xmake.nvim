local M = {}

local Log = require("xmake.logging")
local Command = require("xmake.command")

function M.build()
   local project = require('xmake.project')
   local config = project.config

   require('xmake.project.targets').open(function(selection)
      local target = string.format('%s(%s)', selection, config.mode)
      Log.info(string.format('Building project: %s', target))

      Command.execute ({'xmake', '-w', selection}, nil, 'Build complete')
   end)
end

return M
