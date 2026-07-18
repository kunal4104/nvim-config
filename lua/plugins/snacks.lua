return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          projects = {
            -- scan sub-folders of these for a .git (etc.) root - covers Documents/GitHub,
            -- Documents/github, and anything else dropped directly under Documents
            dev = { "~/Documents" },
            -- standalone repos that don't live under one of the `dev` parents above
            projects = { "~/AppData/Local/nvim" },
          },
        },
      },
    },
  },
}
