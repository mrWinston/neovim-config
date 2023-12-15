local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function splitstring(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

local stringEntryMaker = function(entry)
  return {
    value = entry,
    display = entry,
    ordinal = entry,
  }
end

---Run a shell command and return stderr and out, as well as the code
---@param cmd string the command to run in the default shell
---@return string Stdout of the command
---@return string stderr of the command
---@return boolean success return true if command returned successfully, false otherwise
local shellMustSucceed = function(cmd)
  local cmdOut = vim.system({ "zsh", "-c", cmd }, { text = true }):wait()
  return cmdOut.stdout, cmdOut.stderr, cmdOut.code == 0
end

M = {}

M.OcmLogin = function() end

M.Login = function()
  local cluster = vim.fn.expand("<cWORD>")
  vim.notify("Logging in to cluster: " .. cluster)
  local out, err, suc = shellMustSucceed("ocm backplane login " .. cluster)
  vim.notify(out)
  if not suc then
    vim.notify(err)
  end
end

M.apiresources = {
  "pods",
  "namespaces",
  "clusteroperators",
  "persistentvolumes",
}
M.lastresource = "pods"

M.namespace = "default"
M.namespaces = { "default" }
M.outputFormats = {
  "wide",
  "json",
  "yaml",
}
M.outputFormat = "wide"
M.outputBufferName = "oc-out"

M.setNamespace = function(ns)
  M.namespace = ns
end

M.Update = function()
  local apiresout = vim.system({ "zsh", "-c", "oc api-resources -o name" }, { text = true }):wait()
  if apiresout.code ~= 0 then
    vim.print(apiresout.stderr)
    return
  end
  M.apiresources = splitstring(apiresout.stdout)

  local nsout = vim
    .system({ "zsh", "-c", "oc get projects -o custom-columns=:metadata.name --no-headers" }, { text = true })
    :wait()
  if nsout.code ~= 0 then
    vim.print(nsout.stderr)
    return
  end
  M.namespaces = splitstring(nsout.stdout)
end

M.getOrCreateOutputBuf = function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local isLoaded = vim.api.nvim_buf_is_loaded(buf)
    local name = vim.api.nvim_buf_get_name(buf)
    vim.print(string.format("Buffer %s is loaded? %s", name, isLoaded))
    if vim.api.nvim_buf_is_loaded(buf) then
      if string.find(name, M.outputBufferName, 1, true) then
        return buf
      end
    end
  end
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_name(buf, M.outputBufferName)
  return buf
end

M.display = function(output)
  local tmpbuf = M.getOrCreateOutputBuf()
  vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, true, splitstring(output, "\n"))

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == tmpbuf then
      vim.api.nvim_set_current_win(win)
      return
    end
  end

  vim.cmd("tabnew")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, tmpbuf)
end

M.get_internal = function(resource)
  local getout = vim
    .system({ "zsh", "-c", string.format("oc -n %s get %s -o %s", M.namespace, resource, M.outputFormat) }, { text = true })
    :wait()
  if getout.code ~= 0 then
    vim.print(getout.stderr)
    return
  end
  M.display(getout.stdout)
end

M.Get = function()
  pickers
    .new({}, {
      prompt_title = "Choose Resource",
      finder = finders.new_table({
        results = M.apiresources,
        entry_maker = stringEntryMaker,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          M.get_internal(selection.value)
        end)
        return true
      end,
    })
    :find()
end

M.describeInternal = function(namespace, resource, name)
  local describeCommand = "describe"
  if M.outputFormat ~= "wide" then
    describeCommand = "get -o " .. M.outputFormat
  end
  local descout = vim
    .system({ "zsh", "-c", string.format("oc %s -n %s %s %s", describeCommand, namespace, resource, name) }, { text = true })
    :wait()
  if descout.code ~= 0 then
    vim.print(descout.stderr)
    return
  end

  M.display(descout.stdout)
end

M.DescribeCursor = function()
  local curWord = vim.fn.expand("<cWORD>")
  M.describeInternal(M.namespace, M.lastresource, curWord)
end

M.Describe = function()
  local podsout = vim
    .system({
      "zsh",
      "-c",
      string.format("oc -n %s get %s -o custom-columns=:metadata.name --no-headers", M.namespace, M.lastresource),
    }, { text = true })
    :wait()
  if podsout.code ~= 0 then
    vim.print(podsout.stderr)
    return
  end
  pickers
    .new({}, {
      prompt_title = "Choose Thing",
      finder = finders.new_table({
        results = splitstring(podsout.stdout),
        entry_maker = stringEntryMaker,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          M.describeInternal(M.namespace, M.lastresource, selection.value)
        end)
        return true
      end,
    })
    :find()
end

M.ChooseOutputFormat = function()
  pickers
    .new({}, {
      prompt_title = "Format",
      finder = finders.new_table({
        results = M.outputFormats,
        entry_maker = stringEntryMaker,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          M.outputFormat = selection.value
        end)
        return true
      end,
    })
    :find()
end

M.ChooseNamespace = function()
  pickers
    .new({}, {
      prompt_title = "Namespace",
      finder = finders.new_table({
        results = M.namespaces,
        entry_maker = stringEntryMaker,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          M.setNamespace(selection.value)
        end)
        return true
      end,
    })
    :find()
end

return M
