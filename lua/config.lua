-- let g:mapleader = ' '

local utils = require("utils")

local options = {
  cursorline = true,
  expandtab = true,
  ignorecase = true,
  number = true,
  relativenumber = true,
  scrolloff = 1,
  shellcmdflag = "-c",
  shiftwidth = 2,
  showcmd = true,
  smartcase = true,
  tabstop = 2,
  conceallevel = 0,
  termguicolors = true,
  timeoutlen = 200,
  updatetime = 200,
  -- folding
  foldcolumn = "1", -- yes, that's 1 as a string
  foldenable = true,
  foldlevel = 99,
  foldlevelstart = 99,
--  foldexpr = 'nvim_treesitter#foldexpr()',
--  foldmethod = 'expr',
}

local globalOptions = {
  markdown_folding = 1,
  markdown_recommended_style = 0,
  disable_autoformat = true,
  bullets_enabled_file_types = {
    "markdown",
    "text",
    "org",
    "gitcommit",
    "scratch",
  },
  bullets_outline_levels = { "ROM", "ABC", "num", "abc", "rom", "std-" },
  -- lazygit conf
  lazygit_floating_window_winblend = 1,
  lazygit_floating_window_use_plenary = 1,
  netrw_browsex_viewer = "cd %:h && xdg-open",
--  markdown_fenced_languages = {"bash", "lua", "go", "typescript", "python"}
}

if vim.g.neovide then
  globalOptions["neovide_cursor_animate_command_line"] = false
  globalOptions["neovide_scale_factor"] = 1.0
  vim.o.guifont = '0xProto Nerd Font:h10'
end

for k, v in pairs(options) do
  vim.o[k] = v
end

for k, v in pairs(globalOptions) do
  vim.g[k] = v
end

