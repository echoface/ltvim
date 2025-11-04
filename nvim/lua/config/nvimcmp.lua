vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect" }

local cmp = require("cmp")
local luasnip = require("luasnip")

local has_words_before = function()
    if vim.bo.buftype == 'prompt' then
        return false
    end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    -- stylua: ignore
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local display_fomat = function(entry, item)
    item.menu = string.format("[%s]", entry.source.name)
    return item
end

local gen_cmp_sources = function()
    local sources = {
        { name = "nvim_lsp", group_index = 0 }, -- cmp from lsp server configure by nvim-lspconfig
        { name = "luasnip",  group_index = 0 }, -- snippets provider
        { name = "lazydev",  group_index = 5 },
        { name = "nvim_lua", group_index = 5 }, -- You can get the vim.lsp.util.* API with this source.
        { name = "path",     group_index = 10 },
        { name = "buffer",   group_index = 10 },
        {}
    }
    if package.loaded["copilot"] ~= nil then
        table.insert(sources, { name = "copilot", group_index = 0 })
    end
    return sources
end


M = {}
M.config = function()
    vim.keymap.set({ "i", "s" }, "<C-J>", function() luasnip.jump(1) end, { silent = true })
    vim.keymap.set({ "i", "s" }, "<C-K>", function() luasnip.jump(-1) end, { silent = true })

    cmp.setup({
        preselect = cmp.PreselectMode.None,
        -- formatting = {
        --     format = display_fomat,
        -- },
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        completion = {
            keyword_length = 2,
        },
        sources = gen_cmp_sources(),
        mapping = cmp.mapping.preset.insert({
            ["<C-k>"] = cmp.mapping.select_prev_item(),
            ["<C-j>"] = cmp.mapping.select_next_item(),
            ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
            ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
            ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
            ["<C-e>"] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),
            ["<CR>"] = cmp.mapping(function(fallback)
                if cmp.visible() and cmp.get_active_entry() then
                    cmp.confirm({ select = false })
                -- elseif luasnip.expandable() then
                --     luasnip.expand({})
                else
                    fallback()
                end
            end, { "i", "s" }),

            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                -- luasnap: wee use c-j/c-k to jump to next/previous item
                elseif luasnip.expandable() then
                    luasnip.expand({})
                -- elseif has_words_before() then
                --     cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                -- elseif luasnip.jumpable(-1) then
                --     luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
    })

    -- `/` cmdline setup.
    cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
    })

    -- `:` cmdline setup.
    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' }
        }, {
            { name = 'cmdline' }
        }),
        ---@diagnostic disable-next-line: missing-fields
        matching = { disallow_symbol_nonprefix_matching = false }
    })

    local ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
    if ok then
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done {})
    end
end

return M
