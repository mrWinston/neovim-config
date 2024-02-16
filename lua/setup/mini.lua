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

require("mini.comment").setup({
})
