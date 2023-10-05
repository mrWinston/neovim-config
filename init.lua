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
-- require("tools.install").installAll()
