return {
  "ray-x/lsp_signature.nvim",
  -- version = "*", 0.11 兼容问题
  -- https://github.com/ray-x/lsp_signature.nvim/pull/355
  event = "InsertEnter",
  opts = {
    bind = true,
    debug = false,
    hint_enable = false,             -- virtual hint
    handler_opts = {
      border = "rounded"
    }
  }
}
