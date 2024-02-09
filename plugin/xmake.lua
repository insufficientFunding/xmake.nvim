if vim.g.loaded_xmake then
   return
end

vim.g.loaded_xmake = true



local user_commands = require('xmake.usercommand')

vim.api.nvim_create_user_command('Xmake',
   user_commands.execute,
   {
      nargs = '*',
      complete = user_commands.complete,
      desc = 'Run xmake commands',
   })
