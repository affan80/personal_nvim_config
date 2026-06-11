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
  vim.cmd("enew") -- Open a new empty buffer in the runner window
  M.last_term_buf = vim.api.nvim_get_current_buf()
  
  -- Run the command
  vim.fn.termopen(cmd)
  
  -- Automatically enter insert mode
  vim.cmd("startinsert")
end

return M
