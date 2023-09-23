vim.keymap.set({ "n", "v" }, ";", ":")
vim.keymap.set({ "n", "v" }, ":", ";")

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+yg')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P')

vim.keymap.set("n", "<c-j>", "<c-w>j")
vim.keymap.set("n", "<c-k>", "<c-w>k")
vim.keymap.set("n", "<c-h>", "<c-w>h")
vim.keymap.set("n", "<c-l>", "<c-w>l")

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

vim.keymap.set("t", "<c-h>", "<C-\\><C-N><C-w>h")
vim.keymap.set("t", "<c-j>", "<C-\\><C-N><C-w>j")
vim.keymap.set("t", "<c-k>", "<C-\\><C-N><C-w>k")
vim.keymap.set("t", "<c-l>", "<C-\\><C-N><C-w>l")

vim.keymap.set({ "n", "i" }, "<c-t>", ":tabnew<cr>")

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
vim.keymap.set("n", "zm", require("ufo").closeFoldsWith, {})

local telescope = require("telescope.builtin")
local telescope_dap = require("telescope._extensions.dap")
local utils = require("utils")
local outline = require("symbols-outline")

local wk = require("which-key")


local change_neovide_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

local askCommandRun = function()
  vim.ui.input({ prompt = "Command to run: " }, function(input)
    local Terminal = require("toggleterm.terminal").Terminal
    local run_term = Terminal:new({
      cmd = input,
      direction = "horizontal",
      close_on_exit = false,
    })
    run_term:toggle()
  end)
end

local createRunFunc = function(command)
  return function()
    local Terminal = require("toggleterm.terminal").Terminal
    local run_term = Terminal:new({
      cmd = command,
      direction = "horizontal",
      close_on_exit = false,
    })
    run_term:toggle()
  end
end

wk.register({
  r = {
    name = "run",
    r = { askCommandRun, "Run command" },
    t = {
      name = "terraform",
      p = { createRunFunc("terraform plan"), "plan" },
    },
  },
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
    p = { require("telescope").extensions.gopass.gopass, "Gopass" },
  },
  g = {
    name = "git",
    b = {
      name = "Branches",
      c = { telescope.git_branches, "Checkout" },
      n = { utils.createGitBranch, "New Branch" },
      d = { utils.gitDiffBranch, "Diff" },
    },
    c = { ":Git commit<cr>", "Commit" },
    s = { ":Git<cr>", "Status" },
    p = { ":Git pull<cr>", "Pull" },
    P = { ":Git push<cr>", "Push" },
    l = { ":LazyGit<cr>", "Lazygit" },
    g = {
      name = "gists",
      l = { ":GistList<cr>", "List Gists" },
      c = { ":GistCreate<cr>", "Create Gists" },
    },
  },
  t = { ":Neotree toggle<cr>", "Open Neotree" },
  l = { require("lazy").home, "Lazy" },
  u = {
    name = "utils",
    c = { utils.toggleCheckbox, "Toggle Checkbox" },
    m = { require("mini.files").open, "Mini Files" },
    f = { utils.wrapFunction(require("conform").format, { lsp_fallback = true }), "format file" },
    d = { utils.toggle_autoformat, "toggle autoformat after save" },
    t = {
      name = "ToggleTerm",
      t = { ":ToggleTerm<cr>", "Toggle Terminal Window" },
      v = { ":ToggleTermSendVisualSelection<cr>", "Run Selection" },
      l = { ":ToggleTermSendCurrentLine<cr>", "Run Line" },
    },
    n = { ":nohlsearch<cr>", "Hide Search Results" },
    s = {
      name = "Spellcheck",
      e = { ":setlocal spell spelllang=en_us<cr>", "Enable English Spellcheck" },
      g = { ":setlocal spell spelllang=de_20<cr>", "Enable German Spellcheck" },
    },
    --    s = {
    --      name = "neovide scaling",
    --      i = { utils.wrapFunction(change_neovide_scale_factor, 1.25), "Increase" },
    --      d = { utils.wrapFunction(change_neovide_scale_factor, 1 / 1.25), "Decrease" },
    --    },
    o = { outline.toggle_outline, "Show Outline" },
    l = {
      name = "lsp server diagnostics",
      r = { ":LspRestart<cr>", "Restart Lsp Server" },
      i = { ":LspInfo<cr>", "Lsp Server Info" },
      l = { ":LspLog<cr>", "Lsp Server Logs" },
    },
    r = {
      name = "replace hotkeys",
      n = { ":s/\n//g<cr>", "Remove Linebreaks" },
    },
  },
  k = {
    name = "Knowledge mappings",
    o = { require("granite").open_note, "Open note"},
    t = { ":Telescope granite<cr>", "Show Todos"},
    n = { require("granite").Note, "New Note"},
    l = { require("granite").link_to_file, "insert link"},
  },
  e = {
    name = "errors",
    l = { vim.diagnostic.setloclist, "Show Errors" },
    n = { vim.diagnostic.goto_next, "Go to Next" },
    p = { vim.diagnostic.goto_prev, "Go to Previous" },
    o = { vim.diagnostic.open_float, "Open Float Window" },
  },
  c = {
    name = "code",
    a = { vim.lsp.buf.code_action, "code actions" },
    r = { vim.lsp.buf.rename, "rename function or variable" },
    d = { vim.lsp.buf.document_symbol, "Show Symbols in Document" },
    f = { utils.wrapFunction(require("conform").format, { lsp_fallback = true }), "format file" },
    h = { vim.lsp.buf.signature_help, "Signature Help" },
    g = {
      name = "goto",
      d = { vim.lsp.buf.definition, "Definition" },
      t = { vim.lsp.buf.type_definition, "Type definition" },
      r = { vim.lsp.buf.references, "References" },
      i = { vim.lsp.buf.incoming_calls, "Incoming Calls" },
      o = { vim.lsp.buf.outgoing_calls, "Outgoing Calls" },
      I = { vim.lsp.buf.implementation, "Implementations" },
      s = {
        name = "horizontal split",
        d = { utils.cmdThenFunc("split", vim.lsp.buf.definition), "Definition" },
        t = { utils.cmdThenFunc("split", vim.lsp.buf.type_definition), "Type definition" },
      },
      v = {
        name = "vertical split",
        d = { utils.cmdThenFunc("vsplit", vim.lsp.buf.definition), "Definition" },
        t = { utils.cmdThenFunc("vsplit", vim.lsp.buf.type_definition), "Type definition" },
      },
    },
    w = {
      name = "workspace actions",
      a = { vim.lsp.buf.add_workspace_folder, "Add workspace Folder" },
      r = { vim.lsp.buf.remove_workspace_folder, "Remove workspace Folder" },
      l = { vim.lsp.buf.list_workspace_folders, "List workspace Folder" },
    },
  },
}, {
  prefix = "<leader>",
})

vim.api.nvim_create_user_command("PeekToggle", utils.toggle_peek, { nargs = 0 })
vim.api.nvim_create_user_command("Reload", utils.reloadConfig, { nargs = 0 })
vim.api.nvim_create_user_command("Open", "!xdg-open %", { nargs = 0 })
