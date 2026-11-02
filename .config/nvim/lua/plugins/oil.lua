return {
  -- Neo-treeを無効化（LazyVimのデフォルトファイルツリー）
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },

  -- oil.nvimプラグインを追加
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      {
        "<leader>e",
        function()
          require("oil").open()
        end,
        desc = "Open parent directory",
      },
    },
    opts = {},
  },
}
