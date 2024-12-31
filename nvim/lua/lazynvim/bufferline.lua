return {
    "akinsho/bufferline.nvim",
    version = '*',
    event = { "BufEnter" },
    config = function()
        require("config.bufferline")
    end
}
