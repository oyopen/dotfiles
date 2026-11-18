return {
  {
    "dstein64/nvim-scrollview",
    event = "VeryLazy",
    dependencies = { "lewis6991/gitsigns.nvim" },
    opts = {
      excluded_filetypes = { "snacks_dashboard", "snacks_picker_input", "snacks_picker_list" },
      signs_on_startup = { "diagnostics" },
      diagnostics_severities = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN },
    },
    config = function(_, opts)
      require("scrollview").setup(opts)
      require("scrollview.contrib.gitsigns").setup()
    end,
  },
}
