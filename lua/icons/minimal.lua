-- ══════════════════════════════════════════════════════════════════════
-- Minimal Icons
-- Simple ASCII/Unicode icons (no special fonts required)
-- ══════════════════════════════════════════════════════════════════════

local M = {}

-- UI Icons
M.ui = {
  file = "F",
  folder = "D",
  folder_open = "D",
  folder_empty = "D",
  folder_empty_open = "D",
  git = "G",
  search = "?",
  find = "F",
  settings = "*",
  close = "X",
  new_file = "+",
  trash = "T",
  edit = "E",
  check = "√",
  circle = "○",
  dot = "•",
  arrow_right = ">",
  arrow_left = "<",
  chevron_right = ">",
  chevron_left = "<",
  double_chevron_right = ">>",
  double_chevron_left = "<<",
}

-- Diagnostic Icons
M.diagnostics = {
  error = "E",
  warn = "W",
  hint = "H",
  info = "I",
  ok = "✓",
}

-- Git Icons
M.git = {
  add = "+",
  modified = "~",
  removed = "-",
  renamed = "R",
  untracked = "?",
  ignored = "!",
  unstaged = "U",
  staged = "S",
  conflict = "C",
  branch = "B",
  diff = "D",
  repo = "R",
  logo = "G",
}

-- LSP Icons
M.lsp = {
  error = "E",
  warn = "W",
  hint = "H",
  info = "I",
  progress = {"|", "/", "-"},
}

-- Kind Icons (for completion, symbols, etc.)
M.kind = {
  Array = "[]",
  Boolean = "B",
  Class = "C",
  Color = "#",
  Constant = "K",
  Constructor = "C",
  Enum = "E",
  EnumMember = "M",
  Event = "Ev",
  Field = "F",
  File = "f",
  Folder = "d",
  Function = "ƒ",
  Interface = "I",
  Key = "K",
  Keyword = "K",
  Method = "m",
  Module = "M",
  Namespace = "N",
  Null = "∅",
  Number = "#",
  Object = "{}",
  Operator = "O",
  Package = "P",
  Property = "p",
  Reference = "R",
  Snippet = "S",
  String = "s",
  Struct = "S",
  Text = "T",
  TypeParameter = "T",
  Unit = "U",
  Value = "V",
  Variable = "v",
}

-- Filetype Icons (simple)
M.filetypes = {
  javascript = "JS",
  typescript = "TS",
  javascriptreact = "JSX",
  typescriptreact = "TSX",
  python = "PY",
  lua = "LUA",
  vim = "VIM",
  html = "HTML",
  css = "CSS",
  scss = "SCSS",
  json = "JSON",
  markdown = "MD",
  yaml = "YAML",
  toml = "TOML",
  rust = "RS",
  go = "GO",
  c = "C",
  cpp = "C++",
  java = "JAVA",
  php = "PHP",
  ruby = "RB",
  shell = "SH",
  bash = "BASH",
  zsh = "ZSH",
  fish = "FISH",
  dockerfile = "DOCK",
  git = "GIT",
  sql = "SQL",
  config = "CFG",
  lock = "LOCK",
  log = "LOG",
  txt = "TXT",
}

-- Terminal/Tools Icons
M.tools = {
  terminal = "$",
  package = "PKG",
  bug = "BUG",
  flame = "*",
  zap = "!",
  rocket = "^",
  star = "*",
  heart = "♥",
  lightbulb = "i",
  beaker = "T",
}

-- Status Icons
M.status = {
  active = "*",
  inactive = "-",
  loading = "...",
  success = "√",
  failure = "X",
  warning = "!",
}

return M
