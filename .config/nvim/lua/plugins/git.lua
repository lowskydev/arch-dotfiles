return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup({
      signs = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
        untracked    = { text = "┆" },
      },
      current_line_blame = false,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local opts = { noremap = true, silent = true, buffer = bufnr }
        local keymap = vim.keymap.set

        keymap("n", "]h", gs.next_hunk, opts)
        keymap("n", "[h", gs.prev_hunk, opts)
        keymap("n", "<leader>hs", gs.stage_hunk, opts)
        keymap("n", "<leader>hr", gs.reset_hunk, opts)
        keymap("n", "<leader>hp", gs.preview_hunk, opts)
        keymap("n", "<leader>gb", gs.toggle_current_line_blame, opts)
      end,
    })
  end,
}
