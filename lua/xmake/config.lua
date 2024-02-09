local M = {}

M.default = {
   verbose = true,

   compile_commands = {
      lsp = 'clangd',
   },

   build_directory = '/build',
   cache = vim.fn.stdpath('cache') .. '/xmake_',
   work_directory = vim.fn.getcwd() == vim.fn.getenv('HOME')
       and vim.fn.expand('%:p:h') or vim.fn.getcwd()
}
M.config = {}

function M.show_config()
   require('xmake.ui').show_config()
end

function M.init(config)
   config = config or {}

   M.config = vim.tbl_deep_extend('keep', config, M.default)
end

return M
