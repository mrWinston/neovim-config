local utils = {}
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
  local tele = require('telescope.builtin')
  local job = require('plenary.job')
  local stdout, ret = job:new({
    command = "git",
    args = { "branch", "--list", '--format', '%(refname:short)' },
  }):sync()
  vim.ui.select(stdout, {}, function(branch, _)
    require('diffview').open({ branch })
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
    if not name:match('nvim-tree') then
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

utils.set_table_default = function(table, default)
  local mt = { __index = function() return default end }
  setmetatable(table, mt)
end


return utils
