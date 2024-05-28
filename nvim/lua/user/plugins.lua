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
return packer.startup(function(use)
    -- plugins here
    use { "wbthomason/packer.nvim" } -- Have packer manage itself

    use { "moll/vim-bbye" }
    use { "goolord/alpha-nvim" }
    use { "nvim-lua/plenary.nvim" } -- Useful lua functions used by lots of plugins
    use { "windwp/nvim-autopairs" } -- Autopairs, integrates with both cmp and treesitter
    -- Colorschemes
    use { "dracula/vim" }
    use { "ray-x/aurora" }
    use { "folke/tokyonight.nvim" }
    use { "lunarvim/darkplus.nvim" }
    use { "maxmx03/solarized.nvim" }
    use { "UtkarshVerma/molokai.nvim" }


    use { "numToStr/Comment.nvim" }
    use { "akinsho/toggleterm.nvim" }
    use { "ahmedkhalf/project.nvim" }
    use { "akinsho/bufferline.nvim" }
    use { "lewis6991/impatient.nvim" }
    use { "nvim-lualine/lualine.nvim" }
    use { "easymotion/vim-easymotion" }
    use { "ntpeters/vim-better-whitespace" }

    use {
        "kyazdani42/nvim-tree.lua",
        requires = { "kyazdani42/nvim-web-devicons" }
    }

    -- cmp plugins
    use { "hrsh7th/nvim-cmp" }
    use { "hrsh7th/cmp-path" }
    use { "hrsh7th/cmp-cmdline" }
    use { "hrsh7th/cmp-buffer" }
    use { "hrsh7th/cmp-nvim-lsp" }
    use { "hrsh7th/cmp-nvim-lua" }
    use {
        "hrsh7th/cmp-vsnip",
        requires = {
            { "hrsh7th/vim-vsnip" },
            { "hrsh7th/vim-vsnip-integ" },
            { "rafamadriz/friendly-snippets" },
        }
    }
    use { 'L3MON4D3/LuaSnip' }
    use { 'saadparwaiz1/cmp_luasnip' }

    -- LSP
    -- use { "RRethy/vim-illuminate"}
    use { "neovim/nvim-lspconfig" }
    use { "williamboman/mason.nvim" }
    use { "williamboman/mason-lspconfig.nvim" }

    use { "folke/neodev.nvim" }               -- dev for neovim or config
    use { "ray-x/lsp_signature.nvim" }        -- display func signatures
    -- use { "jose-elias-alvarez/null-ls.nvim" } -- for formatters and linters

    -- Telescope
    use { "nvim-telescope/telescope.nvim",
        tag = "0.1.6",
        requires = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-ui-select.nvim" },
            { "nvim-telescope/telescope-file-browser.nvim" }
        }
    }

    -- Treesitter
    use { "nvim-treesitter/nvim-treesitter", tag = "v0.9.1" }

    -- Git
    use { "APZelos/blamer.nvim", tag = "*" }
    use { "lewis6991/gitsigns.nvim", tag = "*" }

    -- DAP test and debugging
    use { "vim-test/vim-test" }
    -- use { "mfussenegger/nvim-dap" }
    -- use { "rcarriga/nvim-dap-ui" }
    -- use { "ravenxrz/DAPInstall.nvim", commit = "8798b4c36d33723e7bba6ed6e2c202f84bb300de" }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
