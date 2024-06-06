require("globals")
require("mappings")
require("autocmds")

if true then
    require("init_lazy")
else
    require "init_packer"
end
