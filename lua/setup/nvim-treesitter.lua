
--@assignment.inner
--@assignment.lhs
--@assignment.outer
--@assignment.rhs
--@comment.outer
--@conditional.inner
--@conditional.outer
--@function.inner
--@function.outer
--@loop.inner
--@loop.outer
--@number.inner
--@regex.inner
--

require 'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
--        ["ia"] = "@assignment.inner",
--        ["aa"] = "@assignment.outer",
        ["aF"] = "@function.outer",
        ["iF"] = "@function.inner",
--        ["ac"] = "@class.outer",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
--        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
--        -- You can also use captures from other query groups like `locals.scm`
--        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
--      selection_modes = {
--        ['@parameter.outer'] = 'v', -- charwise
--        ['@function.outer'] = 'V', -- linewise
--        ['@class.outer'] = '<c-v>', -- blockwise
--      },
    },
  },
  -- A list of parser names, or "all"
  ensure_installed = {
    "bash",
    "dockerfile",
    "go",
    "gomod",
    "hcl",
    "javascript",
    "json",
    "lua",
    "make",
    "markdown",
    "python",
    "rust",
    "terraform",
    "yaml",
  },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = {},

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = {},

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    --    additional_vim_regex_highlighting = false,
    additional_vim_regex_highlighting = { "markdown" },
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true
  },
}

--vim.opt.foldmethod = "expr"
--vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
