
local format_util = require("config.util.formating")

return {
    on_attach = function(client, bufnr)
        format_util.enbale_format_on_write(client, bufnr)
    end,
    setup_opts = {
        settings = {
            python = {
                analysis = {
                    typeCheckingMode = "off",
                },
            },
        },
    }
}
