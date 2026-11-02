return {

  -- Default colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "iceberg",
    },
  },

  -- Iceberg
  {
    "cocopon/iceberg.vim",
    lazy = false,
    priority = 1000,
  },

  -- Kanagawa
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
  },
}
