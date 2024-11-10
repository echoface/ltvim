local format_util = require("config.util.formating")

return {

    on_attach = function(client, bufnr)
        format_util.enbale_format_on_write(client, bufnr)
    end,


    setup_opts = {
        on_init = function(client)
            local path = client.workspace_folders[1].name
            if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
                return
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                    -- Tell the language server which version of Lua you're using
                    -- (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT'
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME
                    }
                }
            })
        end,
        settings = {
            Lua = {
                diagnostics = {
                    disable = { "missing-fields", "incomplete-signature-doc" },
                },
                runtime = {
                    version = "LuaJIT",
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                }
            }
        },
    }
}
