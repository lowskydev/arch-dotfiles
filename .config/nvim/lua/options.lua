-- =============================================================================
-- GENERAL SETTINGS
-- =============================================================================

local opt = vim.opt

-- Line numbers
opt.number = true         -- show line numbers
opt.relativenumber = true -- show relative line numbers (great for vim motions)

-- Indentation
opt.tabstop = 4        -- tab = 4 spaces visually
opt.shiftwidth = 4     -- indent = 4 spaces
opt.expandtab = true   -- use spaces instead of tabs
opt.smartindent = true -- auto indent new lines

-- Search
opt.ignorecase = true -- case insensitive search
opt.smartcase = true  -- unless you type a capital letter
opt.hlsearch = true   -- highlight search results
opt.incsearch = true  -- show matches as you type

-- Appearance
opt.termguicolors = true -- enable 24-bit colors
opt.signcolumn = "yes"   -- always show sign column (prevents layout shifts)
opt.cursorline = true    -- highlight current line
opt.scrolloff = 8        -- keep 8 lines above/below cursor
opt.sidescrolloff = 8    -- keep 8 columns left/right of cursor
opt.wrap = true          -- wrap overflowing text
opt.colorcolumn = ""     -- no vertical line

-- Splits
opt.splitbelow = true -- new horizontal splits go below
opt.splitright = true -- new vertical splits go right

-- Files
opt.swapfile = false -- don't create swap files
opt.backup = true    -- create backup files
opt.backupdir = vim.fn.expand("~/.config/nvim/backup//")
opt.undofile = true  -- persistent undo history across sessions
opt.undodir = vim.fn.expand("~/.config/nvim/undodir")

-- Clipboard
opt.clipboard = "unnamedplus" -- use system clipboard

-- Performance
opt.updatetime = 50  -- faster completion and diagnostics
opt.timeoutlen = 300 -- key sequence timeout

-- UI
opt.showmode = false -- don't show -- INSERT -- (statusline handles this)
opt.pumheight = 10   -- max items in completion popup
opt.conceallevel = 0 -- show all characters (important for markdown)
