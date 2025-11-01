-- ══════════════════════════════════════════════════════════════════════
-- Autocommands
-- Automatic behaviors and event handlers
-- ══════════════════════════════════════════════════════════════════════

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- ══════════════════════════════════════════════════════════════════════
-- Highlight on yank
-- ══════════════════════════════════════════════════════════════════════

autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- ══════════════════════════════════════════════════════════════════════
-- Remove trailing whitespace on save
-- ══════════════════════════════════════════════════════════════════════

autocmd("BufWritePre", {
  group = augroup("trim_whitespace", { clear = true }),
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- ══════════════════════════════════════════════════════════════════════
-- Auto-close certain windows with 'q'
-- ══════════════════════════════════════════════════════════════════════

autocmd("FileType", {
  group = augroup("close_with_q", { clear = true }),
  pattern = {
    "help",
    "lspinfo",
    "man",
    "qf",
    "query",
    "scratch",
    "spectre_panel",
    "startuptime",
    "checkhealth",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- ══════════════════════════════════════════════════════════════════════
-- Auto-resize splits when window is resized
-- ══════════════════════════════════════════════════════════════════════

autocmd("VimResized", {
  group = augroup("resize_splits", { clear = true }),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- ══════════════════════════════════════════════════════════════════════
-- Go to last location when opening a buffer
-- ══════════════════════════════════════════════════════════════════════

autocmd("BufReadPost", {
  group = augroup("last_location", { clear = true }),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ══════════════════════════════════════════════════════════════════════
-- Show cursor line only in active window
-- ══════════════════════════════════════════════════════════════════════

autocmd({ "InsertLeave", "WinEnter" }, {
  group = augroup("auto_cursorline", { clear = true }),
  callback = function()
    if vim.bo.filetype ~= "alpha" then
      vim.opt.cursorline = true
    end
  end,
})

autocmd({ "InsertEnter", "WinLeave" }, {
  group = augroup("auto_cursorline", { clear = false }),
  callback = function()
    vim.opt.cursorline = false
  end,
})

-- ══════════════════════════════════════════════════════════════════════
-- Create missing directories when saving
-- ══════════════════════════════════════════════════════════════════════

autocmd("BufWritePre", {
  group = augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- ══════════════════════════════════════════════════════════════════════
-- Auto-format on save (if formatter is available)
-- ══════════════════════════════════════════════════════════════════════

autocmd("BufWritePre", {
  group = augroup("format_on_save", { clear = true }),
  callback = function()
    if vim.g.disable_autoformat then
      return
    end
    -- Try conform.nvim first
    local ok, conform = pcall(require, "conform")
    if ok then
      conform.format({ timeout_ms = 500, lsp_fallback = true })
    else
      -- Fallback to LSP formatting
      vim.lsp.buf.format({ timeout_ms = 500 })
    end
  end,
})

-- ══════════════════════════════════════════════════════════════════════
-- Check if file needs to be reloaded when changed
-- ══════════════════════════════════════════════════════════════════════

autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime", { clear = true }),
  command = "checktime",
})
