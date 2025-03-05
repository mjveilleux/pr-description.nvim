-- This file is loaded automatically by Neovim
if vim.g.loaded_pr_description then
  return
end
vim.g.loaded_pr_description = true

-- Get the module
local pr_desc = require("pr-description")
--this file is also being changed
vim.api.nvim_create_user_command("PRCreateDesc", function()
  pr_desc.create_pr_description()
end, { nargs = 0 })

vim.api.nvim_create_user_command("PRCleanupTags", function()
  pr_desc.cleanup_discussion_tags_cmd()
end, { nargs = 0 })

-- You can optionally add keymaps here too
vim.keymap.set("n", "<leader>PRD", function() --@pr_discussion_tag 
  pr_desc.create_pr_description()
end, { desc = "Create [P][R] [D]escription" })

vim.keymap.set("n", "<leader>CDT", function()
  pr_desc.cleanup_discussion_tags_cmd()
end, { desc = "[C]leanup [D]iscussion [T]ags" })
