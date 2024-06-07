return {
    "akinsho/bufferline.nvim",
    event = { "BufEnter" },
    config = function()
        require("config.bufferline")
    end
}
