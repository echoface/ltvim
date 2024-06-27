return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
        require("config.alpha")
    end
}
