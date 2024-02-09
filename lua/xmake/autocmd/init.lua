local M = {}

function M.init()
   vim.api.nvim_create_autocmd(
      { 'BufWritePost', 'BufLeave' },
      {
         pattern = { 'xmake.lua' },
         callback = function(_)
            require('xmake.autocmd.compile-commands').rebuild()
            require('xmake.autocmd.project').rebuild()
         end
      }
   )
end

return M
