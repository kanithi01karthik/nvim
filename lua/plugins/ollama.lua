return {
  {
    "David-Kunz/gen.nvim",
    cmd = { "Gen" },
    config = function()
      require("gen").setup({
        model = "qwen2.5-coder:7b",
        host = "localhost",
        port = "11434",
        display_mode = "split",
        show_prompt = true,
        show_model = true,
      })
    end,
  },
  {
    "milanglacier/minuet-ai.nvim",
    event = "InsertEnter",
    config = function()
      require("minuet").setup({
        provider = "ollama",
        provider_options = {
          model = "qwen2.5-coder:7b",
          host = "http://localhost:11434",
        },
      })
    end,
  },
}
