local function get_config(plugin, opts)
  require("setup/" .. plugin.name:gsub(".nvim", ""):gsub(".lua", ""):lower())
end

local enabled = true

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    enable = enabled,
  },
  {
    "mrWinston/mdrun.nvim",
    -- use local files in code folder instead of gh
    dev = true,
    config = get_config,
    enable = enabled,
  },
  {
    "mrWinston/granite.nvim",
    -- use local files in code folder instead of gh
    dev = true,
    config = get_config,
    enable = enabled,
  },
  {
    "mrWinston/mdrun.nvim",
    -- use local files in code folder instead of gh
    dev = true,
    config = get_config,
    --    lazy = false,
    enable = enabled,
  },
  {
    "marko-cerovac/material.nvim",
    config = get_config,
    enable = enabled,
  },
  {
    "mfussenegger/nvim-dap",
    config = get_config,
    enable = enabled,
  },
  {
    "folke/which-key.nvim",
    config = get_config,
    enable = enabled,
  },
  {
    "folke/neodev.nvim",
    priority = 1000,
    enable = enabled,
  },
  { "leoluz/nvim-dap-go", enable = enabled },
  { "theHamsta/nvim-dap-virtual-text", enable = enabled },
  { "gbrlsnchs/telescope-lsp-handlers.nvim", enable = enabled },
  {

    "edolphin-ydf/goimpl.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-lua/popup.nvim" },
      { "nvim-telescope/telescope.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    enable = enabled,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    enable = enabled,
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = get_config,
    lazy = true,
    enable = enabled,
  },
  {
    "ldelossa/gh.nvim",
    dependencies = {
      "ldelossa/litee.nvim",
    },
    config = get_config,
    lazy = false,
    enable = enabled,
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "saadparwaiz1/cmp_luasnip" },
    enable = enabled,
  },
  {
    "benfowler/telescope-luasnip.nvim",
    enable = enabled,
  },
  {
    "hrsh7th/nvim-cmp",
    enable = enabled,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    enable = enabled,
  },
  {
    "tpope/vim-fugitive",
    enable = enabled,
  },
  {
    "tpope/vim-repeat",
    enable = enabled,
  },
--  {
--    "tpope/vim-surround",
--    enable = enabled,
--  },
  {
    "lewis6991/gitsigns.nvim",
    config = get_config,
    enable = enabled,
  },
  {
    "stevearc/dressing.nvim",
    config = get_config,
    enable = enabled,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      {
        "f",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "F",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-f>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
    enable = enabled,
  },
  {
    "sopa0/telescope-makefile",
    --"mrWinston/telescope-makefile",
    --branch = "fix-merge-nil",
    dependencies = "akinsho/toggleterm.nvim",
    enable = enabled,
  },
  {
    "norcalli/nvim-terminal.lua",
    config = get_config,
    enable = enabled,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = get_config,
    enable = enabled,
  },
  {
    "simrat39/symbols-outline.nvim",
    config = get_config,
    enable = enabled,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = get_config,
    enable = enabled,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    enable = enabled,
  },
  {
    "kyazdani42/nvim-web-devicons",
    enable = enabled,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "s1n7ax/nvim-window-picker",
    },
    config = get_config,
    enable = enabled,
  },
  {
    "habamax/vim-asciidoctor",
    config = get_config,
    enable = enabled,
  },
  {
    "neovim/nvim-lspconfig",
    config = get_config,
    lazy = false,
    opts = {
      inlay_hints = { enabled = true },
    },
    enable = enabled,
  },
  {
    "akinsho/toggleterm.nvim",
    config = get_config,
    enable = enabled,
  },
  {
    "echasnovski/mini.nvim",
    config = get_config,
    version = false,
    enable = enabled,
  },
  {
    "nvim-lualine/lualine.nvim",
    config = get_config,
    enable = enabled,
  },
  {
    "stevearc/conform.nvim",
    config = get_config,
    enable = enabled,
  },
  {
    "michaelb/sniprun",
    build = "sh ./install.sh",
    enable = enabled,
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
    enable = enabled,
  },
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup()
    end,
    enable = enabled,
  },
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    config = get_config,
    enable = enabled,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {}, -- this is equalent to setup({}) function
    enable = enabled,
  },
  {
    "seblj/nvim-tabline",
    config = get_config,
    enable = enabled,
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
    enable = enabled,
  },
  {
    "rcarriga/nvim-notify",
    lazy = true,
    opts = {
      render = "compact",
      timeout = "1000",
      top_down = false,
    },
    enable = enabled,
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
    enable = enabled,
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
    enable = enabled,
  },
  {
    "mrWinston/friendly-snippets",
    branch = "main",
    enable = enabled,
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
    enable = enabled,
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
    enable = enabled,
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
    enable = enabled,
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    enable = enabled,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    enable = enabled,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
    enable = enabled,
  },
  {
    "mrWinston/codesnap.nvim",
    build = "make build_generator",
    --    version = "^1",
    branch = "main",
    dev = true,
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
    enable = enabled,
  },
  {
    "3rd/image.nvim",
    enable = enabled,
    config = get_config,
  },
  {
    "mfussenegger/nvim-ansible",
    enable = enabled,
  },
  {
    "onsails/lspkind.nvim",
    enable = enabled,
  },
  {
    "nvimtools/none-ls.nvim",
    enable = enabled,
  },
  {
    "ElPiloto/significant.nvim",
    enable = enabled,
  },
  {
    "folke/trouble.nvim",
    enable = enabled,
  },
  {
    "sindrets/diffview.nvim",
    enable = enabled,
  },
  {
    "hrsh7th/cmp-path",
    enable = enabled,
  },
  {
    "kdheepak/lazygit.nvim",
    enable = enabled,
  },
  {
    "rudylee/nvim-gist",
    enable = enabled,
  },
  {
    "fladson/vim-kitty",
    enable = enabled,
  },
  {
    "dkarter/bullets.vim",
    enable = enabled,
  },
  {
    "projekt0n/github-nvim-theme",
    enable = enabled,
  },
  {
    "f3fora/cmp-spell",
    enable = enabled,
  },
}
