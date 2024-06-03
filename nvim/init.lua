require("globals")
require("mappings")
require("autocmds")

if true then
    require("lazyn.lazy")
else
    require "user.plugins"
    require "user.options"
    require "user.alpha"
    require "user.comment"
    require "user.gitsigns"
    require "user.nvimtree"
    require "user.lualine"   -- slow down move speed,but acceptable
    require "user.autopairs" -- slow down move speed,but acceptable
    require "user.bufferline"
    require "user.telescope"
    -- require "user.illuminate"    -- slow down move speed
    -- require "user.toggleterm"    -- nothing bad built in
    require "user.project"
    require "user.impatient"

    require "user.lsp"
    require "user.nvimcmp"
    require "user.treesitter"

    -- require "user.dap"
    require "user.vimtest"
end
