-- this function is only needed for vsnip
local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- " Expand
-- imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
-- smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
--
-- " Expand or jump
-- imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
-- smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
--
-- " Jump forward or backward
-- imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
-- smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
-- imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
-- smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

local function nvimcmp_setup()
	vim.opt.completeopt = { "menu", "menuone", "noselect" }

    local cmp = require("cmp")
    cmp.setup({
        snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body) -- for vsnip users
            end,
        },
        completion = {
            keyword_length = 3,
            -- autocomplete = true, -- set to fase stop autocomplete, need trigger manually
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-k>"] = cmp.mapping.select_prev_item(),
            ["<C-j>"] = cmp.mapping.select_next_item(),
            ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
            ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
            ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
            ["<C-e>"] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),
            -- Accept currently selected item. If none selected, `select` first item.
            -- Set `select` to `false` to only confirm explicitly selected items.
            ["<CR>"] = cmp.mapping.confirm({
                select = true,
                behavior = cmp.ConfirmBehavior.Replace,
            }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif vim.fn["vsnip#jumpable"](1) == 1 then
                    feedkey("<Plug>(vsnip-jump-next)", "")
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                    feedkey("<Plug>(vsnip-jump-prev)", "")
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),
        sources = {
            { name = "nvim_lsp" },
            { name = "nvim_lua" },
            { name = 'vsnip' },
            -- { name = 'luasnip' },
            { name = "path" },
            { name = "buffer" },
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        }
    })

    -- `/` cmdline setup.
    cmp.setup.cmdline('/', {
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
            {
                name = 'cmdline',
                option = {
                    ignore_cmds = { 'Man', '!' },
                }
            }
        })
    })

    -- if vim.o.ft == 'clap_input' and vim.o.ft == 'guihua' and vim.o.ft == 'guihua_rust' then
    --     cmp.setup.buffer { completion = {enable = false} }
    -- end
    -- require("luasnip").config.set_config {
    --     history = true,
    --     updateevents = "TextChanged,TextChangedI"
    -- }
    -- require("luasnip.loaders.from_vscode").load()
end

return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        { "onsails/lspkind-nvim" }, -- lspkind (VS pictograms)
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-cmdline" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lua" },
        {
            "hrsh7th/cmp-vsnip",
            dependencies = {
                { "hrsh7th/vim-vsnip" },
                { "hrsh7th/vim-vsnip-integ" },
                { "rafamadriz/friendly-snippets" },
            },
            --{
            --    "L3MON4D3/LuaSnip",
            --    version = "v2.*",
            --    build = "make install_jsregexp",
            --    dependencies = {"rafamadriz/friendly-snippets"}, -- Snippets
            --    config = function()
            --        require("luasnip.loaders.from_vscode").lazy_load()
            --        -- https://github.com/rafamadriz/friendly-snippets/blob/main/snippets/go.json
            --    end
            --}, {"saadparwaiz1/cmp_luasnip", enabled = true}
        },
        config = nvimcmp_setup,
    }
}
