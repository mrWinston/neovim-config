local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local get_window_entries = function()
  local all_wins = vim.api.nvim_list_wins()
  local windows = {}
  for _, winnr in ipairs(all_wins) do
    local tabpage = vim.api.nvim_win_get_tabpage(winnr)
    local bufnr = vim.api.nvim_win_get_buf(winnr)
    local bufinfo = vim.fn.getbufinfo(bufnr)[1]

    if bufinfo.listed ~= 0 then
      table.insert(windows, {
        winnr = winnr,
        tabpage = tabpage,
        bufnr = bufnr,
        info = bufinfo,
      })
    end
  end

  return windows
end

local get_window_entry_maker = function()
  local Path = require("plenary.path")
  local cwd = vim.fn.getcwd()

  return function(entry)
    local bufname = entry.info.name ~= "" and entry.info.name or "[No Name]"
    bufname = Path:new({ bufname }):normalize(cwd)
    local lnum = entry.info.lnum ~= 0 and entry.info.lnum or 1
    local element = {
      valid = true,
      value = bufname,
      ordinal = tostring(entry.winnr) .. " : " .. bufname,
      display = bufname,
      tabpage = entry.tabpage,
      winnr = entry.winnr,
      bufnr = entry.bufnr,
      filename = bufname,
      lnum = lnum,
    }
    return element
  end
end

return require("telescope").register_extension({
  setup = function(ext_config, config)
    -- access extension config and user config
  end,
  exports = {
    windows = function(opts)
      opts = opts or {}
      pickers
        .new(opts, {
          prompt_title = "windows",
          finder = finders.new_dynamic({
            fn = get_window_entries,
            entry_maker = get_window_entry_maker(),
          }),
          previewer = conf.grep_previewer(opts),
          sorter = conf.generic_sorter(opts),
          attach_mappings = function(_)
            actions.select_default:replace(function(bufnr)
              local entry = action_state.get_selected_entry(bufnr)
              actions.close(bufnr)
              local winnr = entry.winnr
              vim.api.nvim_set_current_win(winnr)
            end)
            return true
          end,
        })
        :find()
    end,
  },
})
