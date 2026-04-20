return {
  {
    "carlos-algms/agentic.nvim",
    enabled = true,

    opts = {
      -- Available by default: "claude-acp" | "gemini-acp" | "codex-acp" | "opencode-acp" | "cursor-acp" | "auggie-acp"
      provider = "gemini-acp", -- setting the name here is all you need to get started
      acp_providers = {
        ["gemini-acp"] = {
          env = {
            GEMINI_API_KEY = os.getenv("GEMINI_API_KEY"),
          }
        }
      }
    },

    -- these are just suggested keymaps; customize as desired
    keys = {
      {
        "<leader>aa",
        function() require("agentic").toggle() end,
        mode = { "n", "v" },
        desc = "Toggle Agentic Chat"
      },
      {
        "<leader>as",
        function() require("agentic").add_selection_or_file_to_context() end,
        mode = { "n", "v" },
        desc = "Add file or selection to Agentic to Context"
      },
      {
        "<leader>an",
        function() require("agentic").new_session() end,
        mode = { "n", "v" },
        desc = "New Agentic Session"
      },
      {
        "<leader>ar", -- ai Restore
        function()
          require("agentic").restore_session()
        end,
        desc = "Agentic Restore session",
        silent = true,
        mode = { "n", "v" },
      },
      {
        "<leader>ap",
        function()
          require("agentic").switch_provider()
        end,
        desc = "Change provider",
        mode = { "n" },
      },
      {
        "<leader>ad", -- ai Diagnostics
        function()
          require("agentic").add_current_line_diagnostics()
        end,
        desc = "Add current line diagnostic to Agentic",
        mode = { "n" },
      },
      {
        "<leader>aS",
        function()
          require("agentic").stop_generation()
        end,
        desc = "Stop current generations",
        mode = { "n" },
      },
      {
        "<leader>aD", -- ai all Diagnostics
        function()
          require("agentic").add_buffer_diagnostics()
        end,
        desc = "Add all buffer diagnostics to Agentic",
        mode = { "n" },
      },
    },
  },
  {
    "yetone/avante.nvim",
    enabled = false,
    build = vim.fn.has("win32") ~= 0
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or "make",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      instructions_file = "avante.md",
      -- provider = "gemini",
      provider = "gemini-cli",
      acp_providers = {
        ["gemini-cli"] = {
          command = "gemini",
          args = { "--acp" },
          env = {
            NODE_NO_WARNINGS = "1",
            GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
          },
        },
      }
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "ravitemer/mcphub.nvim",
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      -- {
      --   -- Make sure to set this up properly if you have lazy=true
      --   'MeanderingProgrammer/render-markdown.nvim',
      --   opts = {
      --     file_types = { "markdown", "Avante" },
      --   },
      --   ft = { "markdown", "Avante" },
      -- },
    },
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
    config = function()
      require("mcphub").setup()
    end
  }
}
