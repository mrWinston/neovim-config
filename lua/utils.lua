local utils = {}

utils.generateGoStructTags = function()
  local caseOptions = {
    { value = "snakecase", show = "snake_case" },
    { value = "camelcase", show = "camelCase" },
    { value = "pascalcase", show = "PascalCase" },
    { value = "lispcase", show = "lisp-case" },
    { value = "keep", show = "Keep Naming" },
  }
  vim.ui.select(caseOptions, {
    prompt = "Select case conversion for struct tags:",
    format_item = function(item)
      return item.show
    end,
  }, function(item)
    vim.print(item.value)
    local fPath = vim.fn.expand("%:p")
    vim
      .system({
        "zsh",
        "-c",
        string.format("gomodifytags -file '%s' -w -all -add-tags 'json,yaml' -transform %s", fPath, item.value),
      }, { text = true })
      :wait()
  end)
end

utils.splitString = function(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

utils.open_link_under_cursor = function()
  local path = tostring(vim.fn.expand("<cfile>", false))
  local workdir = tostring(vim.fn.expand("%:h"))
  if workdir == "" then
    workdir = tostring(vim.fn.getcwd())
  end
  vim.system({ "xdg-open", path }, { text = true, cwd = workdir }, function() end)
end

utils.replaceAcronym = function()
  local current_word = vim.fn.expand("<cWORD>")
  local acronyms = require("tools.acronyms")
  local full_word = acronyms[current_word]
  if not full_word then
    return
  end
  local line = vim.fn.getline(".")
  local linesub = vim.fn.substitute(line, current_word, current_word .. " (" .. full_word .. ")", "g")
  vim.fn.setline(".", linesub)
end

utils.ticket_to_md_link = function()
  local current_word = vim.fn.expand("<cWORD>")
  local segments = utils.splitString(current_word, "/")
  local last_segment = segments[#segments]

  local line = vim.fn.getline(".")
  local link_text = string.format("[%s](%s)", last_segment, current_word)
  local linesub = vim.fn.substitute(line, current_word, link_text, "g")
  vim.fn.setline(".", linesub)
end

utils.increaseFoldLevel = function()
  if not vim.b.current_fold then
    vim.b.current_fold = 0
  end
  vim.b.current_fold = vim.b.current_fold + 1
  require("ufo").closeFoldsWith(vim.b.current_fold)
end

utils.decreaseFoldLevel = function()
  if not vim.b.current_fold then
    vim.b.current_fold = utils.getMaxFold()
  end
  vim.b.current_fold = vim.b.current_fold - 1
  require("ufo").closeFoldsWith(vim.b.current_fold)
end

utils.closeAllFolds = function()
  vim.b.current_fold = 0
  require("ufo").closeFoldsWith(vim.b.current_fold)
end

utils.openAllFolds = function()
  vim.b.current_fold = utils.getMaxFold()
  require("ufo").closeFoldsWith(vim.b.current_fold)
end

utils.getMaxFold = function()
  local curbuf = vim.api.nvim_get_current_buf()
  local total_lines = vim.api.nvim_buf_line_count(curbuf)
  local maxLevel = 0
  for i = 1, total_lines, 1 do
    if vim.fn.foldlevel(i) > maxLevel then
      maxLevel = vim.fn.foldlevel(i)
    end
  end
  return maxLevel
end

utils.goimpl = function()
  require("telescope").load_extension("goimpl")
  require("telescope").extensions.goimpl.goimpl({})
end

utils.onListHandler = function(items, title, context)
  vim.print("Im handling now!")
  vim.print(items)
end

utils.askHowToOpen = function(func)
  return function()
    local opts = {
      reuse_win = true,
    }
    local choice = vim.fn.confirm("Open in", "&Here\n&Split\n&Vsplit\n&Tab")
    if choice == 2 then
      opts.jump_type = "never"
    elseif choice == 3 then
      opts.jump_type = "never"
    elseif choice == 4 then
      opts.jump_type = "never"
    end
    func(opts)
  end
end

utils.cmdThenFunc = function(cmd, func)
  local embed = function()
    vim.cmd(cmd)
    func()
  end
  return embed
end

utils.createGitBranch = function()
  vim.ui.input({ prompt = "Branch Name:" }, function(branchName)
    if branchName ~= "" then
      vim.cmd("Git switch -c " .. branchName)
    end
  end)
end

utils.gitDiffBranch = function()
  local tele = require("telescope.builtin")
  local job = require("plenary.job")
  local stdout, ret = job
    :new({
      command = "git",
      args = { "branch", "--list", "--format", "%(refname:short)" },
    })
    :sync()
  vim.ui.select(stdout, {}, function(branch, _)
    require("diffview").open({ branch })
  end)
end

utils.wrapFunction = function(func, ...)
  local args = { ... }
  return function()
    func(unpack(args))
  end
end

utils.reloadConfig = function()
  for name, _ in pairs(package.loaded) do
    if not name:match("nvim-tree") then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
  vim.notify(string.format("Nvim configuration %s reloaded!", vim.env.MYVIMRC), vim.log.levels.INFO)
end

utils.toggleCheckbox = function()
  local curLine = vim.api.nvim_get_current_line()
  local newLine = curLine
  if string.find(curLine, "%[%S%]") ~= nil then
    newLine = string.gsub(curLine, "%[%S%]", "[ ]", 1)
  else
    newLine = string.gsub(curLine, "%[%s?%]", "[x]", 1)
  end
  vim.api.nvim_set_current_line(newLine)
end

utils.visual_selection_range = function()
  local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
  local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  if csrow < cerow or (csrow == cerow and cscol <= cecol) then
    return csrow - 1, cscol - 1, cerow - 1, cecol
  else
    return cerow - 1, cecol - 1, csrow - 1, cscol
  end
end

utils.toggle_autoformat = function()
  if not vim.g.disable_autoformat then
    vim.g.disable_autoformat = true
  else
    vim.g.disable_autoformat = false
  end
end

utils.set_table_default = function(table, default)
  local mt = {
    __index = function()
      return default
    end,
  }
  setmetatable(table, mt)
end

utils.toggle_peek = function()
  local peek = require("peek")
  if peek.is_open() then
    peek.close()
  else
    peek.open()
  end
end

local get_window_entry_maker = function()
  local Path = require("plenary.path")
  local telescope_utils = require("telescope.utils")
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
    vim.print(element)
    return element
  end
end

utils.openSpecificWindow = function()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local all_wins = vim.api.nvim_list_wins()
  local windows = {}
  for _, winnr in ipairs(all_wins) do
    local tabpage = vim.api.nvim_win_get_tabpage(winnr)
    local bufnr = vim.api.nvim_win_get_buf(winnr)
    local bufinfo = vim.fn.getbufinfo(bufnr)[1]

    table.insert(windows, {
      winnr = winnr,
      tabpage = tabpage,
      bufnr = bufnr,
      info = bufinfo,
    })
  end

  pickers
    .new({}, {
      prompt_title = "windows",
      finder = finders.new_table({
        results = windows,
        entry_maker = get_window_entry_maker(),
      }),
      previewer = conf.grep_previewer({}),
      sorter = conf.generic_sorter({}),
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
end

return utils
