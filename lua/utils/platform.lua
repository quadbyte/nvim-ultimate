-- ══════════════════════════════════════════════════════════════════════
-- Platform Detection and Utilities
-- Provides cross-platform compatibility for Linux, macOS, and Windows
-- ══════════════════════════════════════════════════════════════════════

local M = {}

-- Detect operating system
function M.is_mac()
  return vim.fn.has("mac") == 1 or vim.fn.has("macunix") == 1
end

function M.is_linux()
  return vim.fn.has("unix") == 1 and not M.is_mac()
end

function M.is_windows()
  return vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
end

function M.is_wsl()
  if not M.is_linux() then
    return false
  end
  local handle = io.open("/proc/version", "r")
  if handle then
    local content = handle:read("*a")
    handle:close()
    return content:lower():find("microsoft") ~= nil
  end
  return false
end

-- Get OS name
function M.get_os()
  if M.is_mac() then
    return "macos"
  elseif M.is_wsl() then
    return "wsl"
  elseif M.is_linux() then
    return "linux"
  elseif M.is_windows() then
    return "windows"
  end
  return "unknown"
end

-- Detect CPU architecture
function M.get_arch()
  local arch = vim.fn.system("uname -m"):gsub("%s+", "")
  return arch -- arm64, x86_64, etc.
end

-- Get package manager
function M.get_package_manager()
  if M.is_mac() then
    return "brew"
  elseif M.is_linux() then
    -- Detect Linux package manager
    if vim.fn.executable("apt") == 1 then
      return "apt"
    elseif vim.fn.executable("pacman") == 1 then
      return "pacman"
    elseif vim.fn.executable("dnf") == 1 then
      return "dnf"
    elseif vim.fn.executable("yum") == 1 then
      return "yum"
    end
  elseif M.is_windows() or M.is_wsl() then
    if vim.fn.executable("winget") == 1 then
      return "winget"
    end
  end
  return nil
end

-- Path separator
function M.path_sep()
  if M.is_windows() then
    return "\\"
  end
  return "/"
end

-- Home directory
function M.home_dir()
  if M.is_windows() then
    return os.getenv("USERPROFILE")
  end
  return os.getenv("HOME")
end

-- Config directory
function M.config_dir()
  if M.is_windows() then
    return os.getenv("LOCALAPPDATA") .. "\\nvim"
  end
  return M.home_dir() .. "/.config/nvim"
end

-- Data directory
function M.data_dir()
  if M.is_windows() then
    return os.getenv("LOCALAPPDATA") .. "\\nvim-data"
  end
  return M.home_dir() .. "/.local/share/nvim"
end

-- Check if command exists
function M.command_exists(cmd)
  return vim.fn.executable(cmd) == 1
end

-- Get system info
function M.get_info()
  return {
    os = M.get_os(),
    arch = M.get_arch(),
    package_manager = M.get_package_manager(),
    is_wsl = M.is_wsl(),
    path_sep = M.path_sep(),
    home = M.home_dir(),
    config = M.config_dir(),
    data = M.data_dir(),
  }
end

return M
