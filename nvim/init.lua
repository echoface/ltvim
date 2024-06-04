require("globals")
require("mappings")
require("autocmds")

if true then
    require("lazyn")
else
    require "user.plugins"

    require "user.alpha"
    require "user.comment"
    require "user.gitsigns"
    require "user.nvimtree"
    require "user.lualine"
    require "user.autopairs"
    require "user.bufferline"
    require "user.telescope"
    require "user.project"
    require "user.impatient"

    require "lsp"
    require "user.nvimcmp"
    require "user.treesitter"

    -- require "user.dap"
    require "user.vimtest"
end
