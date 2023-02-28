-- let g:mapleader = ' '

local options = {
  cursorline = true,
  expandtab = true,
  foldcolumn = '1', -- yes, that's 1 as a string
  foldenable = true,
  foldlevel = 99,
  foldlevelstart = 99,
  ignorecase = true,
  number = true,
  relativenumber = true,
  scrolloff = 1,
  shellcmdflag = '-c',
  shiftwidth = 2,
  showcmd = true,
  smartcase = true,
  tabstop = 2,
  termguicolors = true,
  timeoutlen = 200,
  updatetime = 200,
--  foldexpr = 'nvim_treesitter#foldexpr()',
--  foldmethod = 'expr',
  markdown_folding = 1,
}

local globalOptions = {
  markdown_folding = 1,
  markdown_recommended_style = 0,
}

for k, v in pairs(options) do
  vim.o[k] = v
end

for k, v in pairs(globalOptions) do
  vim.g[k] = v
end
