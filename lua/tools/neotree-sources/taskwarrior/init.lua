--This file should have all functions that are in the public api and either set
--or read the state of this source.

local vim = vim
local renderer = require("neo-tree.ui.renderer")
local manager = require("neo-tree.sources.manager")
local events = require("neo-tree.events")
local utils = require("neo-tree.utils")

local M = {
  -- This is the name our source will be referred to as
  -- within Neo-tree
  name = "taskwarrior",
  -- This is how our source will be displayed in the Source Selector
  display_name = "留Taskwarrior",
}

---Returns the stats for the given node in the same format as `vim.loop.fs_stat`
---@param node table NuiNode to get the stats for.
--- Example return value:
---
--- {
---   birthtime {
---     sec = 1692617750 -- seconds since epoch
---   },
---   mtime = {
---     sec = 1692617750 -- seconds since epoch
---   },
---   size = 11453, -- size in bytes
--- }
--
---@class StatTime
--- @field sec number
---
---@class StatTable
--- @field birthtime StatTime
--- @field mtime StatTime
--- @field size number
---
--- @return StatTable Stats for the given node.
M.get_node_stat = function(node)
  -- This is just fake data, you'll want to replace this with something real
  return {
    birthtime = { sec = 1692617750 },
    mtime = { sec = 1692617750 },
    size = 11453,
  }
end

---Navigate to the given path.
---@param path string Path to navigate to. If empty, will navigate to the cwd.
M.navigate = function(state, path)
  if path == nil then
    path = vim.fn.getcwd()
  end
  state.path = path

  local all_tags = {}

  local granite = require("granite")
  local openTodos = granite.get_all_todos({ states = { "OPEN", "IN_PROGRESS" } })
  items = {}
  for _, value in ipairs(openTodos) do
    for _, tag in ipairs(value.tags) do
      if all_tags[tag] == nil then
        all_tags[tag] = {}
      end
      table.insert(all_tags[tag], value)
    end
  end

  for tag, todos in pairs(all_tags) do
    local dir_node = {
      id = tag,
      name = tag,
      type = "directory",
      stat_provider = "taskwarrior-custom",
      children = {},
    }

    for _, todo in ipairs(todos) do
      table.insert(dir_node.children, {
        id = string.format("%s#%s#%d", todo.filename, tag, todo.lnum),
        name = todo.text,
        type = "task",
        stat_provider = "taskwarrior-custom",
      })
    end
    table.insert(items, dir_node)
  end

  renderer.show_nodes(items, state)
end

---Configures the plugin, should be called before the plugin is used.
---@param config table Configuration table containing any keys that the user
---wants to change from the defaults. May be empty to accept default values.
M.setup = function(config, global_config)
  -- redister or custom stat provider to override the default libuv one
  require("neo-tree.utils").register_stat_provider("taskwarrior-custom", M.get_node_stat)
  -- You most likely want to use this function to subscribe to events
  if config.use_libuv_file_watcher then
    manager.subscribe(M.name, {
      event = events.FS_EVENT,
      handler = function(args)
        manager.refresh(M.name)
      end,
    })
  end
end

return M
