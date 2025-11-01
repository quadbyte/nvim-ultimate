-- ══════════════════════════════════════════════════════════════════════
-- Core Editor Options
-- Performance-optimized settings for all profiles
-- ══════════════════════════════════════════════════════════════════════

local opt = vim.opt
local g = vim.g

-- Leader keys (must be set before lazy.nvim)
g.mapleader = " "
g.maplocalleader = " "

-- ══════════════════════════════════════════════════════════════════════
-- UI & Appearance
-- ══════════════════════════════════════════════════════════════════════

opt.number = true                       -- Show line numbers
opt.relativenumber = true               -- Relative line numbers
opt.signcolumn = "yes"                  -- Always show sign column
opt.cursorline = true                   -- Highlight current line
opt.termguicolors = true                -- True color support
opt.showmode = false                    -- Don't show mode (in statusline)
opt.cmdheight = 1                       -- Command line height
opt.pumheight = 15                      -- Popup menu height (increased for better LSP completion UX)
opt.pumblend = 10                       -- Popup transparency
opt.winblend = 0                        -- Window transparency
opt.laststatus = 3                      -- Global statusline
opt.showtabline = 2                     -- Always show tabline
opt.colorcolumn = "120"                 -- Column marker at 120

-- ══════════════════════════════════════════════════════════════════════
-- Indentation & Formatting
-- ══════════════════════════════════════════════════════════════════════

opt.tabstop = 2                         -- Tab width
opt.shiftwidth = 2                      -- Indent width
opt.expandtab = true                    -- Use spaces instead of tabs
opt.smartindent = true                  -- Smart auto-indenting
opt.breakindent = true                  -- Wrapped lines follow indent
opt.wrap = false                        -- No line wrap by default
opt.linebreak = true                    -- Break at word boundaries

-- ══════════════════════════════════════════════════════════════════════
-- Search & Replace
-- ══════════════════════════════════════════════════════════════════════

opt.ignorecase = true                   -- Ignore case in search
opt.smartcase = true                    -- Case-sensitive if uppercase present
opt.hlsearch = true                     -- Highlight search results
opt.incsearch = true                    -- Incremental search
opt.inccommand = "split"                -- Show substitution preview

-- ══════════════════════════════════════════════════════════════════════
-- Performance & Responsiveness
-- ══════════════════════════════════════════════════════════════════════

opt.updatetime = 200                    -- Faster completion (default 4000ms)
opt.timeoutlen = 300                    -- Time to wait for mapped sequence
opt.redrawtime = 1500                   -- Time to redraw
opt.ttimeoutlen = 10                    -- Time for key codes
opt.lazyredraw = false                  -- Don't redraw during macros (disabled for noice.nvim)

-- ══════════════════════════════════════════════════════════════════════
-- File Handling
-- ══════════════════════════════════════════════════════════════════════

opt.swapfile = false                    -- No swap files
opt.backup = false                      -- No backup files
opt.undofile = true                     -- Persistent undo
opt.undodir = vim.fn.stdpath("data") .. "/undo"  -- Undo directory
opt.autoread = true                     -- Auto-reload changed files
opt.autowrite = true                    -- Auto-write before commands
opt.confirm = true                      -- Confirm before quit with unsaved

-- ══════════════════════════════════════════════════════════════════════
-- Splits & Windows
-- ══════════════════════════════════════════════════════════════════════

opt.splitright = true                   -- Vertical splits to the right
opt.splitbelow = true                   -- Horizontal splits below
opt.splitkeep = "screen"                -- Keep screen position when splitting

-- ══════════════════════════════════════════════════════════════════════
-- Scrolling & Navigation
-- ══════════════════════════════════════════════════════════════════════

opt.scrolloff = 8                       -- Lines to keep above/below cursor
opt.sidescrolloff = 8                   -- Columns to keep left/right of cursor
opt.smoothscroll = true                 -- Smooth scrolling

-- ══════════════════════════════════════════════════════════════════════
-- Completion
-- ══════════════════════════════════════════════════════════════════════

opt.completeopt = { "menu", "menuone", "noselect" }  -- Completion options
opt.shortmess:append("c")               -- Don't show completion messages
opt.wildmode = "longest:full,full"      -- Command-line completion mode
opt.wildoptions = "pum"                 -- Show popup menu for completion

-- ══════════════════════════════════════════════════════════════════════
-- Clipboard & Mouse
-- ══════════════════════════════════════════════════════════════════════

opt.clipboard = "unnamedplus"           -- Use system clipboard
opt.mouse = "a"                         -- Enable mouse in all modes

-- ══════════════════════════════════════════════════════════════════════
-- Folding (Will be enhanced by nvim-ufo plugin)
-- ══════════════════════════════════════════════════════════════════════

-- NOTE: Folding configuration is handled by nvim-ufo plugin
-- These are basic fallbacks if ufo is not loaded
opt.foldmethod = "expr"                 -- Use expression for folding
opt.foldlevel = 99                      -- Don't fold by default
opt.foldlevelstart = 99                 -- Start with all folds open
opt.foldenable = true                   -- Enable folding

-- Set foldexpr with error handling (treesitter may not be loaded yet)
vim.defer_fn(function()
  local ok = pcall(function()
    opt.foldexpr = "nvim_treesitter#foldexpr()"
  end)
  if not ok then
    opt.foldexpr = "0"  -- Fallback to no folding
  end
end, 100)

-- ══════════════════════════════════════════════════════════════════════
-- Miscellaneous
-- ══════════════════════════════════════════════════════════════════════

opt.hidden = true                       -- Allow hidden buffers
opt.iskeyword:append("-")               -- Treat dash as part of word
opt.formatoptions:remove({ "c", "r", "o" })  -- Don't insert comment leader automatically
opt.whichwrap:append("<,>,[,],h,l")     -- Move to next line with these keys
opt.virtualedit = "block"               -- Allow cursor beyond last character in visual block
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Disable some built-in plugins we don't need
g.loaded_gzip = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_2html_plugin = 1
g.loaded_matchit = 1
g.loaded_matchparen = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1
g.loaded_netrwFileHandlers = 1

-- Performance: Disable some providers we don't need
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- Python provider (enable only if python3 is available)
if vim.fn.executable("python3") == 1 then
  g.python3_host_prog = vim.fn.exepath("python3")
else
  g.loaded_python3_provider = 0
end

-- Node provider (enable only if node is available)
if vim.fn.executable("node") == 1 then
  g.node_host_prog = vim.fn.exepath("node")
else
  g.loaded_node_provider = 0
end
