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
    "mfussenegger/nvim-dap",
    config = get_config,
    enabled = enabled,
  },
  {
    "folke/which-key.nvim",
    config = get_config,
    enabled = enabled,
  },
  {
    "folke/neodev.nvim",
    priority = 1000,
    enabled = enabled,
  },
  { "leoluz/nvim-dap-go", enabled = enabled },
  { "theHamsta/nvim-dap-virtual-text", enabled = enabled },
  { "gbrlsnchs/telescope-lsp-handlers.nvim", enabled = enabled },
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
    dependencies = { "nvim-lua/plenary.nvim" },
    config = get_config,
    lazy = true,
    enabled = enabled,
  },
  {
    "ldelossa/gh.nvim",
    dependencies = {
      "ldelossa/litee.nvim",
    },
    config = get_config,
    lazy = true,
    enabled = enabled,
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
    "lewis6991/gitsigns.nvim",
    config = get_config,
    enabled = enabled,
  },
  {
    "stevearc/dressing.nvim",
    config = get_config,
    enabled = enabled,
  },
  {
    "sopa0/telescope-makefile",
    dependencies = "akinsho/toggleterm.nvim",
    enabled = enabled,
  },
  {
    "norcalli/nvim-terminal.lua",
    config = get_config,
    enabled = enabled,
  },
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
    "kyazdani42/nvim-web-devicons",
    enabled = enabled,
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
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      --      "rcarriga/nvim-notify",
    },
    enabled = enabled,
  },
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup()
    end,
    enabled = enabled,
  },
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    config = get_config,
    enabled = enabled,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {}, -- this is equalent to setup({}) function
    enabled = enabled,
  },
  {
    "seblj/nvim-tabline",
    config = get_config,
    enabled = enabled,
  },
  {
    "rcarriga/nvim-notify",
    lazy = true,
    opts = {
      render = "compact",
      timeout = "1000",
      top_down = false,
    },
    enabled = enabled,
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
    "rcjkb/rustaceanvim",
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
}
