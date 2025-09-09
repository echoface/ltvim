---@diagnostic disable: missing-fields

local vfn = vim.fn

local formatting = 'textDocument/formatting'
local range_format = 'textDocument/rangeFormatting'

local format_util = require("config.util.formating")

local create_cmd_fill_struct = function(bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, "GoFillStruct", function()
        vim.lsp.buf.code_action({
            apply = true,
            context = { only = { "refactor.rewrite" } },
        })
    end, {})
end

local create_cmd_goimports = function(bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, "GoImports", function()
        vim.lsp.buf.code_action({
            apply = true,
            context = { only = { "source.organizeImports" } },
        })
    end, {})
end

local get_current_gomod = function()
    local file = io.open('go.mod', 'r')
    if file == nil then
        return nil
    end

    local first_line = file:read()
    local mod_name = first_line:gsub('module ', '')
    file:close()
    return mod_name
end

-- this go file copy from go.nvim
return {
    capabilities = {
        textDocument = {
            completion = {
                completionItem = {
                    commitCharactersSupport = true,
                    deprecatedSupport = true,
                    documentationFormat = { 'markdown', 'plaintext' },
                    preselectSupport = true,
                    insertReplaceSupport = true,
                    labelDetailsSupport = true,
                    snippetSupport = vim.snippet and true or false,
                    resolveSupport = {
                        properties = {
                            'edit',
                            'documentation',
                            'details',
                            'additionalTextEdits',
                        },
                    },
                },
                completionList = {
                    itemDefaults = {
                        'editRange',
                        'insertTextFormat',
                        'insertTextMode',
                        'data',
                    },
                },
                contextSupport = false,
                dynamicRegistration = true,
            },
        },
    },
    filetypes = { 'go', 'gomod', 'gosum', 'gotmpl', 'gohtmltmpl', 'gotexttmpl' },
    message_level = vim.lsp.protocol.MessageType.Error,
    cmd = {
        'gopls', -- share the gopls instance if there is one already
        '-remote.debug=:0',
    },
    root_markers = { 'go.work', 'go.mod', '.git', 'go.sum' },
    flags = { allow_incremental_sync = true, debounce_text_changes = 500 },
    settings = {
        gopls = {
            -- more settings: https://github.com/golang/tools/blob/master/gopls/doc/settings.md
            -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
            -- not supported
            analyses = {
                -- check analyzers for default values
                -- leeave most of them to default
                -- shadow = true,
                -- unusedvariable = true,
                useany = false,
                unusedparams = false,
                unusedwrite = false,
            },
            codelenses = {
                generate = false,    -- show the `go generate` lens.
                gc_details = false, -- Show a code lens toggling the display of gc's choices.
                test = false,
                tidy = false,
                vendor = false,
                regenerate_cgo = false,
                upgrade_dependency = false,
            },
            usePlaceholders = false,
            completeUnimported = true,
            staticcheck = false, -- 严重影响内存和性能
            matcher = 'Fuzzy',
            -- check if diagnostic update_in_insert is set
            -- diagnosticsDelay = "5s",
            -- diagnosticsTrigger = "Edit",
            symbolMatcher = 'FastFuzzy',
            semanticTokens = false, -- default to false as treesitter is better
            ['local'] = get_current_gomod(),
            gofumpt = true,              -- true|false, -- turn on for new repos, gofmpt is good but also create code turmoils
            hoverKind = "SynopsisDocumentation", -- Hover 只显示简要文档
            linksInHover = false,        -- Hover 不加载外部链接
        },
    },
    on_attach = function(client, bufnr)
        create_cmd_goimports(bufnr)
        create_cmd_fill_struct(bufnr)

        local opts = { noremap = true, silent = true }
        local keymap = vim.api.nvim_buf_set_keymap
        keymap(bufnr, "i", ",f", "<cmd>:GoFillStruct<cr>", opts)

        format_util.enable_format_on_write(client, bufnr)
    end,
    -- NOTE: it is important to add handler to formatting handlers
    -- the async formatter will call these handlers when gopls respond
    -- without these handlers, the file will not be saved
    handlers = {
        [range_format] = function(...)
            vim.lsp.handlers[range_format](...)
            if vfn.getbufinfo('%')[1].changed == 1 then
                vim.cmd('noautocmd write')
            end
        end,
        [formatting] = function(...)
            vim.lsp.handlers[formatting](...)
            if vfn.getbufinfo('%')[1].changed == 1 then
                vim.cmd('noautocmd write')
            end
        end,
    },
}
