
return {
    "vim-test/vim-test",
    event = "InsertEnter",
    cmd = {"TestNearest", "TestFile"},
    config = function ()
        require("config.vimtest")
    end,
}
