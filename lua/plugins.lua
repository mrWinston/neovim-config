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
    'marko-cerovac/material.nvim',
    config = get_config
  },
  {
    'mfussenegger/nvim-dap',
    config = get_config,
  },
  {
    'folke/which-key.nvim',
    config = get_config,
  },
  { 'leoluz/nvim-dap-go', },
  { 'theHamsta/nvim-dap-virtual-text' },
  { 'gbrlsnchs/telescope-lsp-handlers.nvim' },
  {

    'edolphin-ydf/goimpl.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-lua/popup.nvim' },
      { 'nvim-telescope/telescope.nvim' },
      { 'nvim-treesitter/nvim-treesitter' },
    },
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' }
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-dap.nvim' },
    config = get_config,
  },
  {
    'saadparwaiz1/cmp_luasnip'
  },
  {
    'L3MON4D3/LuaSnip',
    config = get_config,
  },
  {
    'benfowler/telescope-luasnip.nvim'
  },
  {
    'hrsh7th/nvim-cmp'
  },
  {
    'hrsh7th/cmp-nvim-lsp'
  },
  {
    'hrsh7th/cmp-nvim-lsp-signature-help'
  },
  {
    'ray-x/lsp_signature.nvim'
  },
  {
    'tpope/vim-fugitive'
  },
  {
    'tpope/vim-repeat'
  },
  {
    'tpope/vim-surround'
  },
  {
    'airblade/vim-gitgutter'
  },
  {
    'stevearc/dressing.nvim',
    config = get_config,
  },
  {
    'ggandor/lightspeed.nvim',
    config = get_config,
  },
  {
    "mrWinston/telescope-makefile",
    branch = "fix-merge-nil",
    dependencies = "akinsho/toggleterm.nvim",
  },
  {
    'norcalli/nvim-terminal.lua',
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
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = get_config,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  { 'kyazdani42/nvim-web-devicons' },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = get_config,
  },
  {
    'habamax/vim-asciidoctor',
    config = get_config,
  },
  {
    'neovim/nvim-lspconfig',
    config = get_config,
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
    'mcchrish/zenbones.nvim',
    dependencies = { 'rktjmp/lush.nvim' },
  },
  {
    'nvim-lualine/lualine.nvim',
    config = get_config,
  },
  {
    'stevearc/conform.nvim',
    config = get_config,
  },
  'sindrets/diffview.nvim',
  'hrsh7th/cmp-path',
  'ray-x/lsp_signature.nvim',
  'rafamadriz/friendly-snippets',
  'kdheepak/lazygit.nvim',
  'rudylee/nvim-gist',
  'fladson/vim-kitty',
  'dkarter/bullets.vim',
  'projekt0n/github-nvim-theme',
}
