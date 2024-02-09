local M = {}

local Log = require('xmake.logging')

local available_commands = {
   ['build'] = require('xmake.execution.build').build,
   ['build-all'] = nil,
   ['clean'] = nil,
   ['clean-all'] = nil,
   ['show-config'] = require('xmake.config').show_config,
}

function M.complete(arg, cmd)
   local matches = {}

   local words = vim.split(cmd, ' ', { trimempty = true })
   if not vim.endswith(cmd, ' ') then
      table.remove(words, #words)
   end

   if #words == 1 then
      for command, _ in pairs(available_commands) do
         if vim.startswith(command, arg) then
            table.insert(matches, command)
         end
      end
   end

   return matches
end

function M.execute(command)
   if #command.fargs == 0 then
      require('xmake.project.menu').open()
      return
   end

   local command_function = available_commands[command.fargs[1]]
   if not command_function then
      return Log.error('Unknown command: ' .. command.fargs[1])
   end

   command_function(unpack(command.fargs, 2))
end

return M
