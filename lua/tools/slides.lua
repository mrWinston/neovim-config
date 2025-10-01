local M = {}

M.run = function()
  local slides = {}
  local all_lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  vim.print(("Num Lines: %d"):format(#all_lines))

  local laststart = 1
  local curlines = {}
  for idx, line in ipairs(all_lines) do
    if line == "---" then
      table.insert(slides, curlines)
      curlines = {}
      vim.print(("Num Slides: %d"):format(#slides))
    else
      table.insert(curlines, line)
    end
  end

  if #curlines > 0 then
    table.insert(slides, curlines)
  end

  local outbuf = vim.api.nvim_create_buf(false, true)
  local curslideidx = 1
  vim.api.nvim_buf_set_lines(outbuf, 0, -1, true, slides[curslideidx])

  local globalHeight = vim.api.nvim_list_uis()[1].height
  local globalWidth = vim.api.nvim_list_uis()[1].width
  local winHeight = math.min(math.floor(globalHeight * 0.8), vim.api.nvim_buf_line_count(outbuf))
  local winWidth = math.floor(globalWidth * 0.5)
  local row = math.floor((globalHeight - winHeight) * 0.5)
  local col = math.floor((globalWidth - winWidth) * 0.5)

  vim.cmd.tabnew()
  vim.api.nvim_set_current_buf(outbuf)

  -- vim.api.nvim_open_win(outbuf, true, {
  --   relative = "editor",
  --   row = row,
  --   col = col,
  --   width = winWidth,
  --   height = winHeight,
  --   style = "minimal",
  --   border = "single",
  --   title = "task out",
  --   title_pos = "center",
  -- })

  vim.keymap.set("n", "h", function()
    curslideidx = math.max(1, curslideidx - 1)
    vim.api.nvim_buf_set_lines(outbuf, 0, -1, true, slides[curslideidx])
  end, { buffer = outbuf })
  vim.keymap.set("n", "l", function()
    curslideidx = math.min(#slides, curslideidx + 1)
    vim.api.nvim_buf_set_lines(outbuf, 0, -1, true, slides[curslideidx])
  end, { buffer = outbuf })
end

return M
