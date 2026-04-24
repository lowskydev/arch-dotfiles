return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("neo-tree").setup({
      close_if_last_window = true,
      popup_border_style = "rounded",
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
      },
      window = {
        position = "float",
      },
    })

    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", opts)            -- toggle file tree
    vim.keymap.set("n", "<leader>ef", ":Neotree reveal<CR>", opts)           -- reveal current file
    vim.keymap.set("n", "<leader>eg", ":Neotree float git_status<CR>", opts) -- git status tree
  end,
}
