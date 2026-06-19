return {
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    { "github/copilot.vim" }, -- Uses your existing copilot setup
    { "nvim-lua/plenary.nvim" }, -- Required dependency
  },
  build = "make tiktoken", -- Optional: purely for better token counting
  opts = {
    -- Default configurations (you can customize these later)
    show_help = "yes",
    prompts = {
      Explain = {
        prompt = "/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.",
      },
      Review = {
        prompt = "/COPILOT_REVIEW Review the selected code.",
      },
      Tests = {
        prompt = "/COPILOT_TESTS Please generate tests for my code.",
      },
    },
  },
}
