
local Task = {}

local task_available = function ()
  return vim.fn.executable("task") == 1
end

Task.get_tasks = function()
  if not  task_available() then
    vim.notify("task not installed", vim.log.levels.ERROR)
    return
  end
  local task_list =  {}
  local tasks_result = vim.system({
    "task", "--list-all", "--json", "--sort=default",
  }):wait()
  if tasks_result.code ~= 0 then
    vim.notify("Failed to get tasks", vim.log.levels.ERROR)
    return
  end
  local tasks =  vim.json.decode(tasks_result.stdout)
   for _, value in ipairs(tasks.tasks)  do
    table.insert(task_list, value.name)
  end
  return task_list
end

Task.select = function()
  if not task_available() then
    vim.notify("task not installed", vim.log.levels.ERROR)
    return
  end
  local tasks = Task.get_tasks()
  if not tasks then
    return
  end
  vim.ui.select(
    tasks,
    {
      prompt="Select task to run"
    },
    function(choice)
      if not choice then
        return
      end
      Task.run(choice)
    end
  )
end

Task.run = function(task)
  vim.cmd('botright split')
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(buf)
  local cmd = {'task',  task}
  vim.fn.jobstart(
    cmd,
    {
     term=true,
     on_stdout=function (_, _, _)
       local last_line = vim.api.nvim_buf_line_count(buf)
       vim.api.nvim_win_set_cursor(0, {last_line, 0})
     end
    }
  )

  vim.bo[buf].filetype='terminal'
  vim.bo[buf].bufhidden='wipe'

  vim.keymap.set(
    "n", "<Esc>",
    function ()
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, {force=true})
      end
    end,
    {silent=true, buffer=buf}
  )
  vim.keymap.set(
    "n", "q",
    function ()
     if vim.api.nvim_buf_is_valid(buf) then
       vim.api.nvim_buf_delete(buf, {force=true})
     end
    end
  )
end

Task.setup = function()
  vim.api.nvim_create_user_command('Task',  function(args)
    if #args.fargs > 0 then
      Task.run(args.fargs[1])
      return
    end
    return Task.select()
  end,
  {
    desc='Invoke Task File plugin',
    nargs='?',
    complete=function(arglead, _, _)
      local tasks =  Task.get_tasks()
      if not tasks then
        return
      end
      return vim.tbl_filter(function(name)
        return vim.startswith(name, arglead)
      end, tasks)
    end
  })
end

return Task
