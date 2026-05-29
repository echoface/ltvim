return {
  "folke/lazydev.nvim",
  ft = "lua",
  version = "*",
  opts = {
    library = {
      -- always load the lazy.nvim library
      "lazy.nvim",
      -- Only load the lazyvim library when the `LazyVim` global is found
      -- { path = "LazyVim", words = { "LazyVim" } },
      -- Load the wezterm types when the `wezterm` module is required
      { path = "wezterm-types", mods = { "wezterm" } },
    },
    -- always enable unless `vim.g.lazydev_enabled = false`
    -- This is the default
    enabled = function(root_dir)
      return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
    end,
  },
  dependencies = {
  },
}
