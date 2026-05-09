return {
    "nvim-treesitter/nvim-treesitter",

    build = ":TSUpdate",
    branch = "main",
    -- this is copy from https://www.lazyvim.org/plugins/treesitter
    commit = vim.fn.has("nvim-0.12") == 0 and "7caec274fd19c12b55902a5b795100d21531391f" or nil,
    event = {
      "BufReadPost",
      "BufNewFile",
    },
    opts = {
      -- 只安装必要 parser
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",

        "go",
        "gomod",
        "gowork",
        "gosum",

        "json",
        "yaml",

        "bash",
      },

      sync_install = false,

      -- 最稳：关闭自动安装
      auto_install = false,

      highlight = {
        enable = true,

        -- 避免 regex 双高亮
        additional_vim_regex_highlighting = false,

        -- 大文件自动禁用
        disable = function(_, buf)
          local max_filesize = 1024 * 1024 -- 1MB

          local ok, stats = pcall(
            vim.loop.fs_stat,
            vim.api.nvim_buf_get_name(buf)
          )

          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },

      -- indent 经常有坑，极简建议关闭
      indent = {
        enable = false,
      },
    },

    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  }

