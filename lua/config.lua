-- let g:mapleader = ' '

local options = {
  updatetime = 200,
  showcmd = true,
  number = true,
  relativenumber = true,
  cursorline = true,
  scrolloff = 1,
  tabstop = 2,
  shiftwidth = 2,
  expandtab = true,
  foldmethod = 'expr',
  foldexpr = 'nvim_treesitter#foldexpr()',
  foldlevel = 20,
  ignorecase = true,
  smartcase = true,
  termguicolors = true,
  shellcmdflag = '-c',
  timeoutlen = 200,
}

for k, v in pairs(options) do
  vim.o[k] = v
end
