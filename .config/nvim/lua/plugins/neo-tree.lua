return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    default_component_configs = {
      git_status = {
        symbols = {
          added = "A",
          modified = "M",
          deleted = "D",
          renamed = "R",
          untracked = "U",
          ignored = "",
          unstaged = "",
          staged = "",
          conflict = "C",
        },
      },
    },
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        dim_gitignored = true,
      },
    },
  },
}
