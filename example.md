
# Example PR Description

## What's new?
## Asana Tasks
_TODO: Provide link(s) to related Asana tasks_
## Overview
_TODO: Provide a high-level overview of the changes in this PR_
## File Updates
- `lua/pr-description/config.lua`
- `lua/pr-description/init.lua`
- `plugin/pr-description.lua`
## Discussion
### `lua/pr-description/init.lua`
```
Line 82:             if line:match("") then
Line 84:               local discussion_line = line:gsub("", ""):gsub("%s+$", "")
Line 210:             table.insert(template, "_No discussion tags found. Add `` to the end of any line in your code to include it here._")
Line 259: function getFileExtension(filename) -- this functoin is sus fr. Maybe delete or something or put it in a new branch or whatever who cares
Line 288:             -- Remove -- from the file
Line 290:             local new_content = file_content:gsub("--", "")
```
### `plugin/pr-description.lua`
```
Line 19: vim.keymap.set("n", "<leader>PRD", function() --
```
### Commit History
* **052f609** - this is my first commit for my example PR description
   > This is an example of a beautiful commit message that sometimes goes
   > unnoticed in the PR review. I love these things mannnnnnn
   > * **
