return {
  -- Paste images from clipboard into markdown
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      default = {
        dir_path = "pictures-md",        -- folder relative to the current file
        relative_to_current_file = true, -- always relative to file, not cwd
        prompt_for_file_name = true,     -- ask for name before saving
      },
    },
    keys = {
      { "<leader>pi", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
    },
  },

  -- Render images inline (kitty backend)
  {
    "3rd/image.nvim",
    lazy = false,
    config = function()
      require("image").setup({
        backend = "kitty",
        processor = "magick_cli",
        integrations = {
          markdown = {
            enabled = true,
            only_render_image_at_cursor = false,
            filetypes = { "markdown" },
          },
          html = { enabled = false },
          css = { enabled = false },
        },
        max_height_window_percentage = 50,
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
      })
    end,
  },
}
