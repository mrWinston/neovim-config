-- let g:mapleader = ' '

local utils = require('utils')

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
}


local globalOptions = {
  markdown_folding = 1,
  markdown_recommended_style = 0,
}

if vim.g.neovide then
  globalOptions["neovide_cursor_animate_command_line"] = false
  globalOptions["neovide_scale_factor"] = 1.0
end

for k, v in pairs(options) do
  vim.o[k] = v
end

for k, v in pairs(globalOptions) do
  vim.g[k] = v
end

vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { default = true, link = 'comment' })
-- set theme based on kitty theme
local kittyToNvim = {
  ["GitHub Light"] = "github_light",
  ["GitHub Dark"] = "github_dark",
  ["Catppuccin-Mocha"] = "catppuccin-mocha",
  ["Catppuccin-Latte"] = "catppuccin-latte",
}
utils.set_table_default(kittyToNvim, "material")
local obj = vim.system({'zsh', '-c', 'cat ~/.config/kitty/current-theme.conf | grep "## name" | cut -d ":" -f 2'} ,{
  text = true
}):wait()
local theme_name = string.gsub(obj.stdout, '^%s*(.-)%s*$', '%1')
vim.cmd("colorscheme ".. kittyToNvim[theme_name])
