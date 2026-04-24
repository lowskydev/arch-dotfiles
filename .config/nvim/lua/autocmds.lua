-- =============================================================================
-- AUTOCOMMANDS
-- =============================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  group = augroup("TrimWhitespace", { clear = true }),
  pattern = "*",
  command = "%s/\\s\\+$//e",
})

-- Highlight yanked text briefly (visual feedback when you yank)
autocmd("TextYankPost", {
  group = augroup("YankHighlight", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- Set 2-space indentation for specific file types
autocmd("FileType", {
  group = augroup("TwoSpaceIndent", { clear = true }),
  pattern = { "lua", "javascript", "typescript", "json", "html", "css", "yaml", "toml", "markdown" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- Clear search highlights when moving cursor
autocmd("CursorMoved", {
  group = augroup("ClearSearch", { clear = true }),
  callback = function()
    if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
      vim.schedule(function()
        vim.cmd("nohlsearch")
      end)
    end
  end,
})

-- Format on save
autocmd("BufWritePre", {
  group = augroup("FormatOnSave", { clear = true }),
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Soft wrap for prose files (no hard newlines, just visual wrap)
autocmd("FileType", {
  group = augroup("ProseWrap", { clear = true }),
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true   -- wrap at word boundaries
    vim.opt_local.breakindent = true -- wrapped lines preserve indentation
    vim.keymap.set("n", "j", "gj", { buffer = true })
    vim.keymap.set("n", "k", "gk", { buffer = true })
    vim.keymap.set("n", "0", "g0", { buffer = true })
    vim.keymap.set("n", "$", "g$", { buffer = true })
  end,
})

-- Spell check in prose files
-- z= to see suggestions, zg adds to dictionary, ]s/[s to jump between errors
autocmd("FileType", {
  group = augroup("SpellCheck", { clear = true }),
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"
  end,
})

-- Don't auto-insert comment leader on new line
autocmd("FileType", {
  group = augroup("NoAutoComment", { clear = true }),
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})

-- Markdown keymaps (only in .md files)
autocmd("FileType", {
  group = augroup("MarkdownKeymaps", { clear = true }),
  pattern = "markdown",
  callback = function()
    local opts = { noremap = true, silent = true, buffer = true }

    -- Toggle render-markdown rendering on/off
    vim.keymap.set("n", "<leader>mt", ":RenderMarkdown toggle<CR>", opts)

    -- Inline formatting — visual mode (wrap selected text)
    vim.keymap.set("v", "<leader>mb", "c**<C-r>\"**<Esc>", opts) -- **bold**
    vim.keymap.set("v", "<leader>mi", "c*<C-r>\"*<Esc>", opts)   -- *italic*
    vim.keymap.set("v", "<leader>mc", "c`<C-r>\"`<Esc>", opts)   -- `code`

    -- Inline formatting — normal mode (wrap word under cursor)
    vim.keymap.set("n", "<leader>mb", "ciw**<C-r>\"**<Esc>", opts) -- **bold**
    vim.keymap.set("n", "<leader>mi", "ciw*<C-r>\"*<Esc>", opts)   -- *italic*
    vim.keymap.set("n", "<leader>mc", "ciw`<C-r>\"`<Esc>", opts)   -- `code`

    -- Headings — normal mode (prepend # to current line)
    vim.keymap.set("n", "<leader>m1", "0i# <Esc>", opts)
    vim.keymap.set("n", "<leader>m2", "0i## <Esc>", opts)
    vim.keymap.set("n", "<leader>m3", "0i### <Esc>", opts)
    vim.keymap.set("n", "<leader>m4", "0i#### <Esc>", opts)
    vim.keymap.set("n", "<leader>m5", "0i##### <Esc>", opts)
    vim.keymap.set("n", "<leader>m6", "0i###### <Esc>", opts)
  end,
})
