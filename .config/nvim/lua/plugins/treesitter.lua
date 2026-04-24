return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })
    require("nvim-treesitter").install({
      "c", "cpp", "python", "rust", "java",
      "javascript", "typescript", "tsx",
      "bash", "markdown", "markdown_inline",
      "json", "toml", "yaml",
      "lua", "go", "dockerfile",
      "html", "css",
      "vim", "vimdoc",
    }):wait(300000)
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local ok = pcall(vim.treesitter.start, args.buf)
        if not ok then return end
      end,
    })
  end,
}
