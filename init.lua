vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- if not vim.loop.fs_stat(lazypath) then
--   vim.fn.system({
--     "git",
--     "clone",
--     "--filter=blob:none",
--     "https://github.com/folke/lazy.nvim.git",
--     "--branch=stable", -- latest stable release
--     lazypath,
--   })
-- end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins", {
  defaults = {
    lazy = false,
  },
  change_detection = {
    notify = false,
  },
  dev = {
    path = "~/code/mrWinston",
  },
})

--require("plugins")
require("mappings")
require("config")
require("look")
if vim.g.neovide then
  vim.o.guifont = "BlexMono Nerd Font:h12"
  vim.g.neovide_transparency = 0.9
  vim.g.neovide_window_blurred = true
  vim.g.neovide_fullscreen = false
  vim.g.neovide_remember_window_size = false
  vim.g.neovide_cursor_trail_size = 0.4
   -- vim.g.neovide_cursor_animation_length = 0.06
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_cursor_animation_length = 0
  -- vim.g.neovide_scroll_animation_length = 0
end
-- require("tools.install").installAll()
