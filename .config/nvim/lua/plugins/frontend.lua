return {
  "brianhuster/live-preview.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  cmd = { "LivePreview" },
  keys = {
    { "<leader>lp", "<cmd>LivePreview start<cr>", desc = "Start live preview" },
    { "<leader>ls", "<cmd>LivePreview stop<cr>",  desc = "Stop live preview" },
  },
  config = function()
    require("livepreview.config").set({
      browser = "vivaldi", -- your browser
      port = 8080,
      dynamic_root = true,
    })
  end,
}
