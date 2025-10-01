local presets = require("markview.presets")

require("markview").setup({
  preview = {
    modes = { "n", "i", "no", "c" },
    hybrid_modes = { "i" },
  },
  checkboxes = presets.checkboxes.nerd,
  markdown = {
    typst = {
      url_links = {
        enabled = false,
      },
    },
    list_items = {
      indent_size = 2,
      shift_width = 4,
      marker_minus = {
        add_padding = false,
      },
      marker_plus = {
        add_padding = false,
      },
      marker_star = {
        add_padding = false,
      },
      marker_dot = {
        add_padding = false,
      },
      marker_parenthesis = {
        add_padding = false,
      },
    },
  },
})
