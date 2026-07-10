return {
  "laytan/cloak.nvim",
  event = "BufReadPre",
  opts = {
    enabled = true,
    cloak_character = "*",
    -- The highlight group for the masked text
    highlight_group = "Comment",
    -- Patterns to cloak
    patterns = {
      {
        -- Match files like .env or .env.example
        file_pattern = ".env*",
        -- Match an equals sign and everything after it
        cloak_pattern = "=.+",
      },
    },
  },
}
