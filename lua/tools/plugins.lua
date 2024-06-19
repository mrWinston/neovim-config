local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local previewers = require("telescope.previewers")

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local terminal = require("toggleterm.terminal")
require("telescope.sorters")
local a = require("plenary.async")

local curl = require("plenary.curl")

local M = {}

local generatePicker = function(searchterm)
  local query = {
    input = vim.fn.json_encode({ sorting = "popular", page = 1, query = searchterm }),
  }
  local res = curl.get("https://dotfyle.com/trpc/searchPlugins", {
    query = query,
  })

  local result = vim.fn.json_decode(res.body)

  return finders.new_table({
    results = result.result.data.data,
    entry_maker = function(entry)
      return {
        valid = true,
        value = entry,
        ordinal = entry.name,
        display = entry.name,
      }
    end,
  })
end

M.Pick = a.void(function()
  local searchterm = a.wrap(vim.ui.input, 2)({ prompt = "Enter searchterm" })

  local readme_previewer = previewers.new_termopen_previewer({
    get_command = function(entry, status)
      local url = entry.value.link
      url = url:gsub("github%.com", "raw.githubusercontent.com")
      url = url .. "/HEAD/README.md"

      return { "zsh", "-c", "curl -s " .. url .. " | glow" }
    end,
  })

  local default_action = function()
    local selection = action_state.get_selected_entry()
    if selection == nil or selection.value == nil then
      return true
    end

    vim.print(selection.value)
  end

  local plugin_picker = pickers.new({}, {
    prompt_title = "showplugs",
    finder = generatePicker(searchterm),
    previewer = readme_previewer,
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      map({ "i", "n" }, "<C-r>", function(_prompt_bufnr)
        local current_picker = action_state.get_current_picker(prompt_bufnr)
        local searchterm = action_state.get_current_line()
        current_picker:refresh(generatePicker(searchterm))
      end)
      actions.select_default:replace(function()
        local current_picker = action_state.get_current_picker(prompt_bufnr)
        local searchterm = action_state.get_current_line()
        local selection = action_state.get_selected_entry()
        if selection == nil or selection.value == nil then
          return true
        end
      end)
      return true
    end,
  })

  plugin_picker:find()
end)

return M
