local M = {}

local function remove_ansii_code(str)
   if str == nil then
      return ""
   end

   str = str:gsub("\x1b%[%d+;%d+;%d+;%d+;%d+m", "")
       :gsub("\x1b%[%d+;%d+;%d+;%d+m", "")
       :gsub("\x1b%[%d+;%d+;%d+m", "")
       :gsub("\x1b%[%d+;%d+m", "")
       :gsub("\x1b%[%d+m", "")
   return str
end


local function schedule_wrap(cmd, callback, message)
   local log = require('xmake.logging')
   local config = require('xmake.config').config

   return vim.schedule_wrap(function(completed)
      local status = remove_ansii_code(completed.stdout)
      local error = remove_ansii_code(completed.stderr)

      if config.verbose then
         log.warn(cmd, 'command ran')
         log.warn(status, 'command status')
         log.warn(error, 'command error')
      elseif completed.code ~= 0 then
         log.error(string.format('Command failed (CODE %s): \n%s', completed.code, table.concat(cmd, ' ')))
      end

      if type(callback) == 'function' then
         callback(status:gmatch('[^\n]+'))
      end

      if message then
         log.info(message)
      end
   end)
end

function M.execute(cmd, callback, message)
   local config = require('xmake.config').config

   local wrap_callback = schedule_wrap(cmd, callback, message)

   vim.system(cmd, {
      cwd = config.work_directory,
      text = true,
   }, wrap_callback)
end

return M
