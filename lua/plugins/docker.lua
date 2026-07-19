return {
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>D",
      function() Snacks.terminal.open("lazydocker") end,
      desc = "Docker (lazydocker)",
    },
    {
      "<leader>k",
      function() Snacks.terminal.open("k9s") end,
      desc = "Kubernetes (k9s)",
    },
  },
}
