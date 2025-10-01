vim.api.nvim_set_hl(0, "@markup.link.url", { link = "@markup.link" })
vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { default = true, link = "comment" })

vim.cmd("colorscheme base16-tomorrow-night")

if vim.g.neovide then
  vim.o.guifont = "BlexMono Nerd Font:h14"
  vim.g.neovide_text_gamma = -0.2
  vim.g.neovide_opacity = 1.0
  vim.g.neovide_window_blurred = true
  vim.g.neovide_fullscreen = false
  vim.g.neovide_remember_window_size = false
  vim.g.neovide_cursor_trail_size = 0.4
  vim.g.neovide_cursor_animation_length = 0.06
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_scale_factor = 1.0
end

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

