-- ══════════════════════════════════════════════════════════════════════
-- Advanced Search and Replace
-- nvim-spectre for project-wide search and replace
-- ══════════════════════════════════════════════════════════════════════

return {
  {
    "nvim-pack/nvim-spectre",
    build = false,
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    keys = {
      {
        "<leader>sr",
        function()
          require("spectre").open()
        end,
        desc = "Replace in files (Spectre)",
      },
      {
        "<leader>sw",
        function()
          require("spectre").open_visual({ select_word = true })
        end,
        desc = "Search current word",
      },
      {
        "<leader>sw",
        function()
          require("spectre").open_visual()
        end,
        mode = "v",
        desc = "Search current word",
      },
      {
        "<leader>sp",
        function()
          require("spectre").open_file_search({ select_word = true })
        end,
        desc = "Search on current file",
      },
    },
  },

  -- Vim Illuminate - Highlight word under cursor
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },
}
