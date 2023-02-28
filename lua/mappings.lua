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

vim.keymap.set({ 'n', 'i' }, '<c-t>', ':tabnew<cr>')

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith, {})

local telescope = require('telescope.builtin')
local telescope_dap = require('telescope._extensions.dap')
local utils = require('utils')
local outline = require('symbols-outline')

local wk = require("which-key")

wk.register({
  f = {
    name = "find",
    f = { telescope.find_files, "Files" },
    g = { telescope.live_grep, "File content (grep)" },
    b = { telescope.buffers, "Buffers" },
    h = { telescope.help_tags, "Help" },
    c = { telescope.commands, "Commands" },
    t = { utils.wrapFunction(telescope.builtin, { include_extensions = true }), "Telescope Pickers" },
    d = { telescope_dap.commands, "DAP Commands" },
    s = { telescope.treesitter, "Symbols" },
    j = { telescope.jumplist, "Jumplist" },
    m = { ":Telescope make<cr>", "Run Make Targets" },
  },
  g = {
    name = "git",
    b = { telescope.git_branches, "Branches" },
    c = { telescope.git_commits, "Commits" },
    s = { ":Git<cr>", "Status" },
    p = { ":Git pull<cr>", "Pull" },
    l = { ":LazyGit<cr>", "Lazygit" },
    n = { utils.createGitBranch, "New Branch" },
    g = {
      name = "gists",
      l = { ":GistList<cr>", "List Gists" },
      c = { ":GistCreate<cr>", "Create Gists" },
    },
  },
  u = {
    name = "utils",
    c = { utils.toggleCheckbox, "Toggle Checkbox" },
    t = { ":ToggleTerm<cr>", "Toggle Terminal Window" },
    s = { ":nohlsearch<cr>", "Hide Search Results" },
    n = { ":s/\n//g<cr>", "Remove Linebreaks" },
    o = { outline.toggle_outline, "Show Outline" },
    l = {
      name = "lsp server diagnostics",
      r = { ":LspRestart<cr>", "Restart Lsp Server" },
      i = { ":LspInfo<cr>", "Lsp Server Info" },
      l = { ":LspLog<cr>", "Lsp Server Logs" },
    }
  },
  o = {
    name = "obsidian",
    o = { ":ObsidianOpen<cr>", "Open Obsidian" },
    n = { ":ObsidianLinkNew<cr>", "Create New note and add link to it" },
    l = { ":ObsidianLink<cr>", "Insert a link to an existing note" },
    g = { ":ObsidianSearch<cr>", "Grep through all notes" },
    s = { ":ObsidianQuickSwitch<cr>", "Search notes by name" },
    t = { ":ObsidianToday<cr>", "Create (or open) the Today Note" },
    y = { ":ObsidianYesterday<cr>", "Open (or create) yesterdays note" },
    f = { ":ObsidianFollowLink<cr>", "Follow link under cursor" },
  },
},
  {
    prefix = "<leader>",
  })

vim.api.nvim_create_user_command('Reload', utils.reloadConfig, { nargs = 0 })
vim.api.nvim_create_user_command('Open', '!xdg-open %', { nargs = 0 })
