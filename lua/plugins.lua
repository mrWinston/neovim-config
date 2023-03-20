local function get_setup(name)
  return string.format('require("setup/%s")', name)
end

local use = require('packer').use

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } },
    config = get_setup('telescope'),
  }
  use {
    'ggandor/lightspeed.nvim',
    config = get_setup('lightspeed')
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = get_setup('nvim-treesitter')
  }
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    tag = 'nightly',
    config = get_setup('nvim-tree')
  }
  use {
    'marko-cerovac/material.nvim',
    config = get_setup('material-nvim')
  }
  use {
    'habamax/vim-asciidoctor',
    config = get_setup('vim-asciidoctor')
  }
  use {
    'neovim/nvim-lspconfig',
    config = get_setup('nvim-lspconfig')
  }
  use {
    'hrsh7th/nvim-cmp'
  }
  use {
    'hrsh7th/cmp-nvim-lsp'
  }
  use {
    'hrsh7th/cmp-nvim-lsp-signature-help'
  }
  use {
    'ray-x/lsp_signature.nvim'
  }
  use {
    'saadparwaiz1/cmp_luasnip'
  }
  use {
    'L3MON4D3/LuaSnip',
    config = get_setup('luasnip')
  }
  use {
    'tpope/vim-fugitive'
  }
  use {
    'tpope/vim-repeat'
  }
  use {
    'tpope/vim-surround'
  }
  use {
    'airblade/vim-gitgutter'
  }
  use {
    'mfussenegger/nvim-dap',
    config = get_setup('dap'),
  }
  use {
    'leoluz/nvim-dap-go'
  }
  use {
    'nvim-telescope/telescope-dap.nvim'
  }
  use {
    'theHamsta/nvim-dap-virtual-text'
  }
  use {
    "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap" }
  }
  use {
    'gbrlsnchs/telescope-lsp-handlers.nvim'
  }
  use {
    'stevearc/dressing.nvim',
    config = get_setup('dressing'),
  }
  use {
    'edolphin-ydf/goimpl.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-lua/popup.nvim' },
      { 'nvim-telescope/telescope.nvim' },
      { 'nvim-treesitter/nvim-treesitter' },
    },
  }
  use {
    'benfowler/telescope-luasnip.nvim'
  }
  use {
    'rafamadriz/friendly-snippets'
  }
  use {
    'kdheepak/lazygit.nvim',
    config = get_setup('lazygit'),
  }
  use {
    "folke/which-key.nvim",
    config = get_setup('which-key'),
  }
  use {
    'sebdah/vim-delve',
    config = get_setup('vim-delve'),
  }
  -- Lua
  use {
    "hrsh7th/cmp-path",
    requires = "hrsh7th/nvim-cmp",
  }

  use {
    "akinsho/toggleterm.nvim",
    config = get_setup("toggleterm"),
  }
  use {
    "kevinhwang91/nvim-ufo",
    requires = "kevinhwang91/promise-async",
    config = get_setup("nvim-ufo")
  }

  use {
    "mrWinston/telescope-makefile",
    branch = "fix-merge-nil",
    requires = "akinsho/toggleterm.nvim",
  }

  use {
    "rudylee/nvim-gist"
  }

  use {
    "simrat39/symbols-outline.nvim",
    config = get_setup("symbols-outline"),
  }

  use {
    "epwalsh/obsidian.nvim",
    config = get_setup("obsidian"),
  }

  use {
    "fladson/vim-kitty"
  }

end)
