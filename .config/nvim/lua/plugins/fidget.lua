return {
  "j-hui/fidget.nvim",
  opts = {
    progress = {
      display = {
        done_icon = "✔",
        progress_icon = { "dots" },
      },
    },
    notification = {
      window = {
        winblend = 0, -- fully opaque to match your transparent kitty setup
        border = "rounded",
      },
    },
  },
}
