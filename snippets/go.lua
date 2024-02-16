local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

return {
  postfix(".len", {
    f(function(_, parent)
      return "len(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),
  postfix(".logi", {
    f(function(_, parent)
      return 'log.Infof("' .. parent.snippet.env.POSTFIX_MATCH .. ': %+v", ' .. parent.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),
  postfix(".loge", {
    f(function(_, parent)
      return 'log.Errorf("' .. parent.snippet.env.POSTFIX_MATCH .. ': %+v", ' .. parent.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),
  postfix(".logd", {
    f(function(_, parent)
      return 'log.Debugf("' .. parent.snippet.env.POSTFIX_MATCH .. ': %+v", ' .. parent.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),
  s("funcl", {
    f(function()
      local node = vim.treesitter.get_node()
      if not node then
        return
      end
      while node:type() ~= "function_declaration" do
        node = node:parent()
        if not node then
          return
        end
      end
      local query = vim.treesitter.query.parse("go", "(function_declaration parameters: (parameter_list (parameter_declaration name: (identifier) @name)))")

      local params = {} 
	    for pattern, match, metadata in query:iter_matches(node, 0, 0, -1, {}) do
        for id, pr in pairs(match) do
          table.insert(params, vim.treesitter.get_node_text(pr, 0))
        end
      end
      local out = 'log.Infof("'
      for idx, pa in ipairs(params) do
        out = out .. pa .. '=%s, '
      end
      out = out .. '"'
      for idx, pa in ipairs(params) do
        out = out ..', ' .. pa 
      end
      out = out .. ')'

      return out
    end),
  }),
}
