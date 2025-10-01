require("neo-tree").setup({
  sources = {
    "filesystem",
    "buffers",
    "git_status",
    "document_symbols",
    "tools.neotree-sources.taskwarrior"
  },
  close_if_last_window = true,
  filesystem = {
    follow_current_file = {
      enabled = true, -- This will find and focus the file in the active buffer every time
      leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
    },

    filtered_items = {
      visible = true,
    },
    window = {
      mappings = {
        ["s"] = "split_with_window_picker",
        ["v"] = "vsplit_with_window_picker",
        ["<bs>"] = "close_node",
      },
    },
    bind_to_cwd = true,
    cwd_target = {
      sidebar = "none",
    },
  },
  buffers = {
    bind_to_cwd = true,
  },
  document_symbols = {
    follow_cursor = true,
    window = {
      mappings = {
      },
    }
  },
})
