-- ══════════════════════════════════════════════════════════════════════
-- Theme & Icon Commands
-- User commands for theme and icon management
-- ══════════════════════════════════════════════════════════════════════

local M = {}

function M.setup()
  -- ══════════════════════════════════════════════════════════════════
  -- Theme Commands
  -- ══════════════════════════════════════════════════════════════════

  vim.api.nvim_create_user_command("ThemeSwitch", function(opts)
    local args = vim.split(opts.args, "%s+")
    local theme_name = args[1]
    local variant = args[2]

    local theme_manager = require("themes")
    theme_manager.apply(theme_name, variant, false)
  end, {
    nargs = "+",
    complete = function(arg_lead, cmd_line, cursor_pos)
      local theme_manager = require("themes")
      local themes = {}
      for key, _ in pairs(theme_manager.themes) do
        table.insert(themes, key)
      end
      return vim.tbl_filter(function(item)
        return vim.startswith(item, arg_lead)
      end, themes)
    end,
    desc = "Switch colorscheme theme",
  })

  vim.api.nvim_create_user_command("ThemeVariant", function(opts)
    local theme_manager = require("themes")
    local current = theme_manager.current.name
    if not current then
      vim.notify("No theme loaded", vim.log.levels.ERROR)
      return
    end

    theme_manager.apply(current, opts.args, false)
  end, {
    nargs = 1,
    desc = "Change theme variant",
  })

  vim.api.nvim_create_user_command("ThemeList", function()
    local theme_manager = require("themes")
    local themes = theme_manager.list()

    local lines = { "Available Themes:", "" }
    for _, theme in ipairs(themes) do
      local variants = theme.variants and (" (" .. table.concat(theme.variants, ", ") .. ")") or ""
      local transparency = theme.supports_transparency and " [T]" or ""
      table.insert(lines, string.format("  %s: %s%s%s", theme.key, theme.name, variants, transparency))
    end

    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
  end, { desc = "List all available themes" })

  vim.api.nvim_create_user_command("ThemeRandom", function()
    local theme_manager = require("themes")
    theme_manager.random()
  end, { desc = "Apply random theme" })

  vim.api.nvim_create_user_command("ThemeTransparency", function(opts)
    local theme_manager = require("themes")
    local current = theme_manager.current.name
    local variant = theme_manager.current.variant

    if not current then
      vim.notify("No theme loaded", vim.log.levels.ERROR)
      return
    end

    local transparency = opts.args == "on" or opts.args == "true" or opts.args == "1"
    theme_manager.apply(current, variant, transparency)
  end, {
    nargs = 1,
    complete = function()
      return { "on", "off" }
    end,
    desc = "Toggle theme transparency",
  })

  vim.api.nvim_create_user_command("ThemePreview", function()
    -- Try to use Telescope if available
    local ok, telescope = pcall(require, "telescope.builtin")
    if ok then
      -- Custom telescope picker for themes
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local conf = require("telescope.config").values
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      local theme_manager = require("themes")
      local themes = theme_manager.list()

      pickers
        .new({}, {
          prompt_title = "Theme Preview",
          finder = finders.new_table({
            results = themes,
            entry_maker = function(entry)
              local display = entry.name
              if entry.variants then
                display = display .. " (" .. table.concat(entry.variants, ", ") .. ")"
              end
              return {
                value = entry,
                display = display,
                ordinal = entry.name,
              }
            end,
          }),
          sorter = conf.generic_sorter({}),
          attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
              local selection = action_state.get_selected_entry()
              actions.close(prompt_bufnr)
              theme_manager.apply(selection.value.key, nil, false)
            end)
            return true
          end,
        })
        :find()
    else
      vim.cmd("ThemeList")
    end
  end, { desc = "Preview and select themes (Telescope)" })

  -- ══════════════════════════════════════════════════════════════════
  -- Icon Commands
  -- ══════════════════════════════════════════════════════════════════

  vim.api.nvim_create_user_command("IconsSet", function(opts)
    local icon_manager = require("icons")
    icon_manager.switch(opts.args)
  end, {
    nargs = 1,
    complete = function(arg_lead)
      local icon_manager = require("icons")
      local sets = {}
      for key, _ in pairs(icon_manager.sets) do
        table.insert(sets, key)
      end
      return vim.tbl_filter(function(item)
        return vim.startswith(item, arg_lead)
      end, sets)
    end,
    desc = "Switch icon set (vscode, nerd, minimal)",
  })

  vim.api.nvim_create_user_command("IconsList", function()
    local icon_manager = require("icons")
    local sets = icon_manager.list()

    local lines = { "Available Icon Sets:", "" }
    for _, set in ipairs(sets) do
      local active = set.active and " (active)" or ""
      table.insert(lines, string.format("  %s: %s%s", set.key, set.name, active))
      table.insert(lines, string.format("    %s", set.description))
    end

    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
  end, { desc = "List all available icon sets" })

  vim.api.nvim_create_user_command("IconsPreview", function()
    local icon_manager = require("icons")
    local icons = icon_manager.get()

    -- Show preview in a floating window
    local buf = vim.api.nvim_create_buf(false, true)
    local lines = {
      "Icon Preview (Current Set: " .. icon_manager.current_set .. ")",
      "",
      "UI Icons:",
      "  File: " .. icons.ui.file,
      "  Folder: " .. icons.ui.folder,
      "  Git: " .. icons.ui.git,
      "  Search: " .. icons.ui.search,
      "",
      "Diagnostics:",
      "  Error: " .. icons.diagnostics.error,
      "  Warn: " .. icons.diagnostics.warn,
      "  Hint: " .. icons.diagnostics.hint,
      "  Info: " .. icons.diagnostics.info,
      "",
      "Git:",
      "  Add: " .. icons.git.add,
      "  Modified: " .. icons.git.modified,
      "  Removed: " .. icons.git.removed,
      "  Branch: " .. icons.git.branch,
      "",
      "Press 'q' to close",
    }

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)

    local width = 50
    local height = #lines
    local win = vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = width,
      height = height,
      col = (vim.o.columns - width) / 2,
      row = (vim.o.lines - height) / 2,
      style = "minimal",
      border = "rounded",
    })

    vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", { noremap = true })
  end, { desc = "Preview current icon set" })

  -- ══════════════════════════════════════════════════════════════════
  -- Component Commands
  -- ══════════════════════════════════════════════════════════════════

  vim.api.nvim_create_user_command("ComponentToggle", function(opts)
    local component_manager = require("components")
    component_manager.toggle(opts.args)
  end, {
    nargs = 1,
    complete = function(arg_lead)
      local component_manager = require("components")
      local components = {}
      for key, _ in pairs(component_manager.components) do
        table.insert(components, key)
      end
      return vim.tbl_filter(function(item)
        return vim.startswith(item, arg_lead)
      end, components)
    end,
    desc = "Toggle component on/off",
  })

  vim.api.nvim_create_user_command("ComponentList", function()
    local component_manager = require("components")
    local components = component_manager.list()

    local lines = { "Components:", "" }
    for _, comp in ipairs(components) do
      local status = comp.enabled and "✓" or "✗"
      table.insert(lines, string.format("  [%s] %s: %s", status, comp.name, comp.description))
    end

    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
  end, { desc = "List all components" })

  vim.api.nvim_create_user_command("ComponentInfo", function(opts)
    local component_manager = require("components")
    local component = component_manager.components[opts.args]

    if not component then
      vim.notify("Component not found: " .. opts.args, vim.log.levels.ERROR)
      return
    end

    local config = component_manager.get_config(opts.args)
    local info = string.format(
      "Component: %s\nDescription: %s\nStatus: %s\nPlugin: %s",
      component.name,
      component.description,
      config.enabled and "Enabled" or "Disabled",
      component.plugin or "N/A"
    )

    vim.notify(info, vim.log.levels.INFO)
  end, {
    nargs = 1,
    complete = function(arg_lead)
      local component_manager = require("components")
      local components = {}
      for key, _ in pairs(component_manager.components) do
        table.insert(components, key)
      end
      return vim.tbl_filter(function(item)
        return vim.startswith(item, arg_lead)
      end, components)
    end,
    desc = "Show component information",
  })
end

return M
