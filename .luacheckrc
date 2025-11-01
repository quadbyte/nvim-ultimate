-- Luacheck configuration for Neovim Ultimate Edition
-- https://luacheck.readthedocs.io/en/stable/config.html

std = "lua51+luajit"

-- Neovim global variables
globals = {
  "vim",
  "jit",
}

read_globals = {
  "vim",
}

-- Ignore warnings
ignore = {
  "212", -- Unused argument (common in Neovim callbacks)
  "631", -- Line too long (handled by stylua)
}

-- Exclude directories
exclude_files = {
  ".git/",
  ".github/",
  "tests/",
}

-- Cache results for faster subsequent runs
cache = true
