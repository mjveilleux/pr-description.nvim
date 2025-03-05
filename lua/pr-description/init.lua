-- Main module for pr-description
local M = {}

-- Plugin setup function called by lazy.nvim
function M.setup(opts)
  -- Merge default options with user options
  opts = vim.tbl_deep_extend("force", require("pr-description.config").defaults, opts or {})
  
  -- Store options for later use
  M.options = opts
end

-- Main function that prints the PR description
function M.show_description()
  print("ALSSSOOOOO here is my pr-description")
end

return M
