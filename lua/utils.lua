local utils = {}
local io = require("io")

function utils.startCustomLsp()
  vim.lsp.start({
    cmd = { "mdlsp" },
    root_dir = vim.fn.getcwd(), -- Use PWD as project root dir.
  })
end

---Get the ids of all windows that are not floating or external
---@return integer[]
function utils.get_non_floating_windows()
  local winout = {}
  for i, winid in pairs(vim.api.nvim_list_wins()) do
    local winconf = vim.api.nvim_win_get_config(winid)
    if winconf.relative == "" and not winconf.external then
      table.insert(winout, winid)
    end
  end
  return winout
end

function utils.colorize()
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.statuscolumn = ""
  vim.wo.signcolumn = "no"
  vim.opt.listchars = { space = " " }

  local buf = vim.api.nvim_get_current_buf()

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  while #lines > 0 and vim.trim(lines[#lines]) == "" do
    lines[#lines] = nil
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})

  vim.b[buf].minianimate_disable = true

  vim.api.nvim_chan_send(vim.api.nvim_open_term(buf, {}), table.concat(lines, "\r\n"))
  vim.keymap.set("n", "q", "<cmd>qa!<cr>", { silent = true, buffer = buf })
  vim.api.nvim_create_autocmd("TextChanged", { buffer = buf, command = "normal! G$" })
  vim.api.nvim_create_autocmd("TermEnter", { buffer = buf, command = "stopinsert" })

  vim.defer_fn(function()
    vim.b[buf].minianimate_disable = false
  end, 2000)
end

utils.lspstuff = function()
  local params = vim.lsp.util.make_position_params()
  params.context = {
    includeDeclaration = false,
  }
  vim.lsp.buf_request(
    0,
    vim.lsp.protocol.Methods.textDocument_references,
    params,
    function(err, result, context, config)
      vim.print("err:")
      vim.print(err)
      vim.print("Result:")
      vim.print(result)
    end
  )
end

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

utils.selected_lines = function()
  local vstart = vim.fn.getpos("v")

  local vend = vim.fn.getpos(".")

  local line_start = vstart[2]
  local line_end = vend[2]

  -- or use api.nvim_buf_get_lines
  local lines = vim.fn.getline(line_start, line_end)
  if type(lines) == "table" then
    return table.concat(lines, "\n")
  elseif type(lines) == "string" then
    return lines
  else
    return
  end
end

utils.screenshot = function()
  local selected_text = utils.selected_lines()
  if not selected_text then
    vim.print("Nothing selected")
    return
  end

  -- local completed = vim.system({ "/usr/bin/zsh", "-ic", "silicon --language " .. vim.bo.filetype .. " -o /tmp/bla.png" }, {
  --   text = true,
  --   stdin = selected_text,
  -- }):wait()
  local completed = vim
    .system({
      "silicon",
      "--language",
      vim.bo.filetype,
      "--pad-horiz",
      "20",
      "--pad-vert",
      "20",
      "--no-window-controls",
      "--background",
      "#00000000",
      "--shadow-blur-radius",
      "10",
      "--shadow-color",
      "#000000",
      "-o",
      "/tmp/screen.png",
    }, {
      text = true,
      stdin = selected_text,
    })
    :wait()

  if completed.code ~= 0 then
    vim.print("Error: " .. completed.stderr)
  else
    vim.notify("snapshot copied")
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

utils.JQ = function()
  -- save in buffer id
  local inputBuffer = vim.api.nvim_get_current_buf()
  -- new tab
  vim.cmd.tabnew()
  local tabpage = vim.api.nvim_get_current_tabpage()
  local inputWin = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(inputWin, inputBuffer)
  -- create 4 windows
  local commandBuffer = vim.api.nvim_create_buf(false, true)
  vim.bo[commandBuffer].filetype = "jq"
  vim.api.nvim_buf_set_name(commandBuffer, "JQ Command")

  local outBuffer = vim.api.nvim_create_buf(false, true)
  vim.bo[outBuffer].filetype = vim.bo[inputBuffer].filetype
  vim.api.nvim_buf_set_name(outBuffer, "JQ Output")
  local errBuffer = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(errBuffer, "JQ Error")

  local outWin = vim.api.nvim_open_win(outBuffer, false, { split = "right", win = inputWin })
  local commandWin = vim.api.nvim_open_win(commandBuffer, false, { split = "below", win = inputWin, height = 10 })
  local errWin = vim.api.nvim_open_win(errBuffer, false, { split = "below", win = outWin, height = 10 })

  vim.keymap.set({ "n", "i" }, "<C-Enter>", function()
    local jqin = table.concat(vim.api.nvim_buf_get_lines(inputBuffer, 0, -1, false), "\n")
    local jqcmd = table.concat(vim.api.nvim_buf_get_lines(commandBuffer, 0, -1, false), "\n")

    local syscmd = vim
      .system({ "jq", jqcmd }, {
        stdin = jqin,
        text = true,
      })
      :wait()
    if syscmd.code == 0 then
      vim.api.nvim_buf_set_lines(outBuffer, 0, -1, false, vim.split(syscmd.stdout, "\n"))
    end
    vim.api.nvim_buf_set_lines(errBuffer, 0, -1, false, vim.split(syscmd.stderr, "\n"))
  end, { buffer = commandBuffer })
  vim.api.nvim_create_autocmd({ "WinClosed" }, {
    pattern = { tostring(commandWin), tostring(outWin), tostring(errWin), tostring(inputWin) },
    callback = function(event)
      vim.api.nvim_win_close(outWin, false)
      vim.api.nvim_buf_delete(outBuffer, {})
      vim.api.nvim_win_close(commandWin, false)
      vim.api.nvim_buf_delete(commandBuffer, {})
      vim.api.nvim_win_close(errWin, false)
      vim.api.nvim_buf_delete(errBuffer, {})
      vim.api.nvim_win_close(inputWin, false)
    end,
  })
end

utils.jqrunner = function()
  local jqcmdbuf = 0
  local jqoutbuf = 0
  local jqinbuf = 0
  for id, bufid in pairs(vim.api.nvim_list_bufs()) do
    local bufname = vim.api.nvim_buf_get_name(bufid)
    if string.find(bufname, "jqcom") then
      jqcmdbuf = bufid
    elseif string.find(bufname, "jqout") then
      jqoutbuf = bufid
    elseif string.find(bufname, "jqinput") then
      jqinbuf = bufid
    end
  end

  local jqin = table.concat(vim.api.nvim_buf_get_lines(jqinbuf, 0, -1, false), "\n")
  local jqcmd = table.concat(vim.api.nvim_buf_get_lines(jqcmdbuf, 0, -1, false), "\n")

  local syscmd = vim
    .system({ "jq", jqcmd }, {
      stdin = jqin,
      text = true,
    })
    :wait()

  vim.api.nvim_buf_set_lines(jqoutbuf, 0, -1, false, vim.split(syscmd.stdout, "\n"))
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

bla = "%x1b%[[0-9;]*m"

utils.replace_termcodes = function()
  local all_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local foundCodes = {}
  local curcode = ""
  local code_start_line = -1
  local code_start_row = -1
  local code_end_line = -1
  local code_end_row = -1
  for linenum, line in ipairs(all_lines) do
    vim.print("check line: " .. linenum)
    local curstart = 0
    while true do
      s, e = string.find(line, "\27%[[0-9;]*m", curstart)
      if not s or not e then
        break
      end
      code_end_line = linenum
      code_end_row = s
      if code_start_row ~= -1 then
        table.insert(foundCodes, {
          code = curcode,
          startrow = code_start_row,
          startline = code_start_line,
          endrow = code_end_row,
          endline = code_end_line,
        })
      end
      curcode = string.match(line, "\27%[([0-9;]*)m", curstart)
      code_start_line = linenum
      code_start_row = s
      curstart = e + 1
    end
  end

  vim.print(foundCodes)
  local nsid = vim.api.nvim_create_namespace("termcode")
  for index, code in ipairs(foundCodes) do
    local hlgroup = "DiffText"
    if code.code == "34" then
      vim.hl.range(0, nsid, hlgroup, { code.startline, code.startrow }, { code.endline, code.endrow }, {})
    end
  end
end

return utils
