return {
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.routes = opts.routes or {}
      
      -- Filter out pyright LSP progress messages so they don't stack in the UI
      table.insert(opts.routes, {
        filter = {
          event = "lsp",
          kind = "progress",
          cond = function(message)
            local client = vim.tbl_get(message.opts, "progress", "client")
            return client == "pyright"
          end,
        },
        opts = { skip = true },
      })
    end,
  },
}
