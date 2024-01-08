require("neorg").setup({
  load = {
    ["core.defaults"] = {}, -- Loads default behaviour
    ["core.completion"] = {
      config = {
        engine = "nvim-cmp",
      },
    },
    ["core.concealer"] = {}, -- Adds pretty icons to your documents
    ["core.integrations.telescope"] = {},
    ["external.exec"] = {},
    ["core.dirman"] = { -- Manages Neorg workspaces
      config = {
        workspaces = {
          notes = "~/Documents/neorg/",
        },
      },
    },
  },
})
