-- Local plugin for Git PR descriptions
local M = {}

-- Define PR description functionality directly
M.setup = function()
  -- All the code will be executed when this module is required
  -- Define our functions and set up commands
      -- A Neovim plugin to create PR descriptions with commit history and discussion tags
      local M = {}

      -- Function to get all commits that are in the current branch but not in the target branch
      local function get_commits(target_branch)
        target_branch = target_branch or "main"
        
        -- Use %B to get the full commit message (both subject and body)
        -- %h for the commit hash
        local handle = io.popen(string.format("git log %s..HEAD --pretty=format:'* **%%h** - %%B'", target_branch))
        local raw_result = handle:read("*a")
        handle:close()
        
        -- Process each commit to format the message properly
        local commits = {}
        local current_commit = {}
        local is_first_line = true
        
        -- Split the result by the commit marker pattern
        for line in string.gmatch(raw_result .. "\n* **", "[^\n]+") do
          if line:match("^%* %*%*[a-f0-9]+%*%* %-") then
            -- This is a new commit line
            if #current_commit > 0 then
              -- Store the previous commit
              table.insert(commits, table.concat(current_commit, "\n"))
              current_commit = {}
            end
            table.insert(current_commit, line)
            is_first_line = true
          elseif #current_commit > 0 then
            -- This is a continuation of the current commit message
            is_first_line = false
            -- Indent additional lines for better readability and add blockquote
            if line:gsub("%s", "") ~= "" then
              table.insert(current_commit,"   > " .. line)
            else
              table.insert(current_commit, "")
            end
          end
        end
        
        -- Add the last commit
        if #current_commit > 0 then
          table.insert(commits, table.concat(current_commit, "\n"))
        end
        
        -- Join all commits with spacing between them
        return table.concat(commits, "\n\n")
      end

      -- Function to get all changed files in the current branch compared to the target branch
      local function get_changed_files(target_branch)
        target_branch = target_branch or "main"
        local handle = io.popen(string.format("git diff --name-only %s..HEAD", target_branch))
        local result = handle:read("*a")
        handle:close()
        
        local files = {}
        for file in string.gmatch(result, "[^\n]+") do
          table.insert(files, file)
        end
        
        return files
      end

      -- Function to find discussion tags in a file
      local function find_discussion_tags(file_path)
        local discussions = {}
        local file = io.open(file_path, "r")
        
        if file then
          local line_num = 0
          for line in file:lines() do
            line_num = line_num + 1
            if line:match("@pr_discussion_tag") then
              -- Remove the tag from what we store
              local discussion_line = line:gsub("@pr_discussion_tag", ""):gsub("%s+$", "")
              table.insert(discussions, {
                line_num = line_num,
                content = discussion_line
              })
            end
          end
          file:close()
        end
        
        return discussions
      end

      -- Function to add Asana task with proper formatting
      local function add_asana_task(tasks_table, callback)
        vim.ui.input({
          prompt = "Asana task URL: ",
        }, function(url)
          if not url or url == "" then
            -- If no URL provided, go to callback
            if callback then callback() end
            return
          end
          
          -- Now ask for the task name/description
          vim.ui.input({
            prompt = "Task name/description: ",
          }, function(name)
            if not name or name == "" then
              name = "Asana Task"  -- Default name if not provided
            end
            
            -- Create a formatted markdown link
            local task_link = string.format("- [%s](%s)", name, url)
            table.insert(tasks_table, task_link)
            
            -- Ask if the user wants to add another task
            vim.ui.select(
              {"Yes", "No"},
              {
                prompt = "Add another Asana task?",
              },
              function(choice)
                if choice == "Yes" then
                  add_asana_task(tasks_table, callback)
                else
                  -- User is done adding tasks, call callback
                  if callback then callback() end
                end
              end
            )
          end)
        end)
      end

      -- Function to generate the PR template
      local function generate_pr_template(target_branch)
        local commits = get_commits(target_branch)
        local changed_files = get_changed_files(target_branch)
        
        -- Create the template
        local template = {}
        
        -- What's new section with commit history
        table.insert(template, "## What's new?")
        table.insert(template, "")
      
        -- Asana Tasks section - we'll collect tasks first
        local asana_tasks = {}
        
        -- Function to create PR description once we have tasks
        local function continue_with_pr_template()
          table.insert(template, "## Asana Tasks")
          table.insert(template, "")
          
          if #asana_tasks > 0 then
            for _, task in ipairs(asana_tasks) do
              table.insert(template, task)
            end
          else
            table.insert(template, "_TODO: Provide link(s) to related Asana tasks_")
          end
          table.insert(template, "")
      
        -- Overview section
        table.insert(template, "## Overview")
        table.insert(template, "")
        table.insert(template, "_TODO: Provide a high-level overview of the changes in this PR_")
        table.insert(template, "")
        
        -- File Updates section
        table.insert(template, "## File Updates")
        table.insert(template, "")
          
          for _, file in ipairs(changed_files) do
            table.insert(template, "- `" .. file .. "`")
            table.insert(template, "")
            table.insert(template, "")
          end

        
        -- Discussion section
        table.insert(template, "## Discussion")
        table.insert(template, "")
          
          -- Add discussions from files with discussion tags
          local has_discussions = false
          for _, file in ipairs(changed_files) do
            local discussions = find_discussion_tags(file)
            
            if #discussions > 0 then
              has_discussions = true
              table.insert(template, "### `" .. file .. "`")
              table.insert(template, "")
              table.insert(template, "```")
              
              for _, disc in ipairs(discussions) do
                table.insert(template, "Line " .. disc.line_num .. ": " .. disc.content)
              end
              
              table.insert(template, "```")
              table.insert(template, "")
            end
          end
          
          if not has_discussions then
            table.insert(template, "_No discussion tags found. Add `@pr_discussion_tag` to the end of any line in your code to include it here._")
            table.insert(template, "")
          end
          
        -- Commit History section
        table.insert(template, "### Commit History")
        table.insert(template, "")
        table.insert(template, commits)
        table.insert(template, "")
      
        -- Create a new buffer in a new tab for the PR description
          vim.cmd("tabnew")
          vim.cmd("setlocal filetype=markdown")
          vim.cmd("setlocal buftype=")
          vim.cmd("file PR_DESCRIPTION.md")
          
          -- Set the buffer content to the template
          local lines = {}
          for line in string.gmatch(table.concat(template, "\n"), "[^\n]+") do
            table.insert(lines, line)
          end
          vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
          
          -- Set cursor to the PR title
          vim.api.nvim_win_set_cursor(0, {1, 0})
          
          -- Make sure this buffer has focus
          vim.cmd("normal! zz")
        end
        
        -- Ask if user wants to add Asana tasks
        vim.ui.select(
          {"Yes", "No"},
          {
            prompt = "Would you like to add Asana tasks?",
          },
          function(choice)
            if choice == "Yes" then
              -- Pass the continue function as a callback to be called when all tasks are added
              add_asana_task(asana_tasks, continue_with_pr_template)
            else
              continue_with_pr_template()
            end
          end
        )
        
        return "" -- We're handling everything asynchronously
      end

function getFileExtension(filename) --@pr_discussion_tag this functoin is sus fr. Maybe delete or something or put it in a new branch or whatever who cares
    -- Match the last period and any characters that follow it until the end of the string
    local extension = string.match(filename, "%.([^%.]+)$")
    
    -- If an extension was found, return it with the dot
    if extension then
        return "." .. extension
    else
        -- Return empty string if no extension was found
        return ""
    end
  end


      -- Function to clean up discussion tags from all files
       function cleanup_discussion_tags()
        local changed_files = get_changed_files()
        local files_changed = 0
        
        for _, file in ipairs(changed_files) do
          local file_content = ""
          local file_handle = io.open(file, "r")
          local file_type = io.type

          if file_handle then
            file_content = file_handle:read("*a")
            file_handle:close()
            

            -- Remove --@pr_discussion_tag from the file
                -- add functionality to check for any type of comment so that it deletes the entire thing. For now, just do SQL
            local new_content = file_content:gsub("--@pr_discussion_tag", "")
            
            if new_content ~= file_content then
              files_changed = files_changed + 1
              local write_handle = io.open(file, "w")
              if write_handle then
                write_handle:write(new_content)
                write_handle:close()
              end
            end
          end
        end
        
        return files_changed
      end

      -- Create PR description function (main entry point)
       function create_pr_description()
        -- Get the target branch (default to main)
        vim.ui.input({
          prompt = "Target branch (default: main): ",
        }, function(input)
          local target_branch = input or "main"
          
          -- Generate PR template
          generate_pr_template(target_branch)
        end)
      end

      -- Clean up discussion tags
       function cleanup_discussion_tags_cmd()
        local files_changed = cleanup_discussion_tags()
        
        if files_changed > 0 then
          vim.notify("Cleaned up discussion tags in " .. files_changed .. " files", vim.log.levels.INFO)
        else
          vim.notify("No discussion tags found to clean up", vim.log.levels.INFO)
        end
      end

      -- Register commands (similar to your FloatTerminal)
      vim.api.nvim_create_user_command("PRCreateDesc", create_pr_description, {})
      vim.api.nvim_create_user_command("PRCleanupTags", cleanup_discussion_tags_cmd, {})
      
      -- You can optionally add keymaps here too
      vim.keymap.set("n", "<leader>PRD", create_pr_description, { desc = "Create [P][R] [D]escription" })
      vim.keymap.set("n", "<leader>CDT", cleanup_discussion_tags_cmd, { desc = "[C]leanup [D]iscussion [T]ags" })
end

-- Expose our module
return M
