return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")

    telescope.setup({
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        border = true,
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        layout_config = {
          horizontal = {
            preview_width = 0.55,
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
        },
      },
    })

    telescope.load_extension("fzf")

    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<leader>ff", builtin.find_files, opts)  -- find files
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, opts)   -- search text in files
    vim.keymap.set("n", "<leader>fb", builtin.buffers, opts)     -- search open buffers
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, opts)   -- search help
    vim.keymap.set("n", "<leader>fr", builtin.oldfiles, opts)    -- recent files
    vim.keymap.set("n", "<leader>fk", builtin.keymaps, opts)     -- search keymaps
  end,
}
