local animate = require("mini.animate")
local indentscope = require("mini.indentscope")
local animationDuration = animate.gen_timing.linear({ duration = 100, unit = "total" })

local indentscopeAnimation = indentscope.gen_animation.quadratic({ easing = "out", duration = 100, unit = "total" })
-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-indentscope.md#default-config
require("mini.indentscope").setup({
  draw = {
    animation = indentscopeAnimation,
  },
})

-- if not vim.g.neovide then
--   -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-animate.md#default-config
--  require("mini.animate").setup({
--    cursor = {
--      timing = animationDuration,
--      path = animate.gen_path.angle(),
--    },
--    scroll = {
--      timing = animationDuration,
--    },
--    resize = {
--      timing = animationDuration,
--    },
--    open = {
--      timing = animationDuration,
--    },
--    close = {
--      timing = animationDuration,
--    },
--  })
-- end
-- see https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-ai.md
require("mini.ai").setup({})
require("mini.align").setup({})

require("mini.files").setup({})
require("mini.surround").setup({})

require("mini.comment").setup({})

require("mini.pairs").setup({
  mappings = {
    ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
    ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
    ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

    [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
    ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
    ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

    ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^%a\\].", register = { cr = false } },
    ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
    ["`"] = { action = "open", pair = "``", neigh_pattern = "[^%a\\].", register = { cr = false } },
  },
})

require("mini.notify").setup({})

vim.notify = require("mini.notify").make_notify({
  ERROR = { duration = 5000, hl_group = "DiagnosticError" },
  WARN = { duration = 5000, hl_group = "DiagnosticWarn" },
  INFO = { duration = 5000, hl_group = "DiagnosticInfo" },
  DEBUG = { duration = 0, hl_group = "DiagnosticHint" },
  TRACE = { duration = 0, hl_group = "DiagnosticOk" },
  OFF = { duration = 0, hl_group = "MiniNotifyNormal" },
})

require("mini.jump2d").setup({
  view = {
    -- Whether to dim lines with at least one jump spot
    dim = true,

    -- How many steps ahead to show. Set to big number to show all steps.
    n_steps_ahead = 2,
  },
})
