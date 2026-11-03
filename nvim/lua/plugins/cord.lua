return {
  "vyfor/cord.nvim",
  build = ":Cord update",
  event = "VeryLazy", -- loads after startup so it doesn't slow boot
  opts = {},          -- customize here (see below)
}
