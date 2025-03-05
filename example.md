## What's new?

This is a new PR to show just how cool `pr-description.nvim` is!

## Asana Tasks
- [This is my task, the reason for this PR](https://www.mveilleux.com/)
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
* **35055e5** - another day, another commit
   > Now I am going to make this commit nice long for you so you can see just
   > how the message parses B-E-A-Uuuutifully. You can see how it's shaded
   > and indented differently. Yeah buddy, that's the good stuff. Does this
   > make me a front end dev now? Maybe.. Who knows. But it's nice, right? I
   > think my colleagues will like this very much.
* **052f609** - this is my first commit for my example PR description
   > This is an example of a beautiful commit message that sometimes goes
   > unnoticed in the PR review. I love these things mannnnnnn
   > * **
