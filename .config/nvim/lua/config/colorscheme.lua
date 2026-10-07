return {
  -- Iceberg プラグインの追加
  {
    "oahlen/iceberg.nvim",
    lazy = false,
    priority = 1000,
  },
  -- LazyVim のカラースキームを iceberg に設定
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "iceberg",
    },
  },
}

