local M = {}

local context_manager = require('plenary.context_manager')
local config = require('xmake.config').config

local function setup_target(reader)
   reader = reader:read('*a')

   local data = vim.json.decode(#reader ~= 0 and reader or '{}')
   local target = data[config.work_directory]

   return target ~= nil and target or { name = '', location = '' }
end

M.config = {
   platform = '',
   architeture = '',
   mode = '',
   toolchain = '',

   target = context_manager.with(context_manager.open(config.cache .. 'project_info.json', 'a+'), setup_target)
}

function M.init()
   local command = require('xmake.command')
   command.execute({ 'xmake', 'show' }, function(data)
      for item in data do
         local platform = string.match(item, 'plat: (.*)$')
         if platform then
            M.config.platform = platform
         end

         local architeture = string.match(item, 'arch: (.*)$')
         if architeture then
            M.config.architeture = architeture
         end

         local mode = string.match(item, 'mode: (.*)$')
         if mode then
            M.config.mode = mode
         end
      end
   end)

   command.execute({ 'xmake', 'config', '--buildir=' .. config.work_directory .. config.build_directory }, function()
      local options = require('xmake.project.options')
      options.init_targets()
      options.init_build_modes()
      options.init_platforms_and_architectures()
      options.init_toolchains()
   end)
end

return M
