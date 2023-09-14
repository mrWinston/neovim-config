-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

-- full settings see https://github.com/ray-x/lsp_signature.nvim#full-configuration-with-default-values
local signature_help_settings = {
  bind = true, -- This is mandatory, otherwise border config won't get registered.
  handler_opts = {
    border = "rounded",
  },
}

local function get_maingo()
  return vim.fn.findfile("main.go", ".;")
end
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- enable formatting for yamlls
  if client.name == "yamlls" then
    client.server_capabilities.documentFormattingProvider = true
  end
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  local wk = require("which-key")
  local utils = require("utils")
  require("lsp_signature").on_attach(signature_help_settings, bufnr)
  --  vim.api.nvim_create_autocmd( "CursorHold", {
  --    buffer = bufnr,
  --    callback = vim.lsp.buf.hover,
  --  })

  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  --  vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]

  vim.cmd([[au FileType dap-repl lua require('dap.ext.autocompl').attach() ]])

  wk.register({}, {
    buffer = bufnr,
    prefix = "<leader>",
  })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities()
--capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

require("lspconfig").lua_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim", "root", "awesome", "client", "screen" },
      },
      workspace = {
        checkThirdParty = false,
        -- Make the server aware of Neovim runtime files
        library = table.insert(vim.api.nvim_get_runtime_file("", true), "/usr/share/awesome/lib"),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

-- yarn global add @volar/vue-language-server
require("lspconfig").volar.setup({
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
})

local simpleLs = {
  "gopls", -- go install golang.org/x/tools/gopls@latest
  "bashls",
  "yamlls",
  "tsserver", -- yarn global add typescript typescript-language-server
  "eslint", -- yarn global add vscode-langservers-extracted
  "jedi_language_server",
  "terraformls", --asdf plugin-add terraform-ls && asdf install terraform-ls latest && asdf global terraform-ls latest
  "marksman", -- download from https://github.com/artempyanykh/marksman/releases
}

local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")

if not configs.markdown then
  configs.markdown = {
    default_config = {
      cmd = { "vscode-markdown-language-server", "--stdio" },
      filetypes = { "markdown" },
      root_dir = function(fname)
        return lspconfig.util.find_git_ancestor(fname)
      end,
      single_file_support = true,
      handlers = {
        ["markdown/parse"] = function(err, args, ctx, config)
          local tokens = vim.fn.Func(args)
          print(tokens)
          return tokens
        end,
      },
      settings = {},
    },
  }
end

for _, value in ipairs(simpleLs) do
  lspconfig[value].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

require("lspconfig").golangci_lint_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    command = { "golangci-lint", "run", "--out-format", "json", "-j", "2" },
  },
})

--require('lspconfig').gopls.setup({
--  on_attach = on_attach,
--  capabilities = capabilities,
--})
--require('lspconfig').bashls.setup({
--  on_attach = on_attach,
--  capabilities = capabilities,
--})
--
--require('lspconfig').yamlls.setup({
--  on_attach = on_attach,
--  capabilities = capabilities,
--})
--
---- yarn global add typescript typescript-language-server
--require('lspconfig').tsserver.setup({
--  on_attach = on_attach,
--  capabilities = capabilities,
--})
--
---- yarn global add vscode-langservers-extracted
--require('lspconfig').eslint.setup({
--  on_attach = on_attach,
--  capabilities = capabilities,
--})
--
---- pip install pyright --user
--require('lspconfig').pyright.setup({
--  on_attach = on_attach,
--  capabilities = capabilities,
--})
--

local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
-- nvim-cmp setup
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }),
    ["<C-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-p>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  preselect = cmp.PreselectMode.None,
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "nvim_lsp_signature_help" },
    { name = "path" },
  },
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
vim.diagnostic.config({
  float = {
    border = "rounded",
  },
})
