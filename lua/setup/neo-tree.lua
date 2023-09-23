require("neo-tree").setup({
  close_if_last_window = true,
  filesystem = {
    follow_current_file = {
      enabled = true,               -- This will find and focus the file in the active buffer every time
      leave_dirs_open = false,       -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
    },
    window = {
      mappings = {
        ["s"] = "split_with_window_picker",
        ["v"] = "vsplit_with_window_picker",
        ["<bs>"] = "close_node",
      }
    },
  }
})
