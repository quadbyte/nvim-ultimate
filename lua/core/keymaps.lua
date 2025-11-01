-- ══════════════════════════════════════════════════════════════════════
-- Core Keymaps
-- Essential keybindings that work across all profiles
-- ══════════════════════════════════════════════════════════════════════

local map = vim.keymap.set
local opts = { silent = true, noremap = true }

-- ══════════════════════════════════════════════════════════════════════
-- Better Defaults
-- ══════════════════════════════════════════════════════════════════════

-- Better up/down (handles wrapped lines)
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- Better indenting
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Paste without yanking
map("x", "p", [["_dP]], opts)

-- Delete without yanking
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yank" })

-- Select all
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- ══════════════════════════════════════════════════════════════════════
-- File Operations
-- ══════════════════════════════════════════════════════════════════════

map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>W", "<cmd>wa<CR>", { desc = "Save all files" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Quit all (force)" })
map("n", "<leader>x", "<cmd>x<CR>", { desc = "Save and quit" })

-- ══════════════════════════════════════════════════════════════════════
-- Window Navigation
-- ══════════════════════════════════════════════════════════════════════

map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Window splits
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Horizontal split" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })
map("n", "<leader>s=", "<C-w>=", { desc = "Equal splits" })

-- Resize windows
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase width" })

-- ══════════════════════════════════════════════════════════════════════
-- Buffer Navigation
-- ══════════════════════════════════════════════════════════════════════

map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bD", "<cmd>bdelete!<CR>", { desc = "Delete buffer (force)" })
map("n", "<leader>ba", "<cmd>%bd|e#|bd#<CR>", { desc = "Delete all buffers except current" })

-- ══════════════════════════════════════════════════════════════════════
-- Move Lines
-- ══════════════════════════════════════════════════════════════════════

map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- ══════════════════════════════════════════════════════════════════════
-- Terminal
-- ══════════════════════════════════════════════════════════════════════

-- Exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Go to left window" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Go to lower window" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Go to upper window" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Go to right window" })

-- ══════════════════════════════════════════════════════════════════════
-- Quick Fix & Location List
-- ══════════════════════════════════════════════════════════════════════

map("n", "[q", "<cmd>cprevious<CR>", { desc = "Previous quickfix" })
map("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix" })
map("n", "[l", "<cmd>lprevious<CR>", { desc = "Previous location" })
map("n", "]l", "<cmd>lnext<CR>", { desc = "Next location" })

-- ══════════════════════════════════════════════════════════════════════
-- Better Command Line
-- ══════════════════════════════════════════════════════════════════════

map("c", "<C-a>", "<Home>", { desc = "Go to beginning" })
map("c", "<C-e>", "<End>", { desc = "Go to end" })
map("c", "<C-p>", "<Up>", { desc = "Previous command" })
map("c", "<C-n>", "<Down>", { desc = "Next command" })

-- ══════════════════════════════════════════════════════════════════════
-- Diagnostic Navigation
-- ══════════════════════════════════════════════════════════════════════

map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "[e", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Previous error" })
map("n", "]e", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next error" })

-- ══════════════════════════════════════════════════════════════════════
-- Toggle Options
-- ══════════════════════════════════════════════════════════════════════

map("n", "<leader>uw", function()
  vim.opt.wrap = not vim.opt.wrap:get()
  vim.notify("wrap = " .. tostring(vim.opt.wrap:get()))
end, { desc = "Toggle wrap" })

map("n", "<leader>us", function()
  vim.opt.spell = not vim.opt.spell:get()
  vim.notify("spell = " .. tostring(vim.opt.spell:get()))
end, { desc = "Toggle spell" })

map("n", "<leader>un", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
  vim.notify("relativenumber = " .. tostring(vim.opt.relativenumber:get()))
end, { desc = "Toggle relative number" })

-- ══════════════════════════════════════════════════════════════════════
-- Miscellaneous
-- ══════════════════════════════════════════════════════════════════════

-- Increment/decrement
map("n", "+", "<C-a>", { desc = "Increment number" })
map("n", "-", "<C-x>", { desc = "Decrement number" })

-- New empty buffer
map("n", "<leader>fn", "<cmd>enew<CR>", { desc = "New file" })

-- Search word under cursor
map("n", "gw", "*N", { desc = "Search word under cursor" })
map("x", "gw", "*N", { desc = "Search word under cursor" })

-- Better marks
map("n", "'", "`", { desc = "Go to mark (exact position)" })
map("n", "`", "'", { desc = "Go to mark (line)" })
