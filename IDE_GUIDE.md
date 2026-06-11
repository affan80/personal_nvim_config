# Neovim IDE Guide

Your Neovim has been transformed into a full-featured IDE with support for React, TypeScript, Next.js, and more.

## 🚀 Code Runner
Run the current file or project with a single keybinding.
- `<leader>rr`: **Run current file/project.**
  - If a `package.json` is detected (React/Next.js), it will prompt you to select a script (`npm start`, `npm run dev`, etc.).
  - For single files (Python, JS, TS, Rust), it runs them directly in a split terminal.

## 🐞 Debugger (DAP)
Full debugging support for JavaScript, TypeScript, and Python.
- `<leader>db`: Toggle Breakpoint
- `<leader>dc`: Continue / Start Debugging
- `<leader>di`: Step Into
- `<leader>do`: Step Over
- `<leader>dt`: Terminate Session
- `<leader>du`: Toggle Debug UI (Panels)
- `<leader>dr`: Open REPL

## 💻 LSP & IntelliSense
Powered by Mason, providing auto-completion, linting, and formatting.
- **Auto-completion:** Use `<Tab>` and `<S-Tab>` to navigate suggestions, and `<CR>` (Enter) to confirm.
- **Format on Save:** Automatically formats JS, TS, JSX, TSX, and JSON files on save.
- **Supported Languages:** TypeScript, React, Next.js, Tailwind CSS, HTML, CSS, JSON, Lua, Python.

## 📂 Navigation & UI
- `<leader>e`: Toggle Neo-tree (File Explorer)
- `<leader>ff`: Find Files (Telescope)
- `<leader>fg`: Live Grep (Search through code)
- `<leader>tt`: Toggle Floating Terminal
- `L` / `H`: Navigate through open buffers (Tabs)
- `<leader>gb`: Git Blame

## 🛠️ Editing Utilities
- **Autopairs:** Automatically closes brackets and quotes.
- **Commenting:** Use `gcc` to comment a line or `gc` in visual mode to comment a block.
- **Treesitter:** Advanced syntax highlighting and indentation.

## 📦 Plugin Management
Plugins are managed by `lazy.nvim`. Configuration is split into:
- `init.lua`: Main settings and keymaps.
- `lua/plugins/`: Individual plugin configurations.
- `lua/run.lua`: The intelligent code runner logic.
