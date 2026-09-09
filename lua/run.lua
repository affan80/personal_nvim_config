local M = {}

-- Track last terminal window and buffer
M.last_term_win = nil
M.last_term_buf = nil

-- Filetype → default single-file command
local commands = {
  python = "python3 %",
  javascript = "node %",
  typescript = "ts-node %",
  rust = "cargo run",
  go = "go run %",
  lua = "lua %",
  c = "gcc % -o %< && ./%<",
  cpp = "g++ % -o %< && ./%<",
  java = "javac % && java %<",
  php = "php %",
  ruby = "ruby %",
  sh = "bash %",
  matlab = "matlab -batch \"run('%')\"",
  octave = "octave --no-gui %",
}

function M.run()
  vim.cmd("write")
  local ft = vim.bo.filetype
  local root = vim.fn.getcwd()
  
  -- Check for package.json (Web projects)
  local has_package_json = vim.fn.filereadable(root .. "/package.json") == 1
  
  local cmd = ""
  
  if has_package_json and (ft == "javascript" or ft == "typescript" or ft == "typescriptreact" or ft == "javascriptreact") then
    local choices = {"npm run dev", "npm start", "npm run build", "node " .. vim.fn.expand("%")}
    vim.ui.select(choices, {
      prompt = "Select command to run:",
    }, function(choice)
      if choice then
        M.execute(choice)
      end
    end)
    return
  end

  if ft == "python" then
    local python_bin = vim.g.python3_host_prog or "python3"
    cmd = python_bin .. " " .. vim.fn.expand("%")
  else
    cmd = commands[ft]
  end

  if not cmd or cmd == "" then
    vim.notify("No run command for filetype: " .. ft, vim.log.levels.ERROR)
    return
  end

  local file = vim.fn.expand("%")
  local file_no_ext = vim.fn.expand("%:r")
  cmd = cmd:gsub("%%<", file_no_ext):gsub("%%", file)
  
  M.execute(cmd)
end

local test_commands = {
  python = "pytest -v % ",
  javascript = "npm test",
  typescript = "npm test",
  rust = "cargo test",
  go = "go test ./...",
  lua = "busted %",
}

function M.test()
  local file = vim.fn.expand("%")

  -- Notebooks are not runnable scripts — use molten instead
  if file:match("%.ipynb$") then
    vim.notify("Notebook detected — use <leader>rc (cell) or <leader>ra (all cells)", vim.log.levels.INFO)
    return
  end

  vim.cmd("write")
  local ft = vim.bo.filetype
  local cmd = test_commands[ft]

  if not cmd then
    vim.notify("No test command for filetype: " .. ft, vim.log.levels.WARN)
    return
  end

  -- Python: run pytest on current file; fall back to unittest-style direct run
  if ft == "python" and cmd:match("pytest") then
    local has_pytest = vim.fn.executable("pytest") == 1 or vim.fn.filereadable(vim.fn.getcwd() .. "/pytest.ini") == 1
    if not has_pytest and not file:match("test_") and not file:match("_test") then
      cmd = (vim.g.python3_host_prog or "python3") .. " %"
      vim.notify("Not a test file — running it directly instead", vim.log.levels.INFO)
    end
  end

  M.execute(cmd:gsub("%%", file))
end

function M.execute(cmd)
  -- 1. Check if the runner window already exists and is valid
  if M.last_term_win and vim.api.nvim_win_is_valid(M.last_term_win) then
    vim.api.nvim_set_current_win(M.last_term_win)
  else
    -- 2. Create a new split at the bottom if it doesn't exist
    vim.cmd("botright horizontal 12split")
    M.last_term_win = vim.api.nvim_get_current_win()
    
    -- Set window-local options for IDE feel
    vim.wo.winfixheight = true
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
  end

  -- 3. Clear previous output by starting a fresh terminal in the window
  -- (This prevents the "full screen" jump caused by closing/reopening)
  -- Delete the previous terminal buffer first to avoid leaking buffers
  if M.last_term_buf and vim.api.nvim_buf_is_valid(M.last_term_buf) then
    vim.api.nvim_buf_delete(M.last_term_buf, { force = true })
  end
  vim.cmd("enew") -- Open a new empty buffer in the runner window
  M.last_term_buf = vim.api.nvim_get_current_buf()
  
  -- Run the command (jobstart with term=true replaces deprecated termopen)
  vim.fn.jobstart(cmd, { term = true })
  
  -- Automatically enter insert mode
  vim.cmd("startinsert")
end

-- Cleanup: delete the terminal buffer when the runner window closes
vim.api.nvim_create_autocmd("WinClosed", {
  callback = function(args)
    if M.last_term_win and tonumber(args.match) == M.last_term_win then
      if M.last_term_buf and vim.api.nvim_buf_is_valid(M.last_term_buf) then
        vim.api.nvim_buf_delete(M.last_term_buf, { force = true })
      end
      M.last_term_win = nil
      M.last_term_buf = nil
    end
  end,
})

return M
