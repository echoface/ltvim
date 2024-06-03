
local hit, notify = pcall(require, "notify")
if hit then vim.notify = notify end
