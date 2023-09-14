require("conform").setup({
  formatters_by_ft = {
    python = { "black" },
    lua = { "stylua" },
    sh = { "shfmt", "shellharden" },
    yaml = { "yamlfix" },
    terraform = { "terraform_fmt" },
    json = { "prettier" },
    javascript = { "prettier" },
    go = { "gofmt", "golines" },
  },
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*",
  callback = function(args)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[args.buf].disable_autoformat then
      return
    end
    -- Disable autoformat for files in a certain path
    local bufname = vim.api.nvim_buf_get_name(args.buf)
    if bufname:match("/node_modules/") then
      return
    end
    require("conform").format({ timeout_ms = 500, lsp_fallback = true, bufnr = args.buf })
  end,
})

local shfmt = require("conform.formatters.shfmt")
table.insert(shfmt.args, "-i")
table.insert(shfmt.args, "4")
