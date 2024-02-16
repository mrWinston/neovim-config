local utils = require("utils")

local gs = require("gitsigns.actions")

return {
  name = "git",
  b = {
    name = "Branches",
    c = {
      function()
        require("telescope.builtin").git_branches()
      end,
      "Checkout",
    },
    n = { utils.createGitBranch, "New Branch" },
    d = { utils.gitDiffBranch, "Diff" },
  },
  c = { ":Git commit<cr>", "Commit" },
  s = { ":Git<cr>", "Status" },
  p = { ":Git pull<cr>", "Pull" },
  P = { ":Git push<cr>", "Push" },
  l = { ":LazyGit<cr>", "Lazygit" },
  o = { ":!gh browse %:.<cr>", "Open in Github" },
  h = {
    name = "+Github",
    c = {
      name = "+Commits",
      c = { "<cmd>GHCloseCommit<cr>", "Close" },
      e = { "<cmd>GHExpandCommit<cr>", "Expand" },
      o = { "<cmd>GHOpenToCommit<cr>", "Open To" },
      p = { "<cmd>GHPopOutCommit<cr>", "Pop Out" },
      z = { "<cmd>GHCollapseCommit<cr>", "Collapse" },
    },
    i = {
      name = "+Issues",
      p = { "<cmd>GHPreviewIssue<cr>", "Preview" },
    },
    l = {
      name = "+Litee",
      t = { "<cmd>LTPanel<cr>", "Toggle Panel" },
    },
    r = {
      name = "+Review",
      b = { "<cmd>GHStartReview<cr>", "Begin" },
      c = { "<cmd>GHCloseReview<cr>", "Close" },
      d = { "<cmd>GHDeleteReview<cr>", "Delete" },
      e = { "<cmd>GHExpandReview<cr>", "Expand" },
      s = { "<cmd>GHSubmitReview<cr>", "Submit" },
      z = { "<cmd>GHCollapseReview<cr>", "Collapse" },
    },
    p = {
      name = "+Pull Request",
      c = { "<cmd>GHClosePR<cr>", "Close" },
      d = { "<cmd>GHPRDetails<cr>", "Details" },
      e = { "<cmd>GHExpandPR<cr>", "Expand" },
      o = { "<cmd>GHOpenPR<cr>", "Open" },
      p = { "<cmd>GHPopOutPR<cr>", "PopOut" },
      r = { "<cmd>GHRefreshPR<cr>", "Refresh" },
      t = { "<cmd>GHOpenToPR<cr>", "Open To" },
      z = { "<cmd>GHCollapsePR<cr>", "Collapse" },
    },
    t = {
      name = "+Threads",
      c = { "<cmd>GHCreateThread<cr>", "Create" },
      n = { "<cmd>GHNextThread<cr>", "Next" },
      t = { "<cmd>GHToggleThread<cr>", "Toggle" },
    },
  },
  G = {
    name = "gists",
    l = { ":GistList<cr>", "List Gists" },
    c = { ":GistCreate<cr>", "Create Gists" },
  },
  g = {
    name = "gitSigns",
    H = { gs.select_hunk, "Select Hunk"},
    n = { gs.next_hunk, "Next Hunk" },
    p = { gs.prev_hunk, "Prev Hunk" },
    i = { gs.preview_hunk_inline, "Inspect Hunk (inline)"},
    I = { gs.preview_hunk, "Inspect Hunk"},
    b = { gs.blame_line, "Blame Line"},
    s = { gs.stage_hunk, "Stage Hunk"},
    S = { gs.undo_stage_hunk, "Undo Stage Hunk"},
    B = { gs.stage_buffer, "stage buffer"},
    t = {
      name = "Toggle",
      b = { gs.toggle_current_line_blame, "Toggle line blame" },
      l = { gs.toggle_linehl, "Toggle line higlighting" },
      n = { gs.toggle_numhl, "Toggle num higlighting" },
      s = { gs.toggle_signs, "Toggle signs" },
      w = { gs.toggle_word_diff, "Toggle word diff" },
      d = { gs.toggle_deleted, "Toggle Deleted" },
    },
  },
}
