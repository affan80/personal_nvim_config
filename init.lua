vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

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

vim.keymap.set("n", "<leader>gb", ":Gitsigns blame_line<CR>")
vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>")
vim.keymap.set("n", "<leader>gr", ":Gitsigns reset_hunk<CR>")

-- vim.keymap.set("n", "<leader>e", ":Ex<CR>")	-- Extended
vim.keymap.set("n", "<leader>w", ":w<CR>")	-- Save code
vim.keymap.set("n", "<leader>wq", ":wq<CR>")	-- Save & qiut  
vim.keymap.set("n", "<leader>q", ":q<CR>") 	-- quit
vim.keymap.set("n", "<leader>so", ":so<CR>")  	-- Sorce code
vim.keymap.set("n", "<leader>tr", ":term<CR>") 	-- Open terminal

-- Horizontal split
vim.keymap.set("n", "<leader>-", "<cmd>split<CR>")
vim.keymap.set("n", "<leader>sd", "<cmd>split<CR>")

-- Vertical split
vim.keymap.set("n", "<leader>sr", "<cmd>vsplit<CR>")
vim.keymap.set("n", "<leader>|", "<cmd>vsplit<CR>")

-- Moveing betweent window
vim.keymap.set("n", "<leader>wl", "<C-w>l")
vim.keymap.set("n", "<leader>wk", "<C-w>k")
vim.keymap.set("n", "<leader>wh", "<C-w>h")
vim.keymap.set("n", "<leader>wj", "<C-w>j")


-- Window Size
vim.keymap.set("n", "<leader>w-", "<C-w>-",{remap = true})
vim.keymap.set("n", "<leader>w=", "<C-w>=",{remap = true})

-- Neo-tree 
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>")

-- Terminal
vim.keymap.set("n", "<leader>t", ":ToggleTerm<CR>")
vim.keymap.set("n", "<leader>tf", ":ToggleTerm direction=float<CR>")
vim.keymap.set("n", "<leader>th", ":ToggleTerm direction=horizontal<CR>")
vim.keymap.set("n", "<leader>tv", ":ToggleTerm direction=vertical<CR>")

--Telescope 
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")

--- save and lazy sync
vim.keymap.set("n", "<leader>lS", ":w | Lazy sync<CR>", { desc = "Save & Lazy sync" })

-- Source file (save + reload)
vim.keymap.set("n", "<leader>so", ":w | source %<CR>")

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.json" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- jupiter keymap
vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>", { desc = "Molten Init" })
vim.keymap.set("n", "<leader>rr", ":MoltenEvaluateOperator<CR>", { desc = "Run Operator" })
vim.keymap.set("v", "<leader>m", ":MoltenEvaluateVisual<CR>", { desc = "Run Visual" })
vim.keymap.set("n", "<leader>rc", ":MoltenEvaluateLine<CR>", { desc = "Run Line" })
vim.keymap.set("n", "<leader>ro", ":MoltenOpenOutput<CR>", { desc = "Open Output" })
vim.keymap.set("n", "<leader>rd", ":MoltenDelete<CR>", { desc = "Delete Cell" })


-- command to run pythosn nvimg
vim.g.python3_host_prog = vim.fn.expand("~/.config/nvim/venv/bin/python")

