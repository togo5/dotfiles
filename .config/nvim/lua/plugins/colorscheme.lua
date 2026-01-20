return {
  -- Black Metalテーマを追加
  {
    "metalelf0/black-metal-theme-neovim",
    lazy = false,
    priority = 1000,
    config = function()
      require("black-metal").setup({})
    end,
  },

  -- LazyVimのcolorschemeを設定（バンド名を指定）
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "mayhem",
    },
  },
}
