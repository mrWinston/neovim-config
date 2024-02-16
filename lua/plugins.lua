local function get_config(plugin, opts)
  require("setup/" .. plugin.name:gsub(".nvim", ""):gsub(".lua", ""):lower())
end

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
  },
  {
    "mrWinston/mdrun.nvim",
    -- use local files in code folder instead of gh
    dev = true,
    config = get_config,
  },
  {
    "mrWinston/granite.nvim",
    -- use local files in code folder instead of gh
    dev = true,
    config = get_config,
  },
  {
    "mrWinston/mdrun.nvim",
    -- use local files in code folder instead of gh
    dev = true,
    config = get_config,
    --    lazy = false,
  },
  {
    "marko-cerovac/material.nvim",
    config = get_config,
  },
  {
    "mfussenegger/nvim-dap",
    config = get_config,
  },
  {
    "folke/which-key.nvim",
    config = get_config,
  },
  {
    "folke/neodev.nvim",
    priority = 1000,
  },
  { "leoluz/nvim-dap-go" },
  { "theHamsta/nvim-dap-virtual-text" },
  { "gbrlsnchs/telescope-lsp-handlers.nvim" },
  {

    "edolphin-ydf/goimpl.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-lua/popup.nvim" },
      { "nvim-telescope/telescope.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = get_config,
    lazy = true,
  },
  {
    "ldelossa/gh.nvim",
    dependencies = {
      "ldelossa/litee.nvim",
    },
    config = get_config,
    lazy = false,
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "saadparwaiz1/cmp_luasnip" },
  },
  {
    "benfowler/telescope-luasnip.nvim",
  },
  {
    "hrsh7th/nvim-cmp",
  },
  {
    "hrsh7th/cmp-nvim-lsp",
  },
  {
    "tpope/vim-fugitive",
  },
  {
    "tpope/vim-repeat",
  },
  {
    "tpope/vim-surround",
  },
  {
    "lewis6991/gitsigns.nvim",
    config = get_config,
  },
  -- {
  --   "airblade/vim-gitgutter",
  -- },
  {
    "stevearc/dressing.nvim",
    config = get_config,
  },
  {
    "ggandor/lightspeed.nvim",
    config = get_config,
  },
  {
    "sopa0/telescope-makefile",
    --"mrWinston/telescope-makefile",
    --branch = "fix-merge-nil",
    dependencies = "akinsho/toggleterm.nvim",
  },
  {
    "norcalli/nvim-terminal.lua",
    config = get_config,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = get_config,
  },
  {
    "simrat39/symbols-outline.nvim",
    config = get_config,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = get_config,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  { "kyazdani42/nvim-web-devicons" },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "s1n7ax/nvim-window-picker",
    },
    config = get_config,
  },
  {
    "habamax/vim-asciidoctor",
    config = get_config,
  },
  {
    "neovim/nvim-lspconfig",
    config = get_config,
    lazy = false,
    opts = {
      inlay_hints = { enabled = true },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    config = get_config,
  },
  {
    "echasnovski/mini.nvim",
    config = get_config,
    version = false,
  },
  {
    "nvim-lualine/lualine.nvim",
    config = get_config,
  },
  {
    "stevearc/conform.nvim",
    config = get_config,
  },
  {
    "michaelb/sniprun",
    build = "sh ./install.sh",
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = get_config,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      --      "rcarriga/nvim-notify",
    },
  },
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup()
    end,
  },
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    config = get_config,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {}, -- this is equalent to setup({}) function
  },
  {
    "seblj/nvim-tabline",
    config = get_config,
  },
  {
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = true,
    lazy = true,
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    -- version = '^1.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
      require("kitty-scrollback").setup()
    end,
  },
  {
    "rcarriga/nvim-notify",
    lazy = true,
    opts = {
      render = "compact",
      timeout = "1000",
    },
  },
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neorg/neorg-telescope",
      "laher/neorg-exec",
    },
    config = get_config,
  },
  {
    "chrisgrieser/nvim-scissors",
    dependencies = "nvim-telescope/telescope.nvim", -- optional
    opts = {
      snippetDir = vim.fn.stdpath("config") .. "/snippets/vscode/",
      jsonFormatter = "jq",
      telescope = {
        -- By default, the query only searches snippet prefixes. Set this to
        -- `true` to also search the body of the snippets.
        alsoSearchSnippetBody = false,
      },
    },
  },
  {
    "mrWinston/friendly-snippets",
    branch = "main",
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
  },
  {
    "Everblush/nvim",
    name = "everblush",
    config = {
      transparent_background = true,
      nvim_tree = {
        contrast = true,
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = {
      style = "night",
      styles = {
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "normal", -- style for sidebars, see below
        floats = "dark", -- style for floating windows
      },
      transparent = true, -- Enable this to disable setting the background color
      dim_inactive = false,
      lualine_bold = true,
    },
  },
  "mfussenegger/nvim-ansible",
  "onsails/lspkind.nvim",
  "nvimtools/none-ls.nvim",
  "ElPiloto/significant.nvim",
  "folke/trouble.nvim",
  "sindrets/diffview.nvim",
  "hrsh7th/cmp-path",
  "kdheepak/lazygit.nvim",
  "rudylee/nvim-gist",
  "fladson/vim-kitty",
  "dkarter/bullets.vim",
  "projekt0n/github-nvim-theme",
  "f3fora/cmp-spell",
}
