local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values

local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"


return function(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "gopass",
    finder = finders.new_oneshot_job({"gopass", "list", "--flat"}, {}),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
--        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local secret = selection[1]
        vim.fn.system({"gopass", "show", "-c", secret})
        --vim.api.nvim_put({ selection[1] }, "", false, true)
      end)
      actions.file_tab:replace(function ()
--       actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local secret = selection[1]
        vim.fn.system({"gopass", "otp", "-c", secret})
      end)
      return true
    end,
  }):find()
end
