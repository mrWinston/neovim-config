require("which-key").setup({
  -- win = {
  --   border = "single",
  --   winblend = 20,
  --   position = "bottom",
  -- },
  layout = {
    align = "center",
  },
  triggers = {
    { "<auto>", mode = "nxso" },
    { "<leader>", mode = { "n", "v" } },
  },
})
