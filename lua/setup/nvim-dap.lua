local function get_maingo()
  return vim.fn.findfile("main.go", ".;")
end

local function get_args()
  local args = {}
  vim.ui.input({ prompt = "Args: " }, function(input)
    args = vim.split(input or "", " ")
  end)
  return args
end

require("dap-go").setup({
  dap_configurations = {
    {
      type = "go",
      name = "Debug main.go",
      request = "launch",
      program = get_maingo,
      args = get_args,
    },
    {
      type = "go",
      name = "Verbose Test",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}",
      args = {"-test.v"},
    },
  },
})

require("nvim-dap-virtual-text").setup({
  enabled = true, -- enable this plugin (the default)
  enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
  highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
  highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
  show_stop_reason = true, -- show stop reason when stopped for exceptions
  commented = false, -- prefix virtual text with comment string
  only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
  all_references = false, -- show virtual text on all all references of the variable (not only definitions)
  filter_references_pattern = "<module", -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
  -- experimental features:
  virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
  all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
  virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
  virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
  -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
})

require("dapui").setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has("nvim-0.7"),
  -- Layouts define sections of the screen to place windows.
  -- The position can be "left", "right", "top" or "bottom".
  -- The size specifies the height/width depending on position. It can be an Int
  -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
  -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
  -- Elements are the elements shown in the layout (in order).
  -- Layouts are opened in order so that earlier layouts take priority in window sizing.
  layouts = {
    {
      elements = {
        -- Elements can be strings or table with id and size keys.
        -- { id = "scopes", size = 0.25 },
        "scopes",
        "breakpoints",
        --        "stacks",
        "watches",
      },
      size = 0.25, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
        --        "console",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
  },
})

local dapui = require("dapui")

local dap = require("dap")

dap.defaults.fallback.focus_terminal = true

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
--   dapui.close()
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
--   dapui.close()
-- end

local wk = require("which-key")

local function addDebugConfig()
  vim.ui.input({ prompt = "Enter config Name: " }, function(name)
    if name == nil then
      return
    end

    vim.ui.input({ prompt = "Args: " }, function(input)
      local args
      if input then
        args = vim.split(input or "", " ")
      end
      table.insert(dap.configurations.go, {
        type = "go",
        name = name,
        request = "launch",
        program = vim.fn.findfile("main.go", ".;"),
        args = args,
        custom = true,
      })
    end)
  end)
end

local function filter(list, compareFunc)
  local newList = {}
  for _, value in pairs(list) do
    if compareFunc(value) then
      table.insert(newList, value)
    end
  end
  return newList
end

local function modifyDebugConfig()
  local previewers = require("telescope.previewers")

  vim.ui.select(
    filter(dap.configurations.go, function(value)
      vim.print(value)
      return value.custom or false
    end),
    {
      prompt = "Config to Modify:",
      format_item = function(item)
        return item.name
      end,
      telescope = {
        previewer = previewers.new_buffer_previewer({
          title = "My preview",
          define_preview = function(self, entry, _)
            vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(vim.inspect(entry.value), "\n"))
          end,
        }),
      },
    },
    function(_, idx)
      if idx == nil then
        return
      end

      vim.ui.input({ prompt = "Enter config Name: ", default = dap.configurations.go[idx].name }, function(name)
        if name == nil then
          return
        end

        local args
        vim.print(dap.configurations.go[idx])

        vim.ui.input({ prompt = "Args: ", default = table.concat(dap.configurations.go[idx], " ") }, function(input)
          if input then
            args = vim.split(input or "", " ")

            dap.configurations.go[idx].name = name
            dap.configurations.go[idx].args = args
          end
        end)
      end)
    end
  )
end

local function getCustomConfigurations(configs)
  local configsToReturn = {}
  for _, value in ipairs(configs) do
    if value.custom then
      table.insert(configsToReturn, value)
    end
  end
  return configsToReturn
end

local function findFirstIndex(list, compareFunc)
  for index, value in ipairs(list) do
    if compareFunc(value) then
      return index
    end
  end
  return -1
end

local function findOrDefault(list, compareFunc, default)
  local idx = findFirstIndex(list, compareFunc)
  return (idx == -1 and default or list[idx])
end

local function parseDapConfigFile(path)
  local file = io.open(path, "rb") -- r read mode and b binary mode
  if not file then
    return {}
  end
  local content = file:read("*a") -- *a or *all reads the whole file
  file:close()

  return vim.fn.json_decode(content) or {}
end

local function loadDapConfig()
  local confFolder = vim.fn.stdpath("config")
  local dapConfigFilePath = confFolder .. "/dapconfigs.json"

  local cwd = vim.fn.getcwd()

  local dapConfigs = parseDapConfigFile(dapConfigFilePath)
  vim.print("COnfig loaded:")
  vim.print(dapConfigs)

  local savedConf = findOrDefault(dapConfigs, function(value)
    vim.print("cwd is " .. cwd)
    vim.print("comparing to")
    vim.print(value)
    return value.path == cwd
  end, {})
  vim.print("saved conf is:")
  vim.print(savedConf)

  for _, dapConf in pairs(savedConf.configurations or {}) do
    local idxInConf = findFirstIndex(dap.configurations.go, function(value)
      return dapConf.name == value.name
    end)
    if idxInConf == -1 then
      table.insert(dap.configurations.go, dapConf)
    else
      dap.configurations.go[idxInConf] = dapConf
    end
  end
end

local function saveDapConfigs()
  local confFolder = vim.fn.stdpath("config")
  local outFile = confFolder .. "/dapconfigs.json"

  local cwd = vim.fn.getcwd()

  local outstuff = {
    path = cwd,
    configurations = getCustomConfigurations(dap.configurations.go),
  }
  local curConf = parseDapConfigFile(outFile)
  local confIdx = -1
  for index in ipairs(curConf) do
    if curConf[index].path == cwd then
      confIdx = index
    end
  end

  if confIdx == -1 then
    table.insert(curConf, outstuff)
  else
    curConf[confIdx] = outstuff
  end

  local json_out = vim.fn.json_encode(curConf)
  vim.print(json_out)
  local ok, result = pcall(vim.fn.writefile, { json_out }, outFile)
  if ok then
    print("Okay")
  else
    print(result)
  end
end

wk.add({
  {
    mode = { "n", "v" },
    { "<leader>d", group = "debugger" },
    { "<leader>db", dap.toggle_breakpoint, desc = "Toggle Breakpoint" },
    { "<leader>dc", group = "Config Management" },
    { "<leader>dca", addDebugConfig, desc = "Add Debug Configuration" },
    { "<leader>dcj", require("dap.ext.vscode").load_launchjs, desc = "load launch.json" },
    { "<leader>dcl", loadDapConfig, desc = "Load Debug Config" },
    { "<leader>dcm", modifyDebugConfig, desc = "Modify Debug Config" },
    { "<leader>dcp", function()vim.print(dap.configurations.go)end, desc = "Print Debug Config" },
    { "<leader>dcs", saveDapConfigs, desc = "Save Debug Config" },
    { "<leader>dd", dap.continue, desc = "Start Debugging" },
    { "<leader>dk", dap.terminate, desc = "Kill Session" },
    { "<leader>dl", ":DapShowLog<cr>", desc = "Show Log" },
    { "<leader>dpb", dap.toggle_breakpoint, desc = "Toggle Breakpoint" },
    { "<leader>dr", dap.run_last , desc = "Re-run last session" },
    { "<leader>ds", group = "Step" },
    { "<leader>dsi", ":DapStepInto<cr>", desc = "Step Into" },
    { "<leader>dsn", ":DapStepOver<cr>", desc = "Step Next/Over" },
    { "<leader>dso", ":DapStepOut<cr>", desc = "Step Out" },
    { "<leader>du", dapui.toggle, desc = "Toggle dap ui" },
  }
})
