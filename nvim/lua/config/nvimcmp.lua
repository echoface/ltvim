vim.opt.completeopt = { "menuone", "noinsert", "noselect" }

local luasnip = require("luasnip")

vim.keymap.set({ "i", "s" }, "<C-J>", function() luasnip.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-K>", function() luasnip.jump(-1) end, { silent = true })
-- we don't need expand manually, use nvim-cmp prompt instead
-- vim.keymap.set({ "i" }, "<C-K>", function() luasnip.expand() end, { silent = true })
-- we don't need expand manually, use nvim-cmp prompt instead
-- vim.keymap.set({ "i", "s" }, "<C-E>", function()
--     if luasnip.choice_active() then
--         luasnip.change_choice(1)
--     end
-- end, { silent = true })

-- local feedkey = function(key, mode)
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
-- end

local has_words_before = function()
    if vim.bo.buftype == 'prompt' then
        return false
    end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    -- stylua: ignore
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local formating_fomat = function(entry, item)
    item.menu = string.format("[%s]", entry.source.name)
    return item
end

local snippet_expand = function(args)
    luasnip.lsp_expand(args.body) -- For `luasnip` users.
end

local cmp = require("cmp")
cmp.setup({
    preselect = cmp.PreselectMode.None,
    formatting = {
        format = formating_fomat,
    },
    snippet = {
        expand = snippet_expand,
    },
    completion = {
        keyword_length = 3,
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
            if cmp.visible() and has_words_before() then
                cmp.select_next_item()
                -- cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                -- luasnap: wee use c-j/c-k to jump to next/previous item
                -- elseif luasnip.locally_jumpable(1) then
                --     luasnip.jump(1)
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
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = {
        { name = "lazydev",  group_index = 1 },
        { name = "luasnip",  group_index = 1 },
        { name = "nvim_lsp", group_index = 1 },
        { name = "copilot",  group_index = 1 },
        { name = "nvim_lua", group_index = 1 },
        { name = "path",     group_index = 2 },
        { name = "buffer",   group_index = 2 },
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    sorting = {
        priority_weight = 2,
        comparators = {
            require("copilot_cmp.comparators").prioritize,

            -- Below is the default comparitor list and order for nvim-cmp
            cmp.config.compare.offset,
            -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
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
    matching = { disallow_symbol_nonprefix_matching = false }
})

local ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
if ok then
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done {})
end
