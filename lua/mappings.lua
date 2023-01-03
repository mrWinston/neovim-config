vim.keymap.set({ 'n', 'v' }, ';', ':')
vim.keymap.set({ 'n', 'v' }, ':', ';')

vim.keymap.set({ 'n', 'v' }, '<leader>y', '\"+y')
vim.keymap.set('n', '<leader>Y', '\"+yg')
vim.keymap.set({ 'n', 'v' }, '<leader>p', '\"+p')
vim.keymap.set({ 'n', 'v' }, '<leader>P', '\"+P')

vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-l>', '<c-w>l')

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

vim.keymap.set('t', '<c-h>', '<C-\\><C-N><C-w>h')
vim.keymap.set('t', '<c-j>', '<C-\\><C-N><C-w>j')
vim.keymap.set('t', '<c-k>', '<C-\\><C-N><C-w>k')
vim.keymap.set('t', '<c-l>', '<C-\\><C-N><C-w>l')


local function wrap(func, ...)
  local args = { ... }
  return function()
    func(unpack(args))
  end
end

local telescope = require('telescope.builtin')
local telescope_dap = require('telescope._extensions.dap')

local wk = require("which-key")
wk.register({
  f = {
    name = "find",
    f = { telescope.find_files, "Files" },
    g = { telescope.live_grep, "File content (grep)" },
    b = { telescope.buffers, "Buffers" },
    h = { telescope.help_tags, "Help" },
    c = { telescope.commands, "Commands" },
    t = { wrap(telescope.builtin, { include_extensions = true }), "Telescope Pickers" },
    d = { telescope_dap.commands, "DAP Commands" },
    s = { telescope.treesitter, "Symbols" },
  },
  g = {
    name = "git",
    b = { telescope.git_branches, "Branches" },
    c = { telescope.git_commits, "Commits" },
    s = { ":Git<cr>", "Status" },
    p = { ":Git pull<cr>", "Pull" },
    l = { ":LazyGit<cr>", "Lazygit" },
  }
},
  {
    prefix = "<leader>",
  })

--local telescope_mappings = {
--  f = telescope.find_files,
--  g = telescope.live_grep,
--  b = telescope.buffers,
--  h = telescope.help_tags,
--  c = telescope.commands,
--  t = wrap(telescope.builtin, { include_extensions = true }),
--  d = telescope_dap.commands,
--  s = telescope.treesitter,
--}
--
--for k, v in pairs(telescope_mappings) do
--  local key = '<leader>f' .. k
--  vim.keymap.set('n', key, v)
--end

local function reloadConfig()
  for name, _ in pairs(package.loaded) do
    if not name:match('nvim-tree') then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
  vim.notify(string.format("Nvim configuration %s reloaded!", vim.env.MYVIMRC), vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('Reload', reloadConfig, { nargs = 0 })
vim.api.nvim_create_user_command('Open', '!xdg-open %', { nargs = 0 })
