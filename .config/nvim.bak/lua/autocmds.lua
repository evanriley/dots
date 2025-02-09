-- Create an autocmd for format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    -- Check if there's an LSP client attached that supports formatting
    local clients = vim.lsp.get_active_clients({ bufnr = 0 })
    for _, client in ipairs(clients) do
      if client.supports_method("textDocument/formatting") then
        vim.lsp.buf.format({ async = false })
        break
      end
    end
  end,
})
