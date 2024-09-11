-- this function is only needed for vsnip
local cmp = require("cmp")
local luasnip = require("luasnip")

-- local feedkey = function(key, mode)
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
-- end
-- local has_words_before = function()
--     local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--     return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
-- end

local formating_fomat = function(entry, item)
    item.menu = string.format("[%s]", entry.source.name)
    return item
end
local snippet_expand = function(args)
    -- vim.fn["vsnip#anonymous"](args.body) -- for vsnip users
    luasnip.lsp_expand(args.body) -- For `luasnip` users.
end

vim.opt.completeopt = { "menuone", "noinsert", "noselect" }

cmp.setup({
    preselect = cmp.PreselectMode.None,
    formatting = {
        format = formating_fomat,
    },
    snippet = {
        expand = snippet_expand,
    },
    completion = {
        -- keyword_length = 2,
        -- autocomplete = true, -- set to fase stop autocomplete, need trigger manually
    },
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
        ['<CR>'] = cmp.mapping(function(fallback)
            if not cmp.visible() then
                fallback()
            end

            if luasnip.expandable() then
                return luasnip.expand()
            end

            return cmp.confirm({
                select = true,
                -- behavior = cmp.ConfirmBehavior.Replace,
            })
        end),

        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
                luasnip.jump(1)
                --elseif vim.fn["vsnip#jumpable"](1) == 1 then
                --    feedkey("<Plug>(vsnip-expand-or-jump)", "")
                --    -- feedkey("<Plug>(vsnip-jump-next)", "")
                --elseif has_words_before() then
                --    cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
                --elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                --    feedkey("<Plug>(vsnip-jump-prev)", "")
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = {
        { name = "codeverse" },
        { name = "nvim_lsp" },
        -- { name = "nvim_lsp_signature_help" },
        { name = "nvim_lua" },
        { name = 'luasnip' },
        -- { name = 'vsnip' },
        { name = "buffer" },
        { name = "path" },
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    }
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
    matching = { disallow_symbol_nonprefix_matching = false }
})

local ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
if ok then
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done {})
end
