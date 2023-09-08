require('terminal').setup()

-- BufEnter
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

augroup('AnsiHighlight', { clear = true })
autocmd('FileType', {
  group = 'AnsiHighlight',
  pattern = 'dap-repl',
--  command = 'set ft=terminal',
  callback = function(args)
    vim.print(args)
    vim.bo[args.buf].filetype = "terminal"
  end,
})

