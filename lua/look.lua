local utils = require("utils")

vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { default = true, link = "comment" })
-- set theme based on kitty theme
local kittyToNvim = {
  ["GitHub Light"] = "github_light",
  ["GitHub Dark"] = "github_dark",
  ["Catppuccin-Mocha"] = "catppuccin-mocha",
  ["Catppuccin-Latte"] = "catppuccin-latte",
  ["Everblush"] = "everblush",
  ["Tokyo Night"] = "tokyonight-night",
  ["Tokyo Night Day"] = "tokyonight-day",
}
utils.set_table_default(kittyToNvim, "catppuccin-mocha")
local obj = vim
  .system({ "zsh", "-c", 'cat ~/.config/kitty/current-theme.conf | grep "## name" | cut -d ":" -f 2' }, {
    text = true,
  })
  :wait()
local theme_name = string.gsub(obj.stdout, "^%s*(.-)%s*$", "%1")
vim.cmd("colorscheme " .. kittyToNvim[theme_name])

-- set fold colors to something more tolerable

-- hi! link Folded Pmenu   
-- hi! link UfoFoldedEllipsis Comment

vim.api.nvim_set_hl(0, "Folded", {
  link = "Pmenu",
  force = true,
})
vim.api.nvim_set_hl(0, "UfoFoldedEllipsis", {
  link = "Comment",
  force = true,
})

-- vim.api.nvim_set_hl(0, "NotifyBackground", {
--   bg = "#141b1e",
--   force = true,
-- })

-- vim.api.nvim_set_hl(0, 'Comment', { italic=true })
