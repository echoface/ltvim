local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
  return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.update_capabilities(M.capabilities)

M.setup = function()
  local signs = {

    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    virtual_text = false, -- disable virtual text
    signs = {
      active = signs, -- show signs
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })

  -- auto formatting
  vim.cmd [[autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync()]]

end

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  local keymap = vim.api.nvim_buf_set_keymap
  keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  -- lsp jump instruction
  keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  -- lsp action instruction
  keymap(bufnr, "n", "rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
  keymap(bufnr, "n", "ac", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
  --keymap(bufnr, "n", "lf", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)
  --keymap(bufnr, "n", "lt", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  --keymap(bufnr, "n", "ls", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
  --keymap(bufnr, "n", "ld", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  --keymap(bufnr, "n", "le", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
  --keymap(bufnr, "n", "ldj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
  --keymap(bufnr, "n", "ldk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
  vim.cmd('command! LspRename lua vim.lsp.buf.rename()<cr>')
  vim.cmd('command! LspFmt lua vim.lsp.buf.formatting()<cr>')
  vim.cmd('command! LspFix lua vim.lsp.buf.code_action()<cr>')
  vim.cmd('command! LspSig lua vim.lsp.buf.signature_help()<cr>')
  vim.cmd('command! LspTag lua vim.lsp.buf.document_symbol()<cr>')
  vim.cmd('command! Diagnostics lua vim.diagnostic.open_float()<cr>')
end

M.on_attach = function(client, bufnr)
  if client.name == "tsserver" then
    client.resolved_capabilities.document_formatting = false
  end

  if client.name == "sumneko_lua" then
    client.resolved_capabilities.document_formatting = false
  end

  lsp_keymaps(bufnr)

  local status_ok, illuminate = pcall(require, "illuminate")
  if status_ok then
		illuminate.on_attach(client)
  end
end

return M
