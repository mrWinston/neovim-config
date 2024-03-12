local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local terminal = require("toggleterm.terminal")

local M = {}

M.tasks = {
  terraform = {
    {
      name = "terraform plan",
      cmd = "terraform plan",
    },
    {
      name = "terraform apply",
      cmd = "terraform apply",
    },
  },
  go = {
    {
      name = "go build",
      cmd = "go build",
    },
    {
      name = "go install",
      cmd = "go install",
    },
    {
      name = "go mod tidy",
      cmd = "go mod tidy",
    },
    {
      name = "go get under cursor",
      cmd = "go get -u '<cfile>'",
    },
  },
  ["*"] = {
    {
      name = "git update",
      cmd = "gitUpdate",
    },
  },
}

M.Pick = function()
  local current_filetype = vim.bo.filetype
  available_runners = {}
  for _, v in ipairs(M.tasks["*"]) do
    table.insert(available_runners, v)
  end

  if M.tasks[current_filetype] ~= nil then
    for _, v in ipairs(M.tasks[current_filetype]) do
      table.insert(available_runners, v)
    end
  end

  pickers
    .new({}, {
      prompt_title = "runlib",
      finder = finders.new_table({
        results = available_runners,
        entry_maker = function(entry)
          return {
            valid = true,
            value = entry,
            ordinal = entry.name,
            display = entry.name,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)

          local selection = action_state.get_selected_entry()
          if selection == nil or selection.value == nil then
            return true
          end
          local expanded_cmd = vim.fn.expandcmd(selection.value.cmd)
          local full_cmd = string.format("zsh -ic '%s'", expanded_cmd)
          local Terminal = terminal.Terminal
          local run_term = Terminal:new({
            direction = "horizontal",
            close_on_exit = false,
            on_create = function(term)
              term:send(expanded_cmd, false)
              term:send("exit", false)
            end,
          })
          run_term:toggle()
        end)
        return true
      end,
    })
    :find()
end

return M
