local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

-- Install your plugins here
-- after change this file, need run
-- :PackerCompile
--
packer.startup(function(use)
    use { "wbthomason/packer.nvim" } -- Have packer manage itself

    use { "moll/vim-bbye" }
    use {
        "goolord/alpha-nvim",
        config = function()
            require "config.alpha"
        end,
    }
    use {
        "windwp/nvim-autopairs",
        config = function()
            require "config.autopairs"
        end
    } -- Autopairs, integrates with both cmp and treesitter

    use {
        "rcarriga/nvim-notify",
        config = function()
            vim.notify = require("notify")
        end }
    -- Colorschemes
    use {
        "morhetz/gruvbox",
        -- "tanvirtin/monokai.nvim",
        config = function()
            vim.cmd.colorscheme('gruvbox')
        end
    }

    use {
        "numToStr/Comment.nvim",
        config = function()
            require "config.comment"
        end
    }
    use {
        "akinsho/toggleterm.nvim",
        tag = '*',
        config = function()
            require("config.toggleterm")
        end,
    }
    use {
        "akinsho/bufferline.nvim",
        config = function()
            require "config.bufferline"
        end
    }
    use {
        "lewis6991/impatient.nvim",
        config = function()
            require "config.impatient"
        end }
    use { "nvim-lualine/lualine.nvim",
        config = function()
            require "config.lualine"
        end
    }
    use { "easymotion/vim-easymotion" }
    use { "ntpeters/vim-better-whitespace" }

    -- Git
    use { "APZelos/blamer.nvim", tag = "*" }
    use { "lewis6991/gitsigns.nvim", tag = "*",
        config = function()
            require "config.gitsigns"
        end
    }

    use {
        "kyazdani42/nvim-tree.lua",
        requires = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require "config.nvimtree"
        end
    }

    -- cmp plugins
    use {
        "hrsh7th/nvim-cmp",
        requires = {
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-cmdline" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },
            { "onsails/lspkind-nvim" }, -- lspkind (VS pictograms)
            {
                "hrsh7th/cmp-vsnip",
                requires = {
                    { "hrsh7th/vim-vsnip" },
                    { "hrsh7th/vim-vsnip-integ" },
                    { "rafamadriz/friendly-snippets" },
                }
            },
            {
                'saadparwaiz1/cmp_luasnip',
                requires = {
                    { 'L3MON4D3/LuaSnip' },
                    { "rafamadriz/friendly-snippets" },
                },
            }
        },
        config = function()
            require "config.nvimcmp"
        end
    }

    -- LSP
    use {
        "neovim/nvim-lspconfig",
        requires = {
            { "folke/neodev.nvim" },
            { "nvimtools/none-ls.nvim" },
            { "ray-x/lsp_signature.nvim" },
            -- use { "RRethy/vim-illuminate"}
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" }
        },
        config = function()
            require "config.lsp"
        end
    }


    -- Telescope
    use { "nvim-telescope/telescope.nvim",
        tag = "0.1.6",
        requires = {
            { "nvim-lua/plenary.nvim" },
            { "ahmedkhalf/project.nvim" },
            { "nvim-telescope/telescope-ui-select.nvim" },
            { "nvim-telescope/telescope-file-browser.nvim" },
            { "nvim-telescope/telescope-fzf-native.nvim",  run = "make" },
        },
        config = function()
            require "config.project"
            require "config.telescope"
        end
    }

    -- Treesitter
    use {
        "nvim-treesitter/nvim-treesitter", tag = "v0.9.1",
        config = function()
            require "config.treesitter"
        end
    }

    -- DAP test and debugging
    use {
        "vim-test/vim-test",
        config = function()
            require "config.vimtest"
        end
    }
    -- use { "mfussenegger/nvim-dap" }
    -- use { "rcarriga/nvim-dap-ui" }
    -- use { "ravenxrz/DAPInstall.nvim", commit = "8798b4c36d33723e7bba6ed6e2c202f84bb300de" }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)

