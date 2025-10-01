local M = {}

M.task_exec = "task"

-- description = "Sub for oncall on aug 16",
-- due = "20250731T220000Z",
-- entry = "20250422T112559Z",
-- id = 1,
-- modified = "20250423T082832Z",
-- project = "admin",
-- status = "pending",
-- urgency = 3.4,
-- uuid = "60676cea-2054-4050-a85c-06adace19755"

---@alias date string
---@alias uuid string

---@enum TaskStatus
M.TASK_STATES = {
  PENDING = "pending",
  DELETED = "deleted",
  COMPLETED = "completed",
  WAITING = "waiting",
  RECURRING = "recurring",
}

---@class TodoAnnotation
---@field description string
---@field entry string

---@class Todo
---@field annotations? TodoAnnotation[]
---@field description string
---@field id number
---@field project string
---@field due date
---@field entry date
---@field modified date
---@field start? date
---@field end? date
---@field until? date
---@field wait? date
---@field scheduled? date
---@field recur? string
---@field mask? string
---@field imask? number
---@field parent? uuid
---@field priority? string
---@field depends? string
---@field tags? string[]
---@field status TaskStatus
---@field urgency number
---@field uuid uuid

---@class TodoAction
---@field description string
---@field action function(item: Todo)

---@type TodoAction[]
M.todo_actions = {
  {
    description = "Show Details",
    action = function(item)
      vim.print("Showing details: " .. item.description)
    end,
  },
  {
    description = "Update Description",
    action = function(item)
      vim.ui.input({
        prompt = "Update Description",
        default = item.description,
      }, function(input)
        if not input then
          return
        end
        if input == item.description then
          return
        end
        item.description = input
        M.update_todo(item)
      end)
    end,
  },
  {
    description = "Mark Done",
    action = function(item)
      local sysout = vim
        .system({ M.task_exec, "done", item.uuid }, {
          text = true,
        })
        :wait()

      if sysout.code ~= 0 then
        vim.notify("Error marking todo as done: " .. sysout.stderr .. sysout.stdout, vim.log.levels.ERROR)
        return
      end
      vim.notify("Successfully marked todo as done", vim.log.levels.INFO)
    end,
  },
  {
    description = "Delete",
    action = function(item)
      local sysout = vim
        .system({ M.task_exec, "rc.confirmation=off", "delete", item.uuid }, {
          text = true,
        })
        :wait()

      if sysout.code ~= 0 then
        vim.notify("Error Deleting todo: " .. sysout.stderr .. sysout.stdout, vim.log.levels.ERROR)
        return
      end
      vim.notify("Successfully Deleted todo", vim.log.levels.INFO)
    end,
  },
}

M.update_todo = function(todo)
  local commandline = { M.task_exec, "import" }
  local todoJson = vim.json.encode(todo, {})
  local sysout = vim
    .system(commandline, {
      text = true,
      stdin = todoJson,
    })
    :wait()
  if sysout.code ~= 0 then
    vim.notify("Error updating todo: " .. sysout.stderr, vim.log.levels.ERROR)
  end
  vim.notify("Successfully updated todo")
end

---@param item Todo
M.format_todo_for_picker = function(item)
  return ("%d - %s"):format(item.id, item.description)
end

---comment
---@param item? Todo
---@param idx? integer
M.on_todo_selected = function(item, idx)
  if not item then
    return
  end
  vim.ui.select(M.todo_actions, {
    format_item = function(actionItem)
      return actionItem.description
    end,
  }, function(actionItem, _)
    if not actionItem then
      return
    end
    actionItem.action(item)
  end)
  vim.print(item)
end

---comment
---@param sys_completed vim.SystemCompleted
M.receive_tasks = function(sys_completed)
  if sys_completed.code ~= 0 then
    vim.notify(("Error listing tasks: %s"):format(sys_completed.stderr), vim.log.levels.WARN)
    return
  end

  ---@type Todo[]
  local tasks = vim.json.decode(sys_completed.stdout, { luanil = { object = true, array = true } })

  -- for i, task in ipairs(tasks) do
  --   vim.print(task)
  -- end

  vim.ui.select(tasks, { format_item = M.format_todo_for_picker }, M.on_todo_selected)
end

M.list_tasks = function()
  local commandline = { M.task_exec, "-COMPLETED", "-DELETED", "export" }
  local sysout = vim
    .system(commandline, {
      text = true,
    })
    :wait()

  M.receive_tasks(sysout)
end

M.new_todo = function()
  -- async create flow
  local newTodo = {}
  M.new_todo_description(newTodo)
end

M.new_todo_description = function(todo)
  vim.ui.input({ prompt = "Enter Todo Description" }, function(input)
    todo.description = input
    M.new_todo_project(todo)
  end)
end

M.new_todo_project = function(todo)
  vim.ui.input({ prompt = "Enter Project" }, function(input)
    todo.project = input
    M.new_todo_finalize(todo)
  end)
end

M.new_todo_finalize = function(todo)
  local commandline = { M.task_exec, "add" }
  if todo.project and todo.project ~= "" then
    table.insert(commandline, ("project:%s"):format(todo.project))
  end
  if not todo.description or todo.description == "" then
    vim.notify("Todo description can't be empty", vim.log.levels.ERROR)
    return
  end
  table.insert(commandline, todo.description)
  local sysout = vim
    .system(commandline, {
      text = true,
    })
    :wait()

  if sysout.code ~= 0 then
    vim.notify("Error creating todo: " .. sysout.stderr, vim.log.levels.ERROR)
    return
  end
  vim.notify("Successfully created todo", vim.log.levels.INFO)
end

M.task_cmd = function()
  local sysout = vim.system({ M.task_exec, "list" }, { text = true }):wait()
  if sysout.code ~= 0 then
    vim.notify("Error running cmd: " .. sysout.stderr .. sysout.stdout, vim.log.levels.ERROR)
    return
  end
  local outbuf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(outbuf, 0, -1, true, vim.split(sysout.stdout, "\n"))

  local globalHeight = vim.api.nvim_list_uis()[1].height
  local globalWidth = vim.api.nvim_list_uis()[1].width
  local winHeight = math.min(math.floor(globalHeight * 0.8), vim.api.nvim_buf_line_count(outbuf))
  local winWidth = math.floor(globalWidth * 0.5)
  local row = math.floor((globalHeight - winHeight) * 0.5)
  local col = math.floor((globalWidth - winWidth) * 0.5)

  vim.api.nvim_open_win(outbuf, true, {
    relative = "editor",
    row = row,
    col = col,
    width = winWidth,
    height = winHeight,
    style = "minimal",
    border = "single",
    title = "task out",
    title_pos = "center",
  })
end



return M
