require("granite").setup({
  knowledge_base_path = "~/Documents/notevault",
  templates = {
    {
      name = "template 1",
      parameters = {"tags", "something"}
    },
    {
      name = "template 2",
      parameters = {"wurst", "bla"}
    },
    {
      name = "template 3",
    },
  }
})
