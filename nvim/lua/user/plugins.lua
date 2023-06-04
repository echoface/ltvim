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
    use { "wbthomason/packer.nvim"} -- Have packer manage itself

    use { "moll/vim-bbye" }
    use { "goolord/alpha-nvim" }
    use { "nvim-lua/plenary.nvim" } -- Useful lua functions used by lots of plugins
    use { "windwp/nvim-autopairs" } -- Autopairs, integrates with both cmp and treesitter
    use { "numToStr/Comment.nvim" }
    use { "akinsho/toggleterm.nvim" }
    use { "ahmedkhalf/project.nvim" }
    use { "akinsho/bufferline.nvim" }
    use { "lewis6991/impatient.nvim" }
    use { "nvim-lualine/lualine.nvim" }

    use {
        "kyazdani42/nvim-tree.lua",
        requires = { "kyazdani42/nvim-web-devicons" },
    }

    -- Colorschemes
    use { "lunarvim/darkplus.nvim" }

    -- cmp plugins
    use { "hrsh7th/nvim-cmp" } -- The completion plugin
    use { "hrsh7th/cmp-path" } -- path completions
    use { "hrsh7th/cmp-cmdline" } -- cmdline completions
    use { "hrsh7th/cmp-buffer" } -- buffer completions
    use { "hrsh7th/cmp-nvim-lsp" }
    use { "hrsh7th/cmp-nvim-lua" }

    use {
        "hrsh7th/cmp-vsnip",
        requires = { "hrsh7th/vim-vsnip-integ", "hrsh7th/vim-vsnip", "rafamadriz/friendly-snippets" }
    }

    -- LSP
    -- use { "RRethy/vim-illuminate"}
    use { "neovim/nvim-lspconfig" } -- enable LSP
    use { "ray-x/lsp_signature.nvim" }
    use { "williamboman/mason.nvim" } -- install lsp/dap/linters
    use { "williamboman/mason-lspconfig.nvim" }
    use { "jose-elias-alvarez/null-ls.nvim" } -- for formatters and linters
    use { "ntpeters/vim-better-whitespace" }
    -- go
    -- use("ray-x/go.nvim")
    -- use("ray-x/guihua.lua")

    -- Telescope
    use { "nvim-telescope/telescope.nvim",
      tag = '0.1.1',
      requires = {
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-telescope/telescope-ui-select.nvim' }
      }
    }

    -- Treesitter
    use { "nvim-treesitter/nvim-treesitter" }

    -- Git
    use { "APZelos/blamer.nvim", tag = "*" }
    use { "lewis6991/gitsigns.nvim", tag = "*" }

    -- DAP
    use { "vim-test/vim-test"}
    -- use { "mfussenegger/nvim-dap", commit = "014ebd53612cfd42ac8c131e6cec7c194572f21d" }
    -- use { "rcarriga/nvim-dap-ui", commit = "d76d6594374fb54abf2d94d6a320f3fd6e9bb2f7" }
    -- use { "ravenxrz/DAPInstall.nvim", commit = "8798b4c36d33723e7bba6ed6e2c202f84bb300de" }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
