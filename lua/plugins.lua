local function get_config(plugin, opts)
  require("setup/" .. plugin.name:gsub(".nvim", ""):gsub(".lua", ""):lower())
end

local enabled = true

return {
  {
    "vhyrro/luarocks.nvim",
    priority = 10000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    opts = {
      rocks = { "magick" }, -- specifies a list of rocks to install
      -- luarocks_build_args = { "--with-lua=/my/path" }, -- extra options to pass to luarocks's configuration script
    },
  },
  {
    "mrWinston/mdrun.nvim",
    -- use local files in code folder instead of gh
    dev = true,
    config = get_config,
    enabled = enabled,
  },
  {
    "mrWinston/granite.nvim",
    -- use local files in code folder instead of gh
    dev = true,
    config = get_config,
    enabled = enabled,
  },
  {
    "mrWinston/jqpreview.nvim",
    -- use local files in code folder instead of gh
--    dev = true,
    enabled = enabled,
  },
  {
    "mfussenegger/nvim-dap",
    config = get_config,
    enabled = enabled,
  },
  { "leoluz/nvim-dap-go", enabled = enabled },
  { "theHamsta/nvim-dap-virtual-text", enabled = enabled },
  {
    "folke/which-key.nvim",
    config = get_config,
    enabled = enabled,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    enabled = enabled,
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    config = get_config,
    lazy = true,
    enabled = enabled,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    enabled = enabled,
  },
  {
    "pwntester/octo.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      -- OR 'ibhagwan/fzf-lua',
      -- OR 'folke/snacks.nvim',
      "nvim-tree/nvim-web-devicons",
    },
    config = get_config,
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "saadparwaiz1/cmp_luasnip" },
    enabled = enabled,
  },
  {
    "benfowler/telescope-luasnip.nvim",
    enabled = enabled,
  },
  {
    "hrsh7th/nvim-cmp",
    enabled = enabled,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    enabled = enabled,
  },
  {
    "tpope/vim-fugitive",
    enabled = enabled,
  },
  {
    "tpope/vim-repeat",
    enabled = enabled,
  },
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      input = {
        -- your input configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    config = get_config,
    enabled = enabled,
  },
  {
    "sopa0/telescope-makefile",
    dependencies = "akinsho/toggleterm.nvim",
    enabled = enabled,
  },
  -- {
  --   "norcalli/nvim-terminal.lua",
  --   config = get_config,
  --   enabled = enabled,
  -- },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = get_config,
    enabled = enabled,
  },
  {
    "hedyhli/outline.nvim",
    config = get_config,
    enabled = enabled,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = get_config,
    enabled = enabled,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    enabled = enabled,
  },
  {
    "nvim-tree/nvim-web-devicons",
    enabled = enabled,
  },
  {
    "lucc/nvimpager",
    enabled = enabled,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = get_config,
    enabled = enabled,
  },
  {
    "neovim/nvim-lspconfig",
    config = get_config,
    lazy = false,
    opts = {
      inlay_hints = { enabled = true },
    },
    enabled = enabled,
  },
  {
    "akinsho/toggleterm.nvim",
    config = get_config,
    enabled = enabled,
  },
  {
    "echasnovski/mini.nvim",
    config = get_config,
    version = false,
    enabled = enabled,
  },
  {
    "nvim-lualine/lualine.nvim",
    config = get_config,
    enabled = enabled,
  },
  {
    "stevearc/conform.nvim",
    config = get_config,
    enabled = enabled,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = get_config,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
    },
    enabled = true,
  },
  -- {
  --   "seblj/nvim-tabline",
  --   config = get_config,
  --   enabled = enabled,
  -- },
  {
    "chrisgrieser/nvim-scissors",
    dependencies = "nvim-telescope/telescope.nvim", -- optional
    opts = {
      snippetDir = vim.fn.stdpath("config") .. "/snippets/vscode/",
      jsonFormatter = "jq",
      snippetSelection = {
        telescope = {
          -- By default, the query only searches snippet prefixes. Set this to
          -- `true` to also search the body of the snippets.
          alsoSearchSnippetBody = false,
        },
      },
    },
    enabled = enabled,
  },
  {
    "mrWinston/friendly-snippets",
    branch = "main",
    enabled = enabled,
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
      "ibhagwan/fzf-lua", -- optional
    },
    config = get_config,
    enabled = enabled,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    enabled = enabled,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
    enabled = enabled,
  },
  {
    "mrWinston/codesnap.nvim",
    build = "make build_generator",
    --    version = "^1",
    branch = "main",
    --    dev = true,
    opts = {
      save_path = "/home/maschulz/Pictures/codesnap.png",
      mac_window_bar = false, -- (Optional) MacOS style title bar switch
      opacity = true, -- (Optional) The code snap has some opacity by default, set it to false for 100% opacity
      watermark = "CodeSnap PR", -- (Optional) you can custom your own watermark, but if you don't like it, just set it to ""
      preview_title = "CodeSnap.nvim", -- (Optional) preview page title
      editor_font_family = "CaskaydiaCove Nerd Font", -- (Optional) preview code font family
      watermark_font_family = "Pacifico", -- (Optional) watermark font family
      bg_color = "#00000000",
    },
    enabled = enabled,
  },
  {
    "mfussenegger/nvim-ansible",
    enabled = enabled,
  },
  {
    "onsails/lspkind.nvim",
    enabled = enabled,
  },
  {
    "nvimtools/none-ls.nvim",
    enabled = enabled,
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    enabled = enabled,
  },
  {
    "hrsh7th/cmp-path",
    enabled = enabled,
  },
  {
    "kdheepak/lazygit.nvim",
    enabled = enabled,
  },
  {
    "rudylee/nvim-gist",
    enabled = enabled,
  },
  {
    "fladson/vim-kitty",
    enabled = enabled,
  },
  {
    "dkarter/bullets.vim",
    enabled = enabled,
  },
  {
    "projekt0n/github-nvim-theme",
    enabled = enabled,
  },
  {
    "f3fora/cmp-spell",
    enabled = enabled,
  },
  {
    "grapp-dev/nui-components.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "tinted-theming/base16-vim",
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "zbirenbaum/copilot.lua",
    },
    config = get_config,
  },
  -- {
  --   "OXY2DEV/markview.nvim",
  --   lazy = false, -- Recommended
  --   -- ft = "markdown" -- If you decide to lazy-load anyway
  --
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   config = get_config,
  -- },
}
