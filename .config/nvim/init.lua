-- =============================================================================
-- PLUGIN MANAGER (lazy.nvim)
-- =============================================================================

-- Bootstrap lazy.nvim - downloads it automatically if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Leader key must be set before lazy loads plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy").setup({

    -- ==========================================================================
    -- COLORSCHEME
    -- ==========================================================================
    {
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
    },

    -- ==========================================================================
    -- SYNTAX HIGHLIGHTING (treesitter)
    -- ==========================================================================
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup({
                install_dir = vim.fn.stdpath("data") .. "/site",
            })
            -- Install parsers for all your languages
            require("nvim-treesitter").install({
                "c", "cpp", "python", "rust", "java",
                "javascript", "typescript", "tsx",
                "bash", "markdown", "markdown_inline",
                "json", "toml", "yaml",
                "lua", "go", "dockerfile",
                "html", "css",
                "vim", "vimdoc",
            }):wait(300000)
            -- Enable highlighting for all filetypes safely
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local ok = pcall(vim.treesitter.start, args.buf)
                    if not ok then return end
                end,
            })
        end,
    },

    -- ==========================================================================
    -- FUZZY FINDER (telescope)
    -- ==========================================================================
    {
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
            vim.keymap.set("n", "<leader>ff", builtin.find_files, opts)   -- find files
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, opts)    -- search text in files
            vim.keymap.set("n", "<leader>fb", builtin.buffers, opts)      -- search open buffers
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, opts)    -- search help
            vim.keymap.set("n", "<leader>fr", builtin.oldfiles, opts)     -- recent files
            vim.keymap.set("n", "<leader>fk", builtin.keymaps, opts)      -- search keymaps
        end,
    },

    -- ==========================================================================
    -- FILE TREE (nvim-tree)
    -- ==========================================================================
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            -- disable netrw in favor of nvim-tree
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            require("nvim-tree").setup({
                view = {
                    width = 35,
                    side = "left",
                },
                renderer = {
                    group_empty = true,
                    highlight_git = true,
                    icons = {
                        show = {
                            file = true,
                            folder = true,
                            folder_arrow = true,
                            git = true,
                        },
                    },
                },
                filters = {
                    dotfiles = false,
                },
                git = {
                    enable = true,
                    ignore = false,
                },
                actions = {
                    open_file = {
                        quit_on_open = false,
                    },
                },
            })

            local opts = { noremap = true, silent = true }
            vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", opts)    -- toggle file tree
            vim.keymap.set("n", "<leader>ef", ":NvimTreeFindFile<CR>", opts) -- find current file in tree
        end,
    },

    -- ==========================================================================
    -- STATUSLINE (lualine)
    -- ==========================================================================
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "catppuccin-mocha",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    globalstatus = true, -- single statusline for all splits
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { { "filename", path = 1 } }, -- relative path
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },

    -- ==========================================================================
    -- LSP + COMPLETION
    -- ==========================================================================

    -- Mason: installs and manages LSP servers
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    border = "rounded",
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
        end,
    },

    -- Bridges mason and lspconfig
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "clangd",        -- C/C++
                    "pyright",       -- Python
                    "rust_analyzer", -- Rust
                    "jdtls",         -- Java
                    "ts_ls",         -- TypeScript/JavaScript
                    "lua_ls",        -- Lua
                    "gopls",         -- Go
                    "bashls",        -- Bash
                    "jsonls",        -- JSON
                    "taplo",         -- TOML
                    "yamlls",        -- YAML
                    "dockerls",      -- Dockerfile
                    "html",          -- HTML
                    "cssls",         -- CSS
                },
                automatic_installation = true,
            })

            -- Shared keymaps applied when any LSP attaches to a buffer
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
                callback = function(args)
                    local opts = { noremap = true, silent = true, buffer = args.buf }
                    local keymap = vim.keymap.set
                    keymap("n", "gd", vim.lsp.buf.definition, opts)          -- go to definition
                    keymap("n", "gD", vim.lsp.buf.declaration, opts)         -- go to declaration
                    keymap("n", "gr", vim.lsp.buf.references, opts)          -- find references
                    keymap("n", "gi", vim.lsp.buf.implementation, opts)      -- go to implementation
                    keymap("n", "K", vim.lsp.buf.hover, opts)                -- hover documentation
                    keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)      -- rename symbol
                    keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- code actions
                    keymap("n", "<leader>d", vim.diagnostic.open_float, opts)-- show diagnostic
                    keymap("n", "[d", vim.diagnostic.goto_prev, opts)        -- previous diagnostic
                    keymap("n", "]d", vim.diagnostic.goto_next, opts)        -- next diagnostic
                end,
            })

            -- Capabilities enhanced with cmp
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Use new vim.lsp.config API for all servers
            local servers = {
                "clangd", "pyright", "rust_analyzer",
                "ts_ls", "gopls",
                "bashls", "jsonls", "taplo",
                "yamlls", "dockerls", "html", "cssls",
            }

            for _, server in ipairs(servers) do
                vim.lsp.config(server, {
                    capabilities = capabilities,
                })
            end

            -- Lua LSP special config (knows about nvim globals)
            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" }, -- don't warn about vim global
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                    },
                },
            })
        end,
    },

    -- Completion engine
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",         -- LSP completions
            "hrsh7th/cmp-buffer",            -- buffer word completions
            "hrsh7th/cmp-path",              -- file path completions
            "L3MON4D3/LuaSnip",              -- snippet engine
            "saadparwaiz1/cmp_luasnip",      -- snippet completions
            "rafamadriz/friendly-snippets",  -- collection of snippets
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            -- Load friendly-snippets
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    -- Tab to select next item
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    -- Shift+Tab to select previous item
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    -- Enter confirms selection only if item is explicitly selected
                    ["<CR>"] = cmp.mapping({
                        i = function(fallback)
                            if cmp.visible() and cmp.get_active_entry() then
                                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                            else
                                fallback() -- just insert newline
                            end
                        end,
                    }),

                    -- Ctrl+Space to manually trigger completion
                    ["<C-Space>"] = cmp.mapping.complete(),

                    -- Ctrl+e to close completion
                    ["<C-e>"] = cmp.mapping.abort(),

                    -- Scroll docs
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                }),

                sources = cmp.config.sources({
                    { name = "nvim_lsp" }, -- LSP completions (highest priority)
                    { name = "luasnip" },  -- snippets
                    { name = "buffer" },   -- words from current buffer
                    { name = "path" },     -- file paths
                }),

                -- No auto-select
                preselect = cmp.PreselectMode.None,

                -- Appearance
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },

                formatting = {
                    format = function(entry, vim_item)
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip  = "[Snip]",
                            buffer   = "[Buf]",
                            path     = "[Path]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
            })
        end,
    },
    -- ==========================================================================
    -- GIT SIGNS
    -- ==========================================================================
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = "│" },
                    change       = { text = "│" },
                    delete       = { text = "_" },
                    topdelete    = { text = "‾" },
                    changedelete = { text = "~" },
                    untracked    = { text = "┆" },
                },
                current_line_blame = false, -- toggle with <leader>gb
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns
                    local opts = { noremap = true, silent = true, buffer = bufnr }
                    local keymap = vim.keymap.set

                    keymap("n", "]h", gs.next_hunk, opts)       -- next git hunk
                    keymap("n", "[h", gs.prev_hunk, opts)       -- previous git hunk
                    keymap("n", "<leader>hs", gs.stage_hunk, opts)     -- stage hunk
                    keymap("n", "<leader>hr", gs.reset_hunk, opts)     -- reset hunk
                    keymap("n", "<leader>hp", gs.preview_hunk, opts)   -- preview hunk
                    keymap("n", "<leader>gb", gs.toggle_current_line_blame, opts) -- toggle blame
                end,
            })
        end,
    },

    -- ==========================================================================
    -- INDENT GUIDES
    -- ==========================================================================
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

    -- ==========================================================================
    -- AUTO PAIRS
    -- ==========================================================================
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            local autopairs = require("nvim-autopairs")
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp = require("cmp")

            autopairs.setup({
                check_ts = true,        -- use treesitter to check for pairs
                ts_config = {
                    lua = { "string" }, -- don't add pairs in lua strings
                    javascript = { "template_string" },
                },
            })

            -- Make autopairs work with cmp
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },

    -- ==========================================================================
    -- COMMENTING
    -- ==========================================================================
    {
        "numToStr/Comment.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("Comment").setup({
                -- gcc to comment current line
                -- gc + motion to comment a range
                -- gcb to block comment
                padding = true,   -- add space after comment delimiter
                sticky = true,    -- cursor stays in place
            })
        end,
    },

}, {
    ui = {
        border = "rounded",
    },
})

-- =============================================================================
-- GENERAL SETTINGS
-- =============================================================================

local opt = vim.opt

-- Line numbers
opt.number = true           -- show line numbers
opt.relativenumber = true   -- show relative line numbers (great for vim motions)

-- Indentation
opt.tabstop = 4             -- tab = 4 spaces visually
opt.shiftwidth = 4          -- indent = 4 spaces
opt.expandtab = true        -- use spaces instead of tabs
opt.smartindent = true      -- auto indent new lines

-- Search
opt.ignorecase = true       -- case insensitive search
opt.smartcase = true        -- unless you type a capital letter
opt.hlsearch = true         -- highlight search results
opt.incsearch = true        -- show matches as you type

-- Appearance
opt.termguicolors = true    -- enable 24-bit colors
opt.signcolumn = "yes"      -- always show sign column (prevents layout shifts)
opt.cursorline = true       -- highlight current line
opt.scrolloff = 8           -- keep 8 lines above/below cursor
opt.sidescrolloff = 8       -- keep 8 columns left/right of cursor
opt.wrap = false            -- don't wrap long lines
opt.colorcolumn = ""        -- no vertical line

-- Splits
opt.splitbelow = true       -- new horizontal splits go below
opt.splitright = true       -- new vertical splits go right

-- Files
opt.swapfile = false        -- don't create swap files
opt.backup = true           -- don't create backup files
opt.backupdir = vim.fn.expand("~/.config/nvim/backup//")
opt.undofile = true         -- persistent undo history across sessions
opt.undodir = vim.fn.expand("~/.config/nvim/undodir")

-- Clipboard
opt.clipboard = "unnamedplus" -- use system clipboard (fixes vim <-> OS copy paste)

-- Performance
opt.updatetime = 50         -- faster completion and diagnostics
opt.timeoutlen = 300        -- faster key sequence timeout

-- UI
opt.showmode = false        -- don't show -- INSERT -- (statusline handles this)
opt.pumheight = 10          -- max items in completion popup
opt.conceallevel = 0        -- show all characters (important for markdown)

-- =============================================================================
-- KEYMAPS
-- =============================================================================

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Better window navigation (CTRL + hjkl to move between splits)
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize splits with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Move lines up/down in visual mode
keymap("v", "<C-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<C-k>", ":m '<-2<CR>gv=gv", opts)

-- Keep cursor centered when scrolling
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)

-- Keep cursor centered when searching
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

-- Better paste (don't overwrite clipboard when pasting over selection)
keymap("v", "p", '"_dP', opts)

-- Clear search highlights
keymap("n", "<leader>h", ":nohlsearch<CR>", opts)

-- Save and quit shortcuts
keymap("n", "<leader>w", ":w<CR>", opts)
keymap("n", "<leader>q", ":q<CR>", opts)
keymap("n", "<leader>wq", ":wq<CR>", opts)

-- Split navigation shortcuts
keymap("n", "<leader>sv", ":vsplit<CR>", opts)  -- vertical split
keymap("n", "<leader>sh", ":split<CR>", opts)   -- horizontal split

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
