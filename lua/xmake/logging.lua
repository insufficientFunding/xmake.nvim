local M = {}

local notify = require('notify')

function M.notify(message, level, title)
   title = title or 'xmake'

   notify.notify (message, level, {
      title = title,
      render = 'wrapped-compact',
   })end

function M.info(message, title)
   M.notify(message, vim.log.levels.INFO, title)
end

function M.warn(message, title)
   M.notify(message, vim.log.levels.WARN, title)
end

function M.debug (message, title)
   M.notify(message, vim.log.levels.DEBUG, title)
end

function M.error(message, title)
   M.notify(message, vim.log.levels.ERROR, title)
end

return M
