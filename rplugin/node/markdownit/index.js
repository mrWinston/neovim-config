var md = require('markdown-it')();

loaded = [] instanceof Array;

// Hack to get global object
const global = Function('return this')();

module.exports = plugin => {
  const nvim = plugin.nvim;

  async function func() {
    lines = await nvim.buffer.getLines()
    return md.parse(lines.join("\n"), {})
  }

  plugin.registerFunction('Func', func, { sync: true });
};

module.exports.default = module.exports;
