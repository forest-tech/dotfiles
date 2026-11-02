-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- ftplugin でインデント幅が上書きされても 2 スペースに戻す
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("indent_2", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "make" or vim.bo.filetype == "go" then
      return -- タブ必須の言語はそのまま
    end
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true
  end,
})
