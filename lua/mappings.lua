local utils = require("utils")

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

-- vim.keymap.set("n", "gx", ":te cd %:h && xdg-open '<cfile>'<cr>")

vim.keymap.set("n", "gx", utils.open_link_under_cursor)

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

vim.keymap.set("t", "<c-h>", "<C-\\><C-N><C-w>h")
vim.keymap.set("t", "<c-j>", "<C-\\><C-N><C-w>j")
vim.keymap.set("t", "<c-k>", "<C-\\><C-N><C-w>k")
vim.keymap.set("t", "<c-l>", "<C-\\><C-N><C-w>l")

vim.keymap.set({ "n", "i" }, "<c-t>", ":tabnew<cr>")

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.keymap.set("n", "zR", utils.openAllFolds)
vim.keymap.set("n", "zM", utils.closeAllFolds)
vim.keymap.set("n", "zm", utils.decreaseFoldLevel)
vim.keymap.set("n", "zr", utils.increaseFoldLevel)


--  map + <C-W>+
--  map - <C-W>-
vim.keymap.set("n", "+", "<C-W>>")
vim.keymap.set("n", "-", "<C-W><")

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



local gs = require("gitsigns.actions")
wk.add(
  {
    {
      mode = { "n", "v" },
      { "<leader>c", group = "code" },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "code actions" },
      { "<leader>cd", utils.toggle_autoformat, desc = "toggle autoformat after save" },
      { "<leader>cf", utils.wrapFunction(require("conform").format, { lsp_fallback = true }) , desc = "format file" },
      { "<leader>cg", group = "goto" },
      { "<leader>cgI", require("telescope.builtin").lsp_implementations, desc = "Implementations" },
      { "<leader>cgd", require("telescope.builtin").lsp_definitions, desc = "Definition" },
      { "<leader>cgi", require("telescope.builtin").lsp_incoming_calls, desc = "Incoming Calls" },
      { "<leader>cgo", require("telescope.builtin").lsp_outgoing_calls, desc = "Outgoing Calls" },
      { "<leader>cgr", require("telescope.builtin").lsp_references, desc = "References" },
      { "<leader>cgt", require("telescope.builtin").lsp_type_definitions, desc = "Type Definitions" },
      { "<leader>ch", vim.lsp.buf.signature_help, desc = "Signature Help" },
      { "<leader>ci", utils.goimpl, desc = "Run go impl" },
      { "<leader>cr", vim.lsp.buf.rename, desc = "rename function or variable" },
      { "<leader>cs", group = "snippets" },
      { "<leader>csa", require("scissors").editSnippet, desc = "Add Snippet" },
      { "<leader>cse", require("scissors").editSnippet, desc = "Edit snippet" },
      { "<leader>cu", group = "Utility Stuff" },
      { "<leader>cut",utils.generateGoStructTags, desc = "Generate Go struct tags" },
      { "<leader>e", group = "errors" },
      { "<leader>el", vim.diagnostic.setloclist, desc = "Show Errors" },
      { "<leader>en", utils.wrapFunction(vim.diagnostic.jump, {count = 1}), desc = "Go to Next" },
      { "<leader>eo", vim.diagnostic.open_float, desc = "Open Float Window" },
      { "<leader>ep", utils.wrapFunction(vim.diagnostic.jump, {count = -1}), desc = "Go to Previous" },
      { "<leader>f", group = "find" },
      { "<leader>fb", require("telescope.builtin").buffers, desc = "Buffers" },
      { "<leader>fc", require("telescope.builtin").commands, desc = "Commands" },
      { "<leader>ff",require("telescope.builtin").find_files , desc = "Files" },
      { "<leader>fg", require("telescope.builtin").live_grep, desc = "File content (grep)" },
      { "<leader>fh", require("telescope.builtin").help_tags, desc = "Help" },
      { "<leader>fj", require("telescope.builtin").jumplist, desc = "Jumplist" },
      { "<leader>fm", ":Telescope make<cr>", desc = "Run Make Targets" },
      { "<leader>fn", require("telescope").extensions.notify.notify, desc = "Show Notifications" },
      { "<leader>fp", require("telescope").extensions.gopass.gopass, desc = "Gopass" },
      { "<leader>fs", require("telescope.builtin").treesitter, desc = "Symbols" },
      { "<leader>ft", require("telescope.builtin").builtin, desc = "Telescope Pickers" },
      { "<leader>fw", require("telescope").extensions.windows.windows, desc = "Show Windows" },

      { "<leader>g", group = "git" },
      { "<leader>gG", group = "gists" },
      { "<leader>gGc", ":GistCreate<cr>", desc = "Create Gists" },
      { "<leader>gGl", ":GistList<cr>", desc = "List Gists" },
      { "<leader>gP", ":Git push<cr>", desc = "Push" },
      { "<leader>gb", group = "Branches" },
      { "<leader>gbc",require("telescope.builtin").git_branches, desc = "Checkout" },
      { "<leader>gbd",utils.gitDiffBranch, desc = "Diff" },
      { "<leader>gbn",utils.createGitBranch, desc = "New Branch" },
      { "<leader>gc", ":Git commit<cr>", desc = "Commit" },
      { "<leader>gg", group = "gitSigns" },
      { "<leader>ggB", gs.stage_buffer, desc = "stage buffer" },
      { "<leader>ggH", gs.select_hunk, desc = "Select Hunk" },
      { "<leader>ggI", gs.preview_hunk, desc = "Inspect Hunk" },
      { "<leader>ggS",gs.undo_stage_hunk, desc = "Undo Stage Hunk" },
      { "<leader>ggb",gs.blame_line , desc = "Blame Line" },
      { "<leader>ggi",gs.preview_hunk_inline, desc = "Inspect Hunk (inline)" },
      { "<leader>ggn", gs.next_hunk, desc = "Next Hunk" },
      { "<leader>ggp", gs.prev_hunk, desc = "Prev Hunk" },
      { "<leader>ggs",gs.stage_hunk, desc = "Stage Hunk" },
      { "<leader>ggt", group = "Toggle" },
      { "<leader>ggtb", gs.toggle_current_line_blame, desc = "Toggle line blame" },
      { "<leader>ggtd", gs.toggle_deleted, desc = "Toggle Deleted" },
      { "<leader>ggtl", gs.toggle_linehl, desc = "Toggle line higlighting" },
      { "<leader>ggtn", gs.toggle_numhl, desc = "Toggle num higlighting" },
      { "<leader>ggts",gs.toggle_signs, desc = "Toggle signs" },
      { "<leader>ggtw", gs.toggle_word_diff, desc = "Toggle word diff" },
      { "<leader>gh", group = "Github" },
      { "<leader>ghc", group = "Commits" },
      { "<leader>ghcc", "<cmd>GHCloseCommit<cr>", desc = "Close" },
      { "<leader>ghce", "<cmd>GHExpandCommit<cr>", desc = "Expand" },
      { "<leader>ghco", "<cmd>GHOpenToCommit<cr>", desc = "Open To" },
      { "<leader>ghcp", "<cmd>GHPopOutCommit<cr>", desc = "Pop Out" },
      { "<leader>ghcz", "<cmd>GHCollapseCommit<cr>", desc = "Collapse" },
      { "<leader>ghi", group = "Issues" },
      { "<leader>ghip", "<cmd>GHPreviewIssue<cr>", desc = "Preview" },
      { "<leader>ghl", group = "Litee" },
      { "<leader>ghlt", "<cmd>LTPanel<cr>", desc = "Toggle Panel" },
      { "<leader>ghp", group = "Pull Request" },
      { "<leader>ghpc", "<cmd>GHClosePR<cr>", desc = "Close" },
      { "<leader>ghpd", "<cmd>GHPRDetails<cr>", desc = "Details" },
      { "<leader>ghpe", "<cmd>GHExpandPR<cr>", desc = "Expand" },
      { "<leader>ghpo", "<cmd>GHOpenPR<cr>", desc = "Open" },
      { "<leader>ghpp", "<cmd>GHPopOutPR<cr>", desc = "PopOut" },
      { "<leader>ghpr", "<cmd>GHRefreshPR<cr>", desc = "Refresh" },
      { "<leader>ghpt", "<cmd>GHOpenToPR<cr>", desc = "Open To" },
      { "<leader>ghpz", "<cmd>GHCollapsePR<cr>", desc = "Collapse" },
      { "<leader>ghr", group = "Review" },
      { "<leader>ghrb", "<cmd>GHStartReview<cr>", desc = "Begin" },
      { "<leader>ghrc", "<cmd>GHCloseReview<cr>", desc = "Close" },
      { "<leader>ghrd", "<cmd>GHDeleteReview<cr>", desc = "Delete" },
      { "<leader>ghre", "<cmd>GHExpandReview<cr>", desc = "Expand" },
      { "<leader>ghrs", "<cmd>GHSubmitReview<cr>", desc = "Submit" },
      { "<leader>ghrz", "<cmd>GHCollapseReview<cr>", desc = "Collapse" },
      { "<leader>ght", group = "Threads" },
      { "<leader>ghtc", "<cmd>GHCreateThread<cr>", desc = "Create" },
      { "<leader>ghtn", "<cmd>GHNextThread<cr>", desc = "Next" },
      { "<leader>ghtt", "<cmd>GHToggleThread<cr>", desc = "Toggle" },
      { "<leader>gl", ":LazyGit<cr>", desc = "Lazygit" },
      { "<leader>go", ":!gh browse %:.<cr>", desc = "Open in Github" },
      { "<leader>gp", ":Git pull<cr>", desc = "Pull" },
      { "<leader>gs", ":Git<cr>", desc = "Status" },

      { "<leader>k", group = "Knowledge mappings" },
      { "<leader>kd", ":ParseDate<cr>", desc = "Parse selected Date String" },
      { "<leader>kh",require("granite").newHandwritten , desc = "New Handwriting for this note" },
      { "<leader>kk", vim.fn.MdrunKillCodeblock, desc = "Kill running codeblock under cursor" },
      { "<leader>kl", require("granite").link_to_file, desc = "insert link" },
      { "<leader>kn", require("granite").new_note_from_template, desc = "New Note" },
      { "<leader>ko", require("granite").open_note, desc = "Open note" },
      { "<leader>kp", require("granite").ParseCodequeries, desc = "Parse and fill codequery blocks" },
      { "<leader>kr", require("mdrun").run_codeblock_under_cursor, desc = "run codeblock under cursor" },
      { "<leader>ks", utils.screenshot, desc = "Screenshot Selection" },
      { "<leader>kt", group = "Todos" },
      { "<leader>kta", utils.wrapFunction(require("telescope").extensions.granite_telescope.granite_telescope, {}), desc = "all Todos" },
      { "<leader>ktd",utils.wrapFunction(require("telescope").extensions.granite_telescope.granite_telescope, { states = {"DONE"}}), desc = "done Todos" },
      { "<leader>kto",utils.wrapFunction(require("telescope").extensions.granite_telescope.granite_telescope, { states = {"OPEN", "IN_PROGRESS"}}), desc = "Open Todos" },

      { "<leader>l", require("lazy").home, desc = "Lazy" },
      { "<leader>r", group = "run" },
      { "<leader>rf", require("tools.runlib").Pick, desc = "search runnables" },
      { "<leader>rr",askCommandRun, desc = "Run command" },
      { "<leader>rt", group = "ToggleTerm" },
      { "<leader>rtl", ":ToggleTermSendCurrentLine<cr>", desc = "Run Line" },
      { "<leader>rtt", ":ToggleTerm<cr>", desc = "Toggle Terminal Window" },
      { "<leader>rtv", ":ToggleTermSendVisualSelection<cr>", desc = "Run Selection" },
      { "<leader>ru", group = "terraform" },
      { "<leader>rup", createRunFunc("terraform plan"), desc = "plan" },
      { "<leader>t", utils.wrapFunction( require("neo-tree.command").execute, { toggle = true }), desc = "Open Neotree" },
      { "<leader>u", group = "utils" },
      { "<leader>ua", utils.replaceAcronym, desc = "Replace Acronym under Cursor" },
      { "<leader>uc", utils.toggleCheckbox, desc = "Toggle Checkbox" },
      { "<leader>ud", ":Noice dismiss<cr>", desc = "Dismiss Notifications" },
      { "<leader>ul", group = "lsp/treesitter" },
      { "<leader>uli", ":LspInfo<cr>", desc = "Lsp Server Info" },
      { "<leader>ull", ":LspLog<cr>", desc = "Lsp Server Logs" },
      { "<leader>ulr", ":LspRestart<cr>", desc = "Restart Lsp Server" },
      { "<leader>ult", vim.treesitter.inspect_tree, desc = "Show Treesitter Tree" },
      { "<leader>um",require("mini.files").open, desc = "Mini Files" },
      { "<leader>un", ":nohlsearch<cr>", desc = "Hide Search Results" },
      { "<leader>uo",require("outline").toggle_outline, desc = "Show Outline" },
      { "<leader>up",require("tools.pagerduty").Pick, desc = "Look at Pagerduty" },
      { "<leader>ur", group = "replace hotkeys" },
      { "<leader>urn", ":s/\n//g<cr>", desc = "Remove Linebreaks" },
      { "<leader>urt", utils.ticket_to_md_link, desc = "Convert to jira link" },
      { "<leader>us", group = "Spellcheck" },
      { "<leader>use", ":setlocal spell spelllang=en_us<cr>", desc = "Enable English Spellcheck" },
      { "<leader>usg", ":setlocal spell spelllang=de_20<cr>", desc = "Enable German Spellcheck" },
      { "<leader>uw", group = "neovide scaling" },
      { "<leader>uwd",utils.wrapFunction(change_neovide_scale_factor, 1.25), desc = "Decrease" },
      { "<leader>uwi",utils.wrapFunction(change_neovide_scale_factor, 1 / 1.25), desc = "Increase" },
    },
  }
)

vim.api.nvim_create_user_command("PeekToggle", utils.toggle_peek, { nargs = 0 })
vim.api.nvim_create_user_command("Reload", utils.reloadConfig, { nargs = 0 })
vim.api.nvim_create_user_command("Open", "!xdg-open %", { nargs = 0 })
