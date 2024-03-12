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
    f = { require("tools.runlib").Pick, "search runnables" },
    u = {
      name = "terraform",
      p = { createRunFunc("terraform plan"), "plan" },
    },
    t = {
      name = "ToggleTerm",
      t = { ":ToggleTerm<cr>", "Toggle Terminal Window" },
      v = { ":ToggleTermSendVisualSelection<cr>", "Run Selection" },
      l = { ":ToggleTermSendCurrentLine<cr>", "Run Line" },
    },
  },
  f = {
    name = "find",
    f = {
      function()
        require("telescope.builtin").find_files()
      end,
      "Files",
    },
    g = {
      function()
        require("telescope.builtin").live_grep()
      end,
      "File content (grep)",
    },
    b = {
      function()
        require("telescope.builtin").buffers()
      end,
      "Buffers",
    },
    h = {
      function()
        require("telescope.builtin").help_tags()
      end,
      "Help",
    },
    c = {
      function()
        require("telescope.builtin").commands()
      end,
      "Commands",
    },
    t = { utils.wrapFunction(require("telescope.builtin").builtin, { include_extensions = true }), "Telescope Pickers" },
    s = {
      function()
        require("telescope.builtin").treesitter()
      end,
      "Symbols",
    },
    j = {
      function()
        require("telescope.builtin").jumplist()
      end,
      "Jumplist",
    },
    m = { ":Telescope make<cr>", "Run Make Targets" },
   n = {
      function()
        require("telescope").extensions.notify.notify()
      end,
      "Show Notifications",
    },
    p = {
      function()
        require("telescope").extensions.gopass.gopass()
      end,
      "Gopass",
    },
    w = {
      function()
        require("telescope").extensions.windows.windows()
      end, "Show Windows"
    }
  },
  g = require("mappings_git"),
  t = {
    function()
      require("neo-tree.command").execute({ toggle = true })
    end,
    "Open Neotree",
  },
  l = { require("lazy").home, "Lazy" },
  u = {
    name = "utils",
    a = { utils.replaceAcronym, "Replace Acronym under Cursor" },
    c = { utils.toggleCheckbox, "Toggle Checkbox" },
    d = { ":Noice dismiss<cr>", "Dismiss Notifications" },
    f = { utils.wrapFunction(require("conform").format, { lsp_fallback = true }), "format file" },
    l = {
      name = "lsp/treesitter",
      r = { ":LspRestart<cr>", "Restart Lsp Server" },
      i = { ":LspInfo<cr>", "Lsp Server Info" },
      l = { ":LspLog<cr>", "Lsp Server Logs" },
      t = { vim.treesitter.inspect_tree, "Show Treesitter Tree" },
    },
    m = {
      function()
        require("mini.files").open()
      end,
      "Mini Files",
    },
    n = { ":nohlsearch<cr>", "Hide Search Results" },
    o = {
      function()
        require("symbols-outline").toggle_outline()
      end,
      "Show Outline",
    },
    r = {
      name = "replace hotkeys",
      n = { ":s/\n//g<cr>", "Remove Linebreaks" },
      t = { utils.ticket_to_md_link, "Convert to jira link" },
    },
    s = {
      name = "Spellcheck",
      e = { ":setlocal spell spelllang=en_us<cr>", "Enable English Spellcheck" },
      g = { ":setlocal spell spelllang=de_20<cr>", "Enable German Spellcheck" },
    },
    w = {
      name = "neovide scaling",
      i = { utils.wrapFunction(change_neovide_scale_factor, 1.25), "Increase" },
      d = { utils.wrapFunction(change_neovide_scale_factor, 1 / 1.25), "Decrease" },
    },
    i = { require("tools.install").installAll, "Install Dependencies" },
  },
  o = {
    name = "oc commands",
    n = { require("tools.kube").ChooseNamespace, "set namespace" },
    f = { require("tools.kube").ChooseOutputFormat, "set output format" },
    u = { require("tools.kube").Update, "update resources and namespaces" },
    g = { require("tools.kube").Get, "Get something" },
    d = { require("tools.kube").Describe, "Describe resource" },
    D = { require("tools.kube").DescribeCursor, "Describe resource under cursor" },
  },
  k = {
    name = "Knowledge mappings",
    o = { require("granite").open_note, "Open note" },
    t = {
      name = "Todos",
      o = {
        function()
          require("telescope").extensions.granite_telescope.granite_telescope({ states = { "OPEN", "IN_PROGRESS" } })
        end,
        "Open Todos",
      },
      a = {
        function()
          require("telescope").extensions.granite_telescope.granite_telescope({})
        end,
        "all Todos",
      },
      d = {
        function()
          require("telescope").extensions.granite_telescope.granite_telescope({ states = { "DONE" } })
        end,
        "done Todos",
      },
    },
    n = { require("granite").new_note_from_template, "New Note" },
    l = { require("granite").link_to_file, "insert link" },
    h = { require("granite").newHandwritten, "New Handwriting for this note" },
    d = { ":ParseDate<cr>", "Parse selected Date String" },
    p = { require("granite").ParseCodequeries, "Parse and fill codequery blocks" },
    r = { vim.fn.MdrunRunCodeblock, "run codeblock under cursor" },
    k = { vim.fn.MdrunKillCodeblock, "Kill running codeblock under cursor" },
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
    d = { utils.toggle_autoformat, "toggle autoformat after save" },
    s = {
      name = "snippets",
      e = {
        function()
          require("scissors").editSnippet()
        end,
        "Edit snippet",
      },
      a = {
        function()
          require("scissors").addNewSnippet()
        end,
        "Add Snippet",
      },
    },
    f = { utils.wrapFunction(require("conform").format, { lsp_fallback = true }), "format file" },
    h = { vim.lsp.buf.signature_help, "Signature Help" },
    g = {
      name = "goto",
      d = {
        function()
          require("telescope.builtin").lsp_definitions({ jump_type = "never" })
        end,
        "Definition",
      },
      t = {
        function()
          require("telescope.builtin").lsp_type_definitions({ jump_type = "never" })
        end,
        "Type definition",
      },
      r = {
        function()
          require("telescope.builtin").lsp_references({ jump_type = "never" })
        end,
        "References",
      },
      i = {
        function()
          require("telescope.builtin").lsp_incoming_calls({ jump_type = "never" })
        end,
        "Incoming Calls",
      },
      o = {
        function()
          require("telescope.builtin").lsp_outgoing_calls({ jump_type = "never" })
        end,
        "Outgoing Calls",
      },
      I = {
        function()
          require("telescope.builtin").lsp_implementations({ jump_type = "never" })
        end,
        "Implementations",
      },
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
    i = { utils.goimpl, "Run go impl" },
    u = {
      name = "Utility Stuff",
      t = { utils.generateGoStructTags, "Generate Go struct tags" },
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
  mode = { "n", "v" },
})

vim.api.nvim_create_user_command("PeekToggle", utils.toggle_peek, { nargs = 0 })
vim.api.nvim_create_user_command("Reload", utils.reloadConfig, { nargs = 0 })
vim.api.nvim_create_user_command("Open", "!xdg-open %", { nargs = 0 })
