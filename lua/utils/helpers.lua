-- ══════════════════════════════════════════════════════════════════════
-- Helper Utilities
-- Common functions used throughout the configuration
-- ══════════════════════════════════════════════════════════════════════

local M = {}

-- Safely require a module
function M.safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    vim.notify("Error loading " .. module .. ": " .. result, vim.log.levels.ERROR)
    return nil
  end
  return result
end

-- Check if a plugin is loaded
function M.is_loaded(plugin)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
  return lazy_config_avail and lazy_config.plugins[plugin] ~= nil
end

-- Merge tables
function M.merge(...)
  local result = {}
  for _, t in ipairs({ ... }) do
    for k, v in pairs(t) do
      result[k] = v
    end
  end
  return result
end

-- Get project root directory
function M.get_root()
  local root_patterns = { ".git", "package.json", "Cargo.toml", "go.mod", "pyproject.toml", "Makefile" }
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  if not path then
    return vim.loop.cwd()
  end

  local root = vim.fs.find(root_patterns, { path = path, upward = true })[1]
  return root and vim.fs.dirname(root) or vim.loop.cwd()
end

-- Create augroup
function M.augroup(name)
  return vim.api.nvim_create_augroup("nvim_" .. name, { clear = true })
end

-- Map key with options
function M.map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Get visual selection
function M.get_visual_selection()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return table.concat(lines, "\n")
end

-- Toggle option
function M.toggle(option, silent, values)
  if values then
    if vim.opt_local[option]:get() == values[1] then
      vim.opt_local[option] = values[2]
    else
      vim.opt_local[option] = values[1]
    end
    return
  end
  vim.opt_local[option] = not vim.opt_local[option]:get()
  if not silent then
    vim.notify(option .. " = " .. tostring(vim.opt_local[option]:get()))
  end
end

-- Check if we're in a git repo
function M.is_git_repo()
  vim.fn.system("git rev-parse --is-inside-work-tree")
  return vim.v.shell_error == 0
end

-- Get git branch
function M.get_git_branch()
  if M.is_git_repo() then
    local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
    if branch ~= "" then
      return branch
    end
  end
  return ""
end

-- Performance measurement
M.perf = {
  start_time = vim.fn.reltime(),
}

function M.perf.measure()
  return vim.fn.reltimefloat(vim.fn.reltime(M.perf.start_time)) * 1000
end

function M.perf.show_startup()
  vim.notify(string.format("⚡ Neovim started in %.2fms", M.perf.measure()), vim.log.levels.INFO)
end

-- Lazy loading helper
function M.lazy_load(plugin, timer)
  vim.defer_fn(function()
    require("lazy").load({ plugins = { plugin } })
  end, timer or 0)
end

return M
