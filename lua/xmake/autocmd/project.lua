local M = {}

function M.rebuild()
   local config = require("xmake.config").config

   local context_manager = require("plenary.context_manager")
   local open = context_manager.open
   local with = context_manager.with

   if vim.fn.expand('%:t') ~= 'xmake.lua' then
      return
   end

   local project_info = require("xmake.project").config.target
   require("xmake.project.options").init_targets()

   with(open(config.cache .. "project_info.json", "r"), function(reader)
      local data = reader:read("*a")
      data = vim.json.decode(#data ~= 0 and data or "{}")
      data[config.work_directory] = project_info

      with(open(config.cache .. "project_info.json", "w"), function(reader_)
         reader_:write(vim.json.encode(data))
      end)
   end)
end

return M
