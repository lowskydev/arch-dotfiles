return {
  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = { char = "│" },
        scope = { enabled = false },
        exclude = {
          filetypes = {
            "help", "dashboard", "lazy", "mason",
            "NvimTree", "toggleterm",
          },
        },
      })
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")

      autopairs.setup({
        check_ts = true,
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
        },
      })

      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Commenting (gcc, gc+motion, gcb)
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("Comment").setup({
        padding = true,
        sticky = true,
      })
    end,
  },

  -- Undo tree
  {
    "jiaoshijie/undotree",
    keys = {
      { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "Toggle undo tree" },
    },
    opts = {
      float_diff = true,
      layout = "left_bottom",
      position = "left",
      window = {
        border = "rounded",
      },
      parser = "compact",
    },
    config = function(_, opts)
      require("undotree").setup(opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "undotree",
        callback = function(args)
          vim.keymap.set("n", "<Esc>", "<cmd>lua require('undotree').toggle()<cr>",
            { buffer = args.buf, silent = true })
        end,
      })
    end,
  },

  -- Mini.ai and Mini.surround
  {
    "echasnovski/mini.nvim",
    config = function()
      -- Extended text objects (va), yinq, ci', etc.)
      require("mini.ai").setup({ n_lines = 500 })

      -- Surround actions
      -- saiw) - add () around word
      -- sd'   - delete surrounding '
      -- sr)'  - replace ) with '
      require("mini.surround").setup()
    end,
  },

  -- Scroll past EOF
  {
    "Aasim-A/scrollEOF.nvim",
    event = { "CursorMoved", "WinScrolled" },
    opts = {
      insert_mode = true,
    },
  },

  -- Markdown rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = "markdown",
    opts = {},
  },
}
