local M = {}

local Command = require('xmake.command')
local Log = require('xmake.logging')

M.build_modes = {}
M.toolchains = {}
M.platforms_and_architectures = {}
M.targets = {}


local function iterate_config(type, callback, name, post_func)
   local config = require('xmake.config').config

   Command.execute({
         'xmake',
         'show',
         '--list=' .. type,
      },
      function(data)
         for item in data do
            callback(item)
         end

         if post_func then
            post_func(data)
         end
      end)

   if config.verbose then
      Log.info('Initialized ' .. name)
   end
end

function M.init_build_modes()
   M.build_modes = {}
   iterate_config('buildmodes', function(item)
      for mode in item:gmatch('mode%.(%w+)') do
         table.insert(M.build_modes, mode)
      end
   end, 'Build Modes')
end

function M.init_toolchains()
   M.toolchains = {}
   iterate_config('toolchains', function(item)
      local toolchain = item:match("^%s*([^%s]+)")
      if toolchain then
         table.insert(M.toolchains, toolchain)
      end
   end, 'Toolchains')
end

function M.init_platforms_and_architectures()
   M.platforms_and_architectures = {}
   iterate_config('architectures', function(item)
      local parts = {}
      for part in item:gmatch("%S+") do
         table.insert(parts, part)
      end
      local platform = table.remove(parts, 1)
      M.platforms_and_architectures[platform] = parts
   end, 'Platforms and Architectures')
end

local function is_nil_or_empty(value)
   if type(value) ~= 'string' then
      return true
   end
   return value == nil or value == ''
end

function M.init_targets()
   local project = require('xmake.project')

   M.targets = {}
   iterate_config(
      'targets',

      function(item)
         for target in item:gmatch('%S+') do
            table.insert(M.targets, target)
         end
      end,

      'Targets',

      function(data)
         project.config.target.name = not is_nil_or_empty(project.config.target.name) and project.config.target.name or
             M.targets[1]

         M.get_target_location()
      end)
end

function M.get_target_location()
   local project = require('xmake.project')
   local config = require('xmake.config').config

   local message = config.verbose and 'Initialized Target Locations' or nil

   Command.execute({ 'xmake', 'show', '--target=' .. project.config.target.name }, function(data)
      for item in data do
         local path = item:match("targetfile: (.-)$")
         if path ~= nil then
            project.config.target.location = config.work_directory .. path
            return
         end
      end
   end, message)
end

return M
