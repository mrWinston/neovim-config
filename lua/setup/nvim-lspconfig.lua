-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

require("telescope").load_extension("lsp_handlers")
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
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

  vim.cmd([[au FileType dap-repl lua require('dap.ext.autocompl').attach() ]])
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities()
--capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}


require("neodev").setup({
})

local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      }
    }
  }
})
-- lspconfig.lua_ls.setup({
--   on_attach = on_attach,
--   capabilities = capabilities,
--   settings = {
--     Lua = {
--       runtime = {
--         -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--         version = "LuaJIT",
--       },
--       diagnostics = {
--         -- Get the language server to recognize the `vim` global
--         globals = { "vim", "root", "awesome", "client", "screen" },
--       },
--       workspace = {
--         checkThirdParty = false,
--         -- Make the server aware of Neovim runtime files
--         library = { "/usr/share/awesome/lib" },
--       },
--       -- Do not send telemetry data containing a randomized but unique identifier
--       telemetry = {
--         enable = false,
--       },
--     },
--   },
-- })

-- yarn global add @volar/vue-language-server
lspconfig.volar.setup({
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
})

local simpleLs = {
  "gopls",
  "bashls",
  "tsserver", -- yarn global add typescript typescript-language-server
  "eslint", -- yarn global add vscode-langservers-extracted
  --  "jedi_language_server",
  "pylsp",
  "terraformls", --asdf plugin-add terraform-ls && asdf install terraform-ls latest && asdf global terraform-ls latest
  "marksman", -- download from https://github.com/artempyanykh/marksman/releases
  --  "remark_ls",
  "yamlls",
  "ansiblels",
}

for _, value in ipairs(simpleLs) do
  lspconfig[value].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- lspconfig.golangci_lint_ls.setup({
--   on_attach = on_attach,
--   capabilities = capabilities,
--   init_options = {
--     command = { "golangci-lint", "run", "--out-format", "json", "-j", "2" },
--   },
-- })

local luasnip = require("luasnip")
luasnip.log.set_loglevel("info")
require("luasnip.loaders.from_vscode").lazy_load({ override_priority = 1000 })
require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets/vscode" }, override_priority = 1100 })
require("luasnip.loaders.from_snipmate").lazy_load({ paths = { "./snippets" }, override_priority = 1100 })
require("luasnip.loaders.from_lua").load({ paths = { "./snippets" }, override_priority = 1100 })
-- nvim-cmp setup
local cmp = require("cmp")
local lspkind = require('lspkind')
---@diagnostic disable-next-line: missing-fields
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
    -- { name = "granite_cmp", trigger_characters = {"#"} },
    { name = "luasnip" },
    --    { name = "nvim_lsp_signature_help" },
    { name = "path" },
    { name = "neorg" },
    {
      name = "spell",
      option = {
        keep_all_entries = false,
        enable_in_context = function()
          return require("cmp.config.context").in_treesitter_capture("spell")
        end,
      },
    },
  },
  window = {
    completion = cmp.config.window.bordered({
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
    }),
    documentation = cmp.config.window.bordered({
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
    }),
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text', -- show only symbol annotations
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      show_labelDetails = true, -- show labelDetails in menu. Disabled by default
    })
  }
})

local null_ls = require("null-ls")
null_ls.setup({})
local gotests_source = {}
gotests_source.method = null_ls.methods.CODE_ACTION
gotests_source.filetypes = { "go" }
gotests_source.generator = {
  fn = function(params)
    return {
      {
        title = "Create Test",
        action = function()
          vim.print("Called create test thingy bla")
        end,
      },
    }
  end,
}

null_ls.register(gotests_source)
null_ls.register(null_ls.builtins.diagnostics.revive)
-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

--vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
vim.diagnostic.config({
  float = {
    border = "rounded",
  },
})
