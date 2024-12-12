local actions = require("telescope.actions")

require("telescope").setup({
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
      },
    },
  },
  pickers = {
    builtin = {
      include_extensions = true,
    },
    lsp_implementations = {
      jump_type = "never",
    },
    lsp_definitions = {
      jump_type = "never",
    },
    lsp_type_definitions = {
      jump_type = "never",
    },
    lsp_incoming_calls = {
      jump_type = "never",
    },
    lsp_outgoing_calls = {
      jump_type = "never",
    },
    lsp_references = {
      jump_type = "never",
    },
  },

  extensions = {
    --    lsp_handlers = {
    --      code_action = {
    --        telescope = require('telescope.themes').get_dropdown({}),
    --      },
    --    },
  },
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("luasnip")
--require("telescope").load_extension("make")
--require("telescope").load_extension("gopass")
--require("telescope").load_extension("lazygit")
--require("telescope").load_extension("granite_telescope")
