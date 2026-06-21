-- ======================
-- BASIC SETTINGS
-- ======================
vim.g.mapleader = " "

local nvim_venv = vim.fn.expand("~/.config/nvim/venv")
vim.g.python3_host_prog = nvim_venv .. "/bin/python"
vim.env.PATH = nvim_venv .. "/bin:" .. vim.env.PATH

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- ======================
-- CLIPBOARD (Sync with System)
-- ======================
vim.opt.clipboard = "unnamedplus"

-- ======================
-- LAZY.NVIM BOOTSTRAP
-- ======================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")

-- ======================
-- GIT / GITHUB SHORTCUTS
-- ======================
local gs = require("gitsigns")

-- Gitsigns (Hunks)
vim.keymap.set("n", "]c", function()
  if vim.wo.diff then return "]c" end
  vim.schedule(function() gs.next_hunk() end)
  return "<Ignore>"
end, { expr = true, desc = "Next Hunk" })

vim.keymap.set("n", "[c", function()
  if vim.wo.diff then return "[c" end
  vim.schedule(function() gs.prev_hunk() end)
  return "<Ignore>"
end, { expr = true, desc = "Prev Hunk" })

vim.keymap.set("n", "<leader>gs", gs.stage_hunk, { desc = "Stage Hunk" })
vim.keymap.set("n", "<leader>gr", gs.reset_hunk, { desc = "Reset Hunk" })
vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { desc = "Preview Hunk" })
vim.keymap.set("n", "<leader>gb", gs.blame_line, { desc = "Blame Line" })
vim.keymap.set("n", "<leader>gd", gs.diffthis, { desc = "Git Diff" })

-- Fugitive / GitHub
vim.keymap.set("n", "<leader>gg", "<cmd>Git<CR>", { desc = "Git Status" })
vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "Git Commit" })
vim.keymap.set("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "Git Push" })
vim.keymap.set("n", "<leader>gl", "<cmd>Git pull<CR>", { desc = "Git Pull" })
vim.keymap.set("n", "<leader>go", "<cmd>GBrowse<CR>", { desc = "Open on GitHub (Browser)" })
vim.keymap.set("v", "<leader>go", ":'<,'>GBrowse<CR>", { desc = "Open Selection on GitHub" })

-- Git Rollback / Revert
vim.keymap.set("n", "<leader>grv", "<cmd>Git revert HEAD<CR>", { desc = "Revert last commit" })
vim.keymap.set("n", "<leader>grf", "<cmd>Git checkout HEAD -- %<CR>", { desc = "Rollback current file to last commit" })
vim.keymap.set("n", "<leader>glg", "<cmd>Git log --oneline --graph --all<CR>", { desc = "Show Git Log (Graph)" })

-- ======================
-- BASIC COMMANDS
-- ======================
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>")
vim.keymap.set("n", "<leader>wq", "<cmd>wq<CR>")
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>")
vim.keymap.set("n", "<leader>so", "<cmd>w | source %<CR>")

-- ======================
-- WINDOW MANAGEMENT
-- ======================
vim.keymap.set("n", "<leader>-", "<cmd>split<CR>")
vim.keymap.set("n", "<leader>|", "<cmd>vsplit<CR>")

vim.keymap.set("n", "<leader>wh", "<C-w>h")
vim.keymap.set("n", "<leader>wj", "<C-w>j")
vim.keymap.set("n", "<leader>wk", "<C-w>k")
vim.keymap.set("n", "<leader>wl", "<C-w>l")

vim.keymap.set("n", "<leader>w-", "<C-w>-")
vim.keymap.set("n", "<leader>w=", "<C-w>=")

-- ======================
-- FILE TREE
-- ======================
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>")

-- ======================
-- TERMINAL (ToggleTerm – MANUAL ONLY)
-- ======================
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>")
vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>")
vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>")
vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>")

-- ======================
-- TELESCOPE
-- ======================
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")

-- ======================
-- BUFFER NAVIGATION (Tabs)
-- ======================
vim.keymap.set("n", "L", "<cmd>bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "H", "<cmd>bprev<CR>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close Buffer" })

-- ======================
-- RUN CURRENT FILE / PROJECT (Leader + Enter)
-- ======================
vim.keymap.set("n", "<leader><CR>", function()
  require("run").run()
end, { desc = "Run current file/project" })

-- Close run terminal with qq
vim.keymap.set("n", "qq", function()
  local run = require("run")
  if run.last_term_win and vim.api.nvim_win_is_valid(run.last_term_win) then
    vim.api.nvim_win_close(run.last_term_win, true)
    run.last_term_win = nil
  else
    -- Fallback: just close current window if it's a terminal
    if vim.bo.builtin == "terminal" or vim.bo.filetype == "toggleterm" then
      vim.cmd("q")
    end
  end
end, { desc = "Close run terminal" })

-- ======================
-- DEBUGGING (DAP)
-- ======================
vim.keymap.set("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dc", function() require("dap").continue() end, { desc = "Continue / Start Debugging" })
vim.keymap.set("n", "<leader>di", function() require("dap").step_into() end, { desc = "Step Into" })
vim.keymap.set("n", "<leader>do", function() require("dap").step_over() end, { desc = "Step Over" })
vim.keymap.set("n", "<leader>dt", function() require("dap").terminate() end, { desc = "Terminate" })
vim.keymap.set("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Toggle Debug UI" })
vim.keymap.set("n", "<leader>dr", function() require("dap").repl.open() end, { desc = "Open REPL" })

-- ======================
-- RUN TESTS (SAFE)
-- ======================
vim.keymap.set("n", "<leader>rt", function()
  local ok, run = pcall(require, "run")
  if ok and run.test then
    run.test()
  else
    vim.notify("No test runner available", vim.log.levels.WARN)
  end
end, { desc = "Run tests" })

-- ======================
-- FORMAT ON SAVE (SAFE, FUTURE-PROOF)
-- ======================
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.json" },
  callback = function()
    if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
      vim.lsp.buf.format({ async = false })
    end
  end,
})

-- ======================
-- MOLTEN / JUPYTER
-- ======================
vim.keymap.set("n", "<leader>mi", "<cmd>MoltenInit nvim-python<CR>", { desc = "Initialize Python kernel" })
vim.keymap.set("n", "<leader>mI", "<cmd>MoltenInit<CR>", { desc = "Choose kernel" })
vim.keymap.set("n", "<leader>me", "<cmd>MoltenEvaluateOperator<CR>", { desc = "Evaluate operator" })
-- removed <leader>rr conflict
vim.keymap.set("v", "<leader>m", ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "Evaluate visual selection" })
vim.keymap.set("n", "<leader>rc", "<cmd>MoltenEvaluateLine<CR>", { desc = "Evaluate line" })
vim.keymap.set("n", "<leader>rr", "<cmd>MoltenReevaluateCell<CR>", { desc = "Re-evaluate cell" })
vim.keymap.set("n", "<leader>rn", "<cmd>MoltenNext<CR>", { desc = "Next cell" })
vim.keymap.set("n", "<leader>rp", "<cmd>MoltenPrev<CR>", { desc = "Previous cell" })
vim.keymap.set("n", "<leader>ro", "<cmd>MoltenShowOutput<CR>", { desc = "Show output" })
vim.keymap.set("n", "<leader>rh", "<cmd>MoltenHideOutput<CR>", { desc = "Hide output" })
vim.keymap.set("n", "<leader>re", "<cmd>noautocmd MoltenEnterOutput<CR>", { desc = "Enter output" })
vim.keymap.set("n", "<leader>rd", "<cmd>MoltenDelete<CR>", { desc = "Delete cell output" })
vim.keymap.set("n", "<leader>rD", "<cmd>MoltenDelete!<CR>", { desc = "Delete all outputs" })
vim.keymap.set("n", "<leader>rs", "<cmd>MoltenSave<CR>", { desc = "Save outputs" })
vim.keymap.set("n", "<leader>rl", "<cmd>MoltenLoad<CR>", { desc = "Load outputs" })
vim.keymap.set("n", "<leader>rx", "<cmd>MoltenExportOutput<CR>", { desc = "Export notebook output" })
