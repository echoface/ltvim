return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  enabled = false,
  version = false,
  opts = {
    provider = "deepseek",
    instructions_file = "AGENTS.md",
    providers = {
      deepseek = {
        __inherited_from = "openai",
        model = "deepseek-v4-flash",
        api_key_name = "DEEPSEEK_API_KEY",
        endpoint = "https://api.deepseek.com",
      },
    },
    acp_providers = {
      ["opencode"] = {
        command = "opencode",
        args = { "acp" },
      },
    },
    selector = {
      provider = "telescope", -- native|mini_pick|telescope
    },
    windows = {
      position = "left", -- "right" | "left" | "top" | "bottom" | "smart"
      input = {
        prefix = "> ",
        height = 12, -- Height of the input window in vertical layout
      },
    }
  },
  build = "make", -- if you want to build from source then do `make BUILD_FROM_SOURCE=true"
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    --- The below dependencies are optional,
    "hrsh7th/nvim-cmp",            -- autocompletion for avante commands and mentions
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "nvim-telescope/telescope.nvim",
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
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
