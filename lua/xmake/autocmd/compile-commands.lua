local M = {}

function M.rebuild()
   local config = require('xmake.config').config
   local command = require('xmake.command')
   local log = require('xmake.logging')

   if vim.fn.expand('%:t') ~= 'xmake.lua' then
      return
   end

   if config.verbose then
      log.info('Rebuilding compile commands...')
   end

   local cmd = {
      'xmake',
      'project',
      '-k',
      'compile_commands',
      '--lsp=' .. config.compile_commands.lsp
   }

   command.execute(cmd, nil, 'Compile commands rebuilt')
end

return M
