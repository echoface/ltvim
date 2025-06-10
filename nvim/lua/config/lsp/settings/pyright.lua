local format_util = require("config.util.formating")

return {
    on_attach = function(client, bufnr)
        format_util.enable_format_on_write(client, bufnr)
    end,
}
