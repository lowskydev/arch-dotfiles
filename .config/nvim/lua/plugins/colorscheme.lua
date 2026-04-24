return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- load before everything else
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = true, -- let kitty's opacity show through
      integrations = {
        cmp = true,
        gitsigns = true,
        telescope = true,
        treesitter = true,
      },
    })
    vim.cmd("colorscheme catppuccin")
  end,
}
