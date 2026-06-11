return {
  "sindrets/diffview.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewFileHistory",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
  },
  config = function()
    require("diffview").setup({
      hooks = {
        diff_buf_read = function()
          -- Disable wrap and list in diff buffers
          vim.opt_local.wrap = false
          vim.opt_local.list = false
        end,
      },
    })

    local opts = { noremap = true, silent = true }

    -- Open diff against current index (unstaged changes)
    vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", opts)

    -- Open file history for the whole repo
    vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory<CR>", opts)

    -- Open file history for the current file only
    vim.keymap.set("n", "<leader>gH", ":DiffviewFileHistory %<CR>", opts)

    -- Close diffview
    vim.keymap.set("n", "<leader>gx", ":DiffviewClose<CR>", opts)
  end,
}
