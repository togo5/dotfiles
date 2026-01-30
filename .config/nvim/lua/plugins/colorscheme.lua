return {
  -- GitHub Darkテーマを追加
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup({
        groups = {
          github_dark_default = {
            -- Neo-tree directory colors (light grayish white with slight purple tint)
            NeoTreeDirectoryIcon = { fg = "#e2e4e8" },
            NeoTreeDirectoryName = { fg = "#e2e4e8" },
            NeoTreeRootName = { fg = "#e2e4e8", style = "bold" },
            NeoTreeExpander = { fg = "#484f58" },
            NeoTreeIndentMarker = { fg = "#30363d" },
            -- Neo-tree git status colors
            NeoTreeGitAdded = { fg = "#3fb950" },
            NeoTreeGitModified = { fg = "#d29922" },
            NeoTreeGitDeleted = { fg = "#f85149" },
            NeoTreeGitRenamed = { fg = "#3fb950" },
            NeoTreeGitUntracked = { fg = "#3fb950" },
            NeoTreeGitIgnored = { fg = "#484f58" },
            NeoTreeGitConflict = { fg = "#f85149", style = "bold" },
            NeoTreeGitUnstaged = { fg = "#d29922" },
            NeoTreeGitStaged = { fg = "#3fb950" },
            NeoTreeDimText = { fg = "#484f58" },
          },
        },
      })
    end,
  },

  -- LazyVimのcolorschemeを設定
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "github_dark_default",
    },
  },
}
