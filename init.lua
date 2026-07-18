-- Encoding settings
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = "utf-8,ucs-bom,latin1"

-- Set mapleader BEFORE lazy loads
vim.g.mapleader = " "

-- Version check
if vim.fn.has("nvim-0.9") == 0 then
  vim.api.nvim_err_writeln("Neovim 0.9+ required")
  return
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  if vim.fn.executable("git") == 1 then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  else
    vim.api.nvim_err_writeln("Git is required. Please install Git.")
    return
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
})

-- Basic editor settings
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamed"


vim.keymap.set("n", "<leader>cc", ":CopilotChatToggle<CR>", { noremap = true })
vim.keymap.set("v", "<leader>cc", ":CopilotChatToggle<CR>", { noremap = true })
