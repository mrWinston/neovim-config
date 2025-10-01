-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

-- require("telescope").load_extension("lsp_handlers")
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
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}
capabilities.workspace = {
  didChangeWatchedFiles = {
    dynamicRegistration  = true,
  },
}

local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      completion = {
        callSnippet = "Replace",
      },
    },
  },
})


local bicep_lsp_bin = "/home/maschulz/code/github/bicep-langserver/Bicep.LangServer.dll"
vim.lsp.config('bicep', {
    cmd = { "dotnet", bicep_lsp_bin };
})
vim.lsp.enable('bicep')


vim.lsp.enable("azure_pipelines_ls")
vim.lsp.config("azure_pipelines_ls", {
  root_markers = { "azure-pipelines.yml", ".pipelines/" },
  settings = {
    yaml = {
      schemas = {
        ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
          "/azure-pipeline*.y*l",
          "Azure-Pipelines/**/*.y*l",
          "Pipelines/*.y*l",
          ".pipelines/*.y*l",
          ".pipelines/**/*.y*l",
        },
      },
    },
  },
})

vim.lsp.enable('jsonls')

-- yarn global add @volar/vue-language-server
lspconfig.volar.setup({
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
})

--lspconfig.harper_ls.setup({})

-- lspconfig.denols.setup({
--   settings = {
--     deno = {
--       enable = true,
--       unstable = { "sloppy-imports" },
--       suggest = {
--         imports = {
--           hosts = {
--             ["https://deno.land"] = true,
--           },
--         },
--       },
--     },
--   },
-- })

local simpleLs = {
  -- "gopls",
  "bashls",
  -- "tsserver", -- yarn global add typescript typescript-language-server
  "eslint", -- yarn global add vscode-langservers-extracted
  --  "jedi_language_server",
  "pylsp",
  "terraformls", --asdf plugin-add terraform-ls && asdf install terraform-ls latest && asdf global terraform-ls latest
  "marksman", -- download from https://github.com/artempyanykh/marksman/releases
  -- "markdown_oxide",
  --  "remark_ls",
  "yamlls",
  "ansiblels",
  "ts_ls",
}

for _, value in ipairs(simpleLs) do
  lspconfig[value].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

vim.lsp.enable("gopls")
-- vim.lsp.config('gopls', {
--   cmd = {'podman-compose', 'exec', '-T', 'aro-dev-env', 'gopls', '-vv', '-logfile=pls.log', 'serve'},
-- })

local configs = require("lspconfig/configs")

-- if not configs.golangcilsp then
--   configs.golangcilsp = {
--     default_config = {
--       cmd = { "golangci-lint-langserver", "-debug" },
--       root_dir = lspconfig.util.root_pattern("go.mod", ".git"),
--       init_options = {
--         command = {
--           "golangci-lint",
--           "run",
--           "--fast",
--           "--out-format",
--           "json",
--           "--issues-exit-code=1",
--         },
--       },
--     },
--   }
-- end

-- lspconfig.golangci_lint_ls.setup({
--   filetypes = { "go", "gomod" },
--   root_dir = lspconfig.util.root_pattern("go.mod", ".git"),
-- })

local luasnip = require("luasnip")
luasnip.log.set_loglevel("info")
require("luasnip.loaders.from_vscode").lazy_load({ override_priority = 1000 })
require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets/vscode" }, override_priority = 1100 })
require("luasnip.loaders.from_snipmate").lazy_load({ paths = { "./snippets" }, override_priority = 1100 })
require("luasnip.loaders.from_lua").load({ paths = { "./snippets" }, override_priority = 1100 })
-- nvim-cmp setup
local cmp = require("cmp")
local lspkind = require("lspkind")
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
    {
      name = "nvim_lsp",
      option = {
        markdown_oxide = {
          keyword_pattern = [[\(\k\| \|\/\|#\)\+]],
        },
      },
    },
    -- { name = "granite_cmp", trigger_characters = {"#"} },
    { name = "luasnip" },
    { name = "jq_cmp" },
    --    { name = "nvim_lsp_signature_help" },
    { name = "path" },
    { name = "neorg" },
    { name = "lazydev", group_index = 0 },
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
      mode = "symbol_text", -- show only symbol annotations
      ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      show_labelDetails = true, -- show labelDetails in menu. Disabled by default
    }),
  },
})

local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.code_actions.gomodifytags,
    null_ls.builtins.code_actions.impl,
    --    null_ls.builtins.diagnostics.golangci_lint,
  },
})
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
-- null_ls.register(null_ls.builtins.diagnostics.revive.with({
--   args = { "-exclude", "./vendor/...", "-formatter", "json", "./..." },
-- }))
-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

--vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
vim.diagnostic.config({
  float = {
    border = "rounded",
  },
})
