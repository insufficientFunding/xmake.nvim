local M = {}

local function is_xmake_project()
   local files = require('plenary.scandir').scan_dir(
      require('xmake.config').config.work_directory,
      { depth = 1, search_pattern = 'xmake.lua' })

   if #files > 0 then
      return true
   end

   return false
end

function M.setup(user_config)
   local config = require('xmake.config')
   config.init(user_config)

   local workspace = config.config.work_directory;
   if type(workspace) == 'string' then
      print("hi")
      vim.cmd ('cd ' .. workspace)
   else
      vim.cmd ('cd ' .. table.concat(workspace, ''))
   end

   local notify = require 'notify'
   notify.setup {
      stages = 'fade',
      background_colour = '#000000',
      timeout = 2500,
      icons = {
         ERROR = '',
         WARN = '',
         INFO = '',
         DEBUG = '',
         TRACE = '✎'
      }
   }

   if not vim.system then
      return require('xmake.logging').error('xmake.nvim requires Neovim 0.10.0+')
   end

   if not is_xmake_project() then
      require('xmake.logging').info('xmake.nvim requires xmake.lua in the root directory')
      return
   end

   require('xmake.project').init()
   require('xmake.autocmd').init()
end

return M
