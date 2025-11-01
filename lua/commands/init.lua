-- ══════════════════════════════════════════════════════════════════════
-- Custom Commands
-- Additional commands for better workflow
-- ══════════════════════════════════════════════════════════════════════

local M = {}

-- Health check for Nvim Ultimate
function M.health_check()
  local health = vim.health or require("health")
  local start = health.start or health.report_start
  local ok = health.ok or health.report_ok
  local warn = health.warn or health.report_warn
  local error = health.error or health.report_error
  local info = health.info or health.report_info

  start("Neovim Ultimate Edition Health Check")

  -- Check Neovim version
  local nvim_version = vim.version()
  if nvim_version.minor >= 9 then
    ok("Neovim version: " .. vim.fn.execute("version"):match("NVIM v[^\n]+"))
  else
    error("Neovim 0.9+ required. Current: " .. vim.fn.execute("version"):match("NVIM v[^\n]+"))
  end

  -- Check profile system
  local profile = require("utils.profile")
  local current_profile = profile.get()
  if current_profile then
    ok("Active profile: " .. current_profile)
    local profile_data = profile.get_profile_data()
    if profile_data then
      info("Languages: " .. table.concat(profile_data.languages, ", "))
      info("LSP Servers: " .. table.concat(profile_data.lsp_servers, ", "))
    end
  else
    error("No active profile found")
  end

  -- Check essential dependencies
  local deps = {
    { cmd = "git", name = "Git" },
    { cmd = "rg", name = "ripgrep" },
    { cmd = "fd", name = "fd" },
    { cmd = "node", name = "Node.js" },
  }

  start("Essential Dependencies")
  for _, dep in ipairs(deps) do
    if vim.fn.executable(dep.cmd) == 1 then
      ok(dep.name .. " installed")
    else
      warn(dep.name .. " not found (some features may not work)")
    end
  end

  -- Check LSP servers
  start("LSP Servers")
  local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
  if lspconfig_ok then
    local active_clients = vim.lsp.get_active_clients()
    if #active_clients > 0 then
      ok(#active_clients .. " LSP client(s) active")
      for _, client in ipairs(active_clients) do
        info("  - " .. client.name)
      end
    else
      info("No LSP clients currently active")
    end
  else
    error("lspconfig not loaded")
  end

  -- Check plugin manager
  start("Plugin Manager")
  local lazy_ok, lazy = pcall(require, "lazy")
  if lazy_ok then
    local stats = require("lazy").stats()
    ok("lazy.nvim loaded")
    info("Plugins: " .. stats.count .. " loaded")
    info("Startup time: " .. math.floor(stats.startuptime * 100) / 100 .. "ms")
  else
    error("lazy.nvim not loaded")
  end

  -- Check performance
  start("Performance")
  local metrics = profile.get_metrics()
  if metrics.startup_time < 100 then
    ok("Startup time: " .. metrics.startup_time .. "ms (excellent)")
  elseif metrics.startup_time < 200 then
    ok("Startup time: " .. metrics.startup_time .. "ms (good)")
  else
    warn("Startup time: " .. metrics.startup_time .. "ms (consider using minimal profile)")
  end
end

-- Setup all custom commands
function M.setup()
  -- Load theme & icon commands
  require("commands.theme").setup()

  -- Health check
  vim.api.nvim_create_user_command("NvimUltimateHealth", function()
    M.health_check()
  end, { desc = "Run health check for Nvim Ultimate" })

  -- Quick edit config
  vim.api.nvim_create_user_command("EditConfig", function()
    vim.cmd("e " .. vim.fn.stdpath("config") .. "/init.lua")
  end, { desc = "Edit init.lua" })

  vim.api.nvim_create_user_command("EditProfiles", function()
    vim.cmd("e " .. vim.fn.stdpath("config") .. "/lua/utils/profile.lua")
  end, { desc = "Edit profile configuration" })

  vim.api.nvim_create_user_command("EditKeymaps", function()
    vim.cmd("e " .. vim.fn.stdpath("config") .. "/lua/core/keymaps.lua")
  end, { desc = "Edit keymaps" })

  -- Project local profile
  vim.api.nvim_create_user_command("ProfileCreateLocal", function()
    local cwd = vim.fn.getcwd()
    local file_path = cwd .. "/.nvim-profile.json"

    if vim.fn.filereadable(file_path) == 1 then
      vim.notify("Local profile already exists", vim.log.levels.WARN)
      vim.cmd("e " .. file_path)
      return
    end

    local current_profile = require("utils.profile").get()
    local content = vim.json.encode({
      active_profile = current_profile,
      description = "Project-local profile for " .. vim.fn.fnamemodify(cwd, ":t"),
    })

    local file = io.open(file_path, "w")
    if file then
      file:write(content)
      file:close()
      vim.notify("Created local profile: " .. file_path, vim.log.levels.INFO)
      vim.cmd("e " .. file_path)
    else
      vim.notify("Failed to create local profile", vim.log.levels.ERROR)
    end
  end, { desc = "Create project-local profile" })

  -- Clear cache and restart
  vim.api.nvim_create_user_command("ClearCache", function()
    local data_dir = vim.fn.stdpath("data")
    vim.notify("Clearing cache and state files...", vim.log.levels.INFO)

    -- Clear lazy.nvim cache
    vim.fn.delete(data_dir .. "/lazy", "rf")

    -- Clear LSP cache
    vim.fn.delete(data_dir .. "/lsp", "rf")

    vim.notify("Cache cleared. Restart Neovim to take effect.", vim.log.levels.INFO)
  end, { desc = "Clear all cache and state files" })

  -- Update plugins
  vim.api.nvim_create_user_command("UpdatePlugins", function()
    require("lazy").sync()
  end, { desc = "Update all plugins" })

  -- Show startup time breakdown
  vim.api.nvim_create_user_command("StartupTime", function()
    vim.cmd("e " .. vim.fn.tempname() .. ".log")
    vim.cmd("%delete")
    vim.fn.append(0, vim.fn.execute("lua =require('lazy').stats()"):split("\n"))
    vim.cmd("setlocal buftype=nofile bufhidden=wipe noswapfile")
  end, { desc = "Show startup time breakdown" })

  -- Copy current file path
  vim.api.nvim_create_user_command("CopyPath", function(opts)
    local path = vim.fn.expand("%:p")
    if opts.args == "relative" then
      path = vim.fn.expand("%:.")
    elseif opts.args == "name" then
      path = vim.fn.expand("%:t")
    end
    vim.fn.setreg("+", path)
    vim.notify("Copied: " .. path, vim.log.levels.INFO)
  end, {
    nargs = "?",
    complete = function()
      return { "full", "relative", "name" }
    end,
    desc = "Copy file path to clipboard",
  })
end

return M
