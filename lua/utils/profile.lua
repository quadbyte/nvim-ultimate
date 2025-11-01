-- ══════════════════════════════════════════════════════════════════════
-- Profile System
-- Load language-specific configurations based on selected profile
-- Supports: inheritance, project-local profiles, validation, metrics
-- ══════════════════════════════════════════════════════════════════════

local M = {}
local platform = require("utils.platform")

-- Profile storage
M.config_file = platform.config_dir() .. "/profile.json"
M.project_config_file = ".nvim-profile.json"
M.current_profile = nil
M.startup_time = vim.fn.reltime()
M.metrics = {}

-- Available profiles
M.profiles = {
  minimal = {
    name = "Minimal",
    description = "Lightweight setup with core features only",
    languages = {},
    lsp_servers = {},
    formatters = {},
    linters = {},
  },
  frontend = {
    name = "Frontend Developer",
    description = "JavaScript/TypeScript, React, Vue, Tailwind",
    languages = { "javascript", "typescript", "html", "css", "json" },
    lsp_servers = { "ts_ls", "html", "cssls", "tailwindcss", "eslint" },
    formatters = { "prettier" },
    linters = { "eslint_d" },
  },
  backend = {
    name = "Backend Developer",
    description = "Python, Go, Rust, Node.js, SQL",
    languages = { "python", "go", "rust", "javascript", "sql", "yaml" },
    lsp_servers = { "pyright", "gopls", "rust_analyzer", "ts_ls", "sqlls", "yamlls" },
    formatters = { "black", "gofmt", "rustfmt", "prettier" },
    linters = { "pylint", "golangci-lint" },
  },
  mobile = {
    name = "Mobile Developer",
    description = "React Native, Flutter, Swift, Kotlin",
    languages = { "javascript", "typescript", "dart", "swift", "kotlin" },
    lsp_servers = { "ts_ls", "dartls", "sourcekit", "kotlin_language_server" },
    formatters = { "prettier", "dart_format" },
    linters = {},
  },
  data = {
    name = "Data Engineer",
    description = "Python, SQL, R, Jupyter",
    languages = { "python", "sql", "r", "json", "yaml" },
    lsp_servers = { "pyright", "sqlls", "r_language_server", "jsonls", "yamlls" },
    formatters = { "black", "sql-formatter" },
    linters = { "pylint" },
  },
  devops = {
    name = "DevOps Engineer",
    description = "Bash, Docker, Kubernetes, Terraform",
    languages = { "bash", "yaml", "dockerfile", "terraform", "json" },
    lsp_servers = { "bashls", "yamlls", "dockerls", "terraformls", "jsonls" },
    formatters = { "shfmt", "terraform_fmt" },
    linters = { "shellcheck" },
  },
  fullstack = {
    name = "Full Stack Developer",
    description = "Frontend + Backend combined",
    languages = { "javascript", "typescript", "python", "go", "rust", "html", "css", "sql", "yaml" },
    lsp_servers = { "ts_ls", "html", "cssls", "tailwindcss", "pyright", "gopls", "rust_analyzer", "sqlls", "yamlls" },
    formatters = { "prettier", "black", "gofmt", "rustfmt" },
    linters = { "eslint_d", "pylint" },
  },
}

-- Validate profile structure
function M.validate_profile(profile_name, profile_data)
  if not profile_data then
    return false, "Profile data is nil"
  end

  local required_fields = { "name", "description", "languages", "lsp_servers", "formatters", "linters" }
  for _, field in ipairs(required_fields) do
    if profile_data[field] == nil then
      return false, "Missing required field: " .. field
    end
  end

  -- Validate types
  if type(profile_data.languages) ~= "table" then
    return false, "languages must be a table"
  end
  if type(profile_data.lsp_servers) ~= "table" then
    return false, "lsp_servers must be a table"
  end

  return true, "valid"
end

-- Load profile configuration with error handling
function M.load_config()
  local file = io.open(M.config_file, "r")
  if file then
    local content = file:read("*a")
    file:close()
    local ok, config = pcall(vim.json.decode, content)
    if ok and config then
      return config
    else
      vim.notify("Error parsing profile.json: " .. tostring(config), vim.log.levels.WARN)
    end
  end
  -- Default to fullstack profile if file doesn't exist
  return { active_profile = "fullstack", performance_mode = "balanced" }
end

-- Load project-local profile (if exists in cwd)
function M.load_project_profile()
  local cwd = vim.fn.getcwd()
  local project_file = cwd .. "/" .. M.project_config_file
  local file = io.open(project_file, "r")
  if file then
    local content = file:read("*a")
    file:close()
    local ok, config = pcall(vim.json.decode, content)
    if ok and config and config.active_profile then
      vim.notify("Using project profile: " .. config.active_profile, vim.log.levels.INFO)
      return config
    end
  end
  return nil
end

-- Save profile configuration
function M.save_config(config)
  local ok, encoded = pcall(vim.json.encode, config)
  if not ok then
    vim.notify("Error encoding profile config: " .. tostring(encoded), vim.log.levels.ERROR)
    return false
  end

  local file = io.open(M.config_file, "w")
  if file then
    file:write(encoded)
    file:close()
    return true
  else
    vim.notify("Error writing to " .. M.config_file, vim.log.levels.ERROR)
    return false
  end
end

-- Extend profile (inheritance)
-- Usage: extend_profile("backend", "mybackend", { additional_lsp = {...} })
function M.extend_profile(base_profile, new_name, extensions)
  if not M.profiles[base_profile] then
    vim.notify("Base profile not found: " .. base_profile, vim.log.levels.ERROR)
    return nil
  end

  local base = vim.deepcopy(M.profiles[base_profile])
  local extended = vim.tbl_deep_extend("force", base, extensions or {})
  extended.name = new_name .. " (Extended)"
  extended.base_profile = base_profile

  M.profiles[new_name] = extended
  return extended
end

-- Cache for loaded configuration
M.config_cache = nil
M.config_cache_time = 0

-- Get current profile (checks project-local first, then global)
-- Cached to avoid repeated I/O operations
function M.get()
  if not M.current_profile then
    local current_time = vim.loop.hrtime()
    -- Invalidate cache after 5 seconds (5e9 nanoseconds)
    if not M.config_cache or (current_time - M.config_cache_time) > 5e9 then
      -- Check for project-local profile first
      local project_config = M.load_project_profile()
      if project_config and project_config.active_profile then
        M.current_profile = project_config.active_profile
        M.config_cache = project_config
      else
        -- Fall back to global config
        local config = M.load_config()
        M.current_profile = config.active_profile or "fullstack"
        M.config_cache = config
      end
      M.config_cache_time = current_time
    else
      -- Use cached profile
      if M.config_cache and M.config_cache.active_profile then
        M.current_profile = M.config_cache.active_profile
      end
    end
  end
  return M.current_profile
end

-- Get profile data
function M.get_profile_data(profile_name)
  profile_name = profile_name or M.get()
  return M.profiles[profile_name] or M.profiles.minimal
end

-- Switch to a different profile
function M.switch(profile_name)
  if not M.profiles[profile_name] then
    vim.notify("Profile not found: " .. profile_name, vim.log.levels.ERROR)
    return false
  end

  local config = M.load_config()
  config.active_profile = profile_name
  M.save_config(config)
  M.current_profile = profile_name

  -- Invalidate cache on profile switch
  M.config_cache = nil
  M.config_cache_time = 0

  vim.notify("Switched to profile: " .. M.profiles[profile_name].name .. "\nRestart Neovim to apply changes", vim.log.levels.INFO)
  return true
end

-- List all profiles
function M.list()
  local profiles = {}
  for key, profile in pairs(M.profiles) do
    table.insert(profiles, {
      key = key,
      name = profile.name,
      description = profile.description,
      languages = #profile.languages,
    })
  end
  return profiles
end

-- Check if a language is enabled in current profile
function M.has_language(lang)
  local profile = M.get_profile_data()
  return vim.tbl_contains(profile.languages, lang)
end

-- Get LSP servers for current profile
function M.get_lsp_servers()
  local profile = M.get_profile_data()
  return profile.lsp_servers or {}
end

-- Get formatters for current profile
function M.get_formatters()
  local profile = M.get_profile_data()
  return profile.formatters or {}
end

-- Get performance metrics
function M.get_metrics()
  local startup_ms = math.floor(vim.fn.reltimefloat(vim.fn.reltime(M.startup_time)) * 1000)
  M.metrics.startup_time = startup_ms
  M.metrics.profile = M.get()
  M.metrics.plugins_loaded = 0

  -- Get plugin count from lazy.nvim if available
  local ok, lazy_stats = pcall(require, "lazy.stats")
  if ok then
    M.metrics.plugins_loaded = lazy_stats.count
  end

  return M.metrics
end

-- Benchmark profile switching
function M.benchmark()
  local results = {}
  local current = M.get()

  vim.notify("Benchmarking profiles... This may take a moment", vim.log.levels.INFO)

  for profile_name, _ in pairs(M.profiles) do
    local start = vim.fn.reltime()
    -- Simulate profile load
    local profile_data = M.get_profile_data(profile_name)
    local time = math.floor(vim.fn.reltimefloat(vim.fn.reltime(start)) * 1000)

    table.insert(results, {
      name = profile_name,
      time = time,
      plugins = #profile_data.lsp_servers + 10, -- Estimate
    })
  end

  -- Sort by time
  table.sort(results, function(a, b) return a.time < b.time end)

  local lines = { "Profile Benchmark Results:", "" }
  for _, r in ipairs(results) do
    table.insert(lines, string.format("  %s: ~%dms (%d plugins)", r.name, r.time, r.plugins))
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

-- Clone profile to create custom variant
function M.clone_profile(source, dest_name)
  if not M.profiles[source] then
    vim.notify("Source profile not found: " .. source, vim.log.levels.ERROR)
    return false
  end

  local cloned = vim.deepcopy(M.profiles[source])
  cloned.name = dest_name
  cloned.description = "Custom profile based on " .. source
  M.profiles[dest_name] = cloned

  vim.notify("Profile cloned: " .. dest_name, vim.log.levels.INFO)
  return true
end

-- Initialize profile on startup
function M.init()
  -- Load configuration (checks project-local first)
  local config = M.load_config()
  local project_config = M.load_project_profile()

  if project_config and project_config.active_profile then
    M.current_profile = project_config.active_profile
  else
    M.current_profile = config.active_profile or "fullstack"
  end

  -- Validate active profile exists
  if not M.profiles[M.current_profile] then
    vim.notify("Invalid profile: " .. M.current_profile .. ". Falling back to fullstack", vim.log.levels.WARN)
    M.current_profile = "fullstack"
  end

  -- Create user commands
  vim.api.nvim_create_user_command("ProfileSwitch", function(opts)
    M.switch(opts.args)
  end, {
    nargs = 1,
    complete = function()
      return vim.tbl_keys(M.profiles)
    end,
    desc = "Switch to a different profile",
  })

  vim.api.nvim_create_user_command("ProfileInfo", function()
    local profile = M.get_profile_data()
    local metrics = M.get_metrics()
    local info = string.format(
      "Profile: %s\nDescription: %s\nLanguages: %s\nLSP Servers: %s\nStartup Time: %dms",
      profile.name,
      profile.description,
      table.concat(profile.languages, ", "),
      table.concat(profile.lsp_servers, ", "),
      metrics.startup_time
    )
    vim.notify(info, vim.log.levels.INFO)
  end, { desc = "Show current profile information" })

  vim.api.nvim_create_user_command("ProfileList", function()
    local profiles = M.list()
    local lines = { "Available Profiles:", "" }
    for _, p in ipairs(profiles) do
      local active = p.key == M.current_profile and " (active)" or ""
      table.insert(lines, string.format("  %s: %s (%d languages)%s", p.key, p.name, p.languages, active))
    end
    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
  end, { desc = "List all available profiles" })

  vim.api.nvim_create_user_command("ProfileBench", function()
    M.benchmark()
  end, { desc = "Benchmark profile load times" })

  vim.api.nvim_create_user_command("ProfileClone", function(opts)
    local args = vim.split(opts.args, " ")
    if #args ~= 2 then
      vim.notify("Usage: ProfileClone <source> <destination>", vim.log.levels.ERROR)
      return
    end
    M.clone_profile(args[1], args[2])
  end, {
    nargs = "+",
    complete = function()
      return vim.tbl_keys(M.profiles)
    end,
    desc = "Clone a profile to create custom variant",
  })

  vim.api.nvim_create_user_command("ProfileValidate", function()
    local profile = M.get_profile_data()
    local valid, msg = M.validate_profile(M.current_profile, profile)
    if valid then
      vim.notify("Profile is valid ✓", vim.log.levels.INFO)
    else
      vim.notify("Profile validation failed: " .. msg, vim.log.levels.ERROR)
    end
  end, { desc = "Validate current profile structure" })

  vim.api.nvim_create_user_command("ProfilePicker", function()
    -- This will be implemented with Telescope in the next phase
    local ok, telescope = pcall(require, "telescope.builtin")
    if not ok then
      vim.notify("Telescope not loaded yet. Use :ProfileList", vim.log.levels.WARN)
      vim.cmd("ProfileList")
      return
    end

    require("telescope.pickers").new({}, {
      prompt_title = "Select Profile",
      finder = require("telescope.finders").new_table({
        results = M.list(),
        entry_maker = function(entry)
          return {
            value = entry.key,
            display = entry.key .. ": " .. entry.name,
            ordinal = entry.key,
          }
        end,
      }),
      sorter = require("telescope.config").values.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        local actions = require("telescope.actions")
        actions.select_default:replace(function()
          local selection = require("telescope.actions.state").get_selected_entry()
          actions.close(prompt_bufnr)
          M.switch(selection.value)
        end)
        return true
      end,
    }):find()
  end, { desc = "Pick profile with Telescope" })
end

return M
