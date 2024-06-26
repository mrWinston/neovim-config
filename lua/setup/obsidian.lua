require("obsidian").setup({
  dir = "~/Documents/notevault",
  disable_frontmatter = true,
  notes_subdir = "notes",
  daily_notes = {
    folder = "dailies",
  },
  completion = {
    nvim_cmp = true, -- if using nvim-cmp, otherwise set to false
  },

  templates = {
    subdir = "templates",
    date_format = "%Y-%m-%d-%a",
    time_format = "%H:%M",
  },

  note_id_func = function(title)
    -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
    local suffix = ""
    if title ~= nil then
      -- If title is given, transform it into valid file name.
      suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
    else
      -- If title is nil, just add 4 random uppercase letters to the suffix.
      for _ = 1, 4 do
        suffix = suffix .. string.char(math.random(65, 90))
      end
    end
    return tostring(os.time()) .. "-" .. suffix
  end,
})
