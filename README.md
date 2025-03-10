
# pr-description.nvim

A Neovim plugin for automatically generating comprehensive Pull Request descriptions

## Features

- 📝 Generate structured PR descriptions from your commit history
- :accessibility: beautiful commit messages included in the description
- 🔗 Link tasks with interactive prompts (Asana, Jira, etc.)
- 💬 Include discussion points from codebase with `@pr_discussion_tag` annotations
- 🧹 Clean up discussion tags from your codebase after PR creation

## Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use({
  "mjveilleux/pr-description.nvim",
  config = function()
    require("pr-description.nvim").setup()
  end,
})
```

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "mjveilleux/pr-description.nvim",
  config = true,
}
```

## Usage

### Commands

- `:PRCreateDesc` - Create a new PR description in a new tab (this opens up a markdown file that you can copy over into your description)
- `:PRCleanupTags` - Clean up all discussion tags from modified files

### Default Keymaps



- `<leader>PRD` - Create [P][R] [D]escription
- `<leader>CDT` - [C]leanup [D]iscussion [T]ags

## Discussion Tags

Add a discussion tag at the end of any line in your code to include it in your PR description:

```lua
local function important_code() --@pr_discussion_tag This needs careful review
```

The plugin will collect all these tags and include them in the PR description, making it easy to highlight important discussion points.

## Generated PR Structure

The plugin generates a markdown PR description with the following sections:

- **What's new?** - Summary of changes
- **Asana Tasks** - Links to related Asana tasks
- **Overview** - Space for you to add high-level context
- **File Updates** - List of all changed files
- **Discussion** - All discussion tags found in your code
- **Commit History** - Formatted list of commits with their messages

## Best Practices

- use [vim-create-pr](https://github.com/kristijanhusak/vim-create-pr) to automatically create PR
- use [lazygit](https://github.com/kdheepak/lazygit.nvim). This at least forces me to write better git messages which would look really nice in the PR Description when you are ready to request
- This plugin forces me to be better at choosing what and when to commit. You don't want to have a messy git commit history (once you see it in the PR description)

## Example Generation

[![Watch the video](https://img.youtube.com/vi/WrARCFtyWZ4/maxresdefault.jpg)](https://youtu.be/WrARCFtyWZ4)


## To Do
- generalize comments to better cleanup discussion tags (only accounts for SQL comments currently)
- I'm getting some weird errors with my buffers. If you try to run `:PRCreateDesc` again, it conflicts with the current buffer.
- Generalize tasks (right now it's hard coded for Asana)

## License

MIT
