-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

--- 相対行番号と現在の行の絶対行番号を同時に表示
vim.opt.number = true -- 絶対行番号を表示
vim.opt.relativenumber = true -- 相対行番号を有効化

vim.opt.numberwidth = 2 -- 行番号を詰める (default=4)
vim.opt.signcolumn = "auto" -- 行番号の左側にある診断アイコンは必要時のみ

-- インデントは 2 スペース
vim.opt.tabstop = 2 -- タブ幅を2スペースに設定
vim.opt.shiftwidth = 2 -- インデント幅を2スペースに設定
vim.opt.softtabstop = 2 -- <Tab>/<BS> で 2 スペース分動く
vim.opt.expandtab = true -- タブをスペースに変換

-- 保存時に自動フォーマット (conform.nvim / LSP)
vim.g.autoformat = true
-- python などの ftplugin が 4 スペースに上書きしないようにする
vim.g.python_recommended_style = 0
vim.g.rust_recommended_style = 0
