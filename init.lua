vim.g.mapleader = " "
vim.g.maplocalleader = " "

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


local chan
local confpath = vim.fn.stdpath("config")
local function ensure_job()
  if chan then
    return chan
  end
  chan = vim.fn.jobstart({ 'go', 'run', '.' }, { rpc = true, cwd = confpath .. "/go"})
  return chan
end

vim.api.nvim_create_user_command('GoConf', function(args)
  vim.fn.rpcrequest(ensure_job(), 'configure', args.fargs)
end, { nargs = '*' })
vim.fn.rpcrequest(ensure_job(), 'configure')

--require("plugins")
require("mappings")
require("config")
require("look")
-- require("tools.install").installAll()


