-- This file is loaded automatically by Neovim
if vim.g.loaded_pr_description then
  return
end
vim.g.loaded_pr_description = true

-- Create vim command
vim.api.nvim_create_user_command("PRDescription", function()
  require("pr-description.nvim").show_description()
end, { nargs = 0 })
