local actions = require("telescope.actions")


require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-t>"] = actions.file_tab,
        ["<C-s>"] = actions.file_split,
        ["<C-i>"] = actions.file_vsplit,
        ["<C-q>"] = actions.smart_add_to_qflist + actions.open_qflist,
        ["<C-n>"] = actions.cycle_previewers_next,
        ["<C-p>"] = actions.cycle_previewers_prev,
      }
    }
  },
  pickers = {
  },

  extensions = {
    --    lsp_handlers = {
    --      code_action = {
    --        telescope = require('telescope.themes').get_dropdown({}),
    --      },
    --    },
  },
}
require('telescope').load_extension('dap')
require('telescope').load_extension('lsp_handlers')
require('telescope').load_extension('goimpl')
require('telescope').load_extension('luasnip')
require('telescope').load_extension('make')
require('telescope').load_extension('gopass')
