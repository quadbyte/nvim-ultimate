-- ══════════════════════════════════════════════════════════════════════
-- Session Management
-- Automatic session management with persistence.nvim
-- ══════════════════════════════════════════════════════════════════════

return {
  -- Persistence.nvim - Session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
      pre_save = nil,
      save_empty = false,
    },
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
    init = function()
      -- Auto-save session on exit if profile has session_autosave enabled
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          local config_file = vim.fn.stdpath("config") .. "/profile.json"
          local file = io.open(config_file, "r")
          if file then
            local content = file:read("*a")
            file:close()
            local ok, config = pcall(vim.json.decode, content)
            if ok and config.custom_settings and config.custom_settings.session_autosave then
              require("persistence").save()
            end
          end
        end,
      })
    end,
  },
}
