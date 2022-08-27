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

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

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
  use { "wbthomason/packer.nvim", commit = "90b323b" } -- Have packer manage itself
  use { "moll/vim-bbye", tag="*"}
  use { "goolord/alpha-nvim", commit="d688f46"}
  use { "nvim-lua/plenary.nvim", commit="31807ee"} -- Useful lua functions used by lots of plugins
  use { "numToStr/Comment.nvim", tag="v0.6.1"}
  use { "akinsho/toggleterm.nvim", commit="62683d9"}
  use { "ahmedkhalf/project.nvim", commit="090bb11"}
  use { "akinsho/bufferline.nvim", tag="*"}
  use { "lewis6991/impatient.nvim", commit="b842e16"}
  use { "nvim-lualine/lualine.nvim", commit="9076378"}
  use { "windwp/nvim-autopairs", commit="0a18e10"} -- Autopairs, integrates with both cmp and treesitter
  -- use { "lukas-reineke/indent-blankline.nvim", tag="*"} -- slow down cursor move

  -- file browser tree
  -- use{
	--	"nvim-neo-tree/neo-tree.nvim", branch = "main",
  --  requires = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
  --}
  use {
    "kyazdani42/nvim-tree.lua", tag="*",
    requires = {"kyazdani42/nvim-web-devicons"},
  }

  -- Colorschemes
  use { "lunarvim/darkplus.nvim"}

  -- cmp plugins
  use { "hrsh7th/nvim-cmp", tag="v0.0.1"} -- The completion plugin
  use { "hrsh7th/cmp-path", commit="447c87c"}     -- path completions
  use { "hrsh7th/cmp-cmdline"} -- cmdline completions
  use { "hrsh7th/cmp-buffer", commit="3022dbc"}   -- buffer completions
  use { "hrsh7th/cmp-nvim-lsp", commit="affe808"}
  use { "hrsh7th/cmp-nvim-lua", commit="d276254"}
  use { "saadparwaiz1/cmp_luasnip", commit="a9de941"} -- snippet completions

  -- snippets
  use { "L3MON4D3/LuaSnip"} --snippet engine
  use { "rafamadriz/friendly-snippets"} -- a bunch of snippets to use

  -- LSP
  -- use { "RRethy/vim-illuminate"}
  use { "neovim/nvim-lspconfig", tag="*"}       -- enable LSP
  use { "ray-x/lsp_signature.nvim", tag="*"}
  use { "williamboman/mason.nvim"}              -- install lsp/dap/linters
  use { "williamboman/mason-lspconfig.nvim"}
  use { "jose-elias-alvarez/null-ls.nvim", commit="9d1f8dc"} -- for formatters and linters
  -- go
  -- use("ray-x/go.nvim")
  -- use("ray-x/guihua.lua")

  -- Telescope
  use { "nvim-telescope/telescope.nvim", tag = "0.1.0"}

  -- Treesitter
  use {"nvim-treesitter/nvim-treesitter"}

  -- Git
  use { "APZelos/blamer.nvim", tag = "*"}
  use { "lewis6991/gitsigns.nvim", tag = "*" }

  -- DAP
 -- use { "mfussenegger/nvim-dap", commit = "014ebd53612cfd42ac8c131e6cec7c194572f21d" }
 -- use { "rcarriga/nvim-dap-ui", commit = "d76d6594374fb54abf2d94d6a320f3fd6e9bb2f7" }
 -- use { "ravenxrz/DAPInstall.nvim", commit = "8798b4c36d33723e7bba6ed6e2c202f84bb300de" }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
