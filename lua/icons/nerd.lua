-- ══════════════════════════════════════════════════════════════════════
-- Nerd Font Icons
-- Full nerd font icon set (requires nerd font installed)
-- ══════════════════════════════════════════════════════════════════════

local M = {}

-- UI Icons
M.ui = {
  file = "󰈙",
  folder = "",
  folder_open = "",
  folder_empty = "󰜌",
  folder_empty_open = "󰜌",
  git = "",
  search = "",
  find = "",
  settings = "",
  close = "󰅖",
  new_file = "",
  trash = "",
  edit = "",
  check = "󰄬",
  circle = "",
  dot = "●",
  arrow_right = "",
  arrow_left = "",
  chevron_right = "",
  chevron_left = "",
  double_chevron_right = "»",
  double_chevron_left = "«",
}

-- Diagnostic Icons
M.diagnostics = {
  error = "",
  warn = "",
  hint = "󰌶",
  info = "",
  ok = "",
}

-- Git Icons
M.git = {
  add = "",
  modified = "",
  removed = "",
  renamed = "󰁕",
  untracked = "󰋗",
  ignored = "",
  unstaged = "󰄱",
  staged = "󰄵",
  conflict = "",
  branch = "",
  diff = "",
  repo = "",
  logo = "",
}

-- LSP Icons
M.lsp = {
  error = "",
  warn = "",
  hint = "󰌶",
  info = "",
  progress = {"", "", ""},
}

-- Kind Icons (for completion, symbols, etc.)
M.kind = {
  Array = "",
  Boolean = "󰨙",
  Class = "",
  Color = "",
  Constant = "",
  Constructor = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "",
  File = "",
  Folder = "",
  Function = "󰊕",
  Interface = "",
  Key = "",
  Keyword = "",
  Method = "",
  Module = "",
  Namespace = "󰦮",
  Null = "",
  Number = "󰎠",
  Object = "",
  Operator = "",
  Package = "",
  Property = "",
  Reference = "",
  Snippet = "",
  String = "",
  Struct = "󰆼",
  Text = "",
  TypeParameter = "",
  Unit = "",
  Value = "",
  Variable = "󰀫",
}

-- Filetype Icons (full set)
M.filetypes = {
  javascript = "",
  typescript = "",
  javascriptreact = "",
  typescriptreact = "",
  python = "",
  lua = "",
  vim = "",
  html = "",
  css = "",
  scss = "",
  json = "",
  markdown = "",
  yaml = "",
  toml = "",
  rust = "",
  go = "",
  c = "",
  cpp = "",
  java = "",
  php = "",
  ruby = "",
  shell = "",
  bash = "",
  zsh = "",
  fish = "",
  dockerfile = "󰡨",
  git = "",
  sql = "",
  prisma = "",
  graphql = "",
  vue = "",
  svelte = "",
  astro = "",
  config = "",
  lock = "",
  log = "󰌱",
  txt = "󰈙",
}

-- Terminal/Tools Icons
M.tools = {
  terminal = "",
  package = "",
  bug = "",
  flame = "",
  zap = "󱐋",
  rocket = "",
  star = "",
  heart = "",
  lightbulb = "",
  beaker = "󰂖",
}

-- Status Icons
M.status = {
  active = "",
  inactive = "",
  loading = "󰔟",
  success = "",
  failure = "",
  warning = "",
}

return M
