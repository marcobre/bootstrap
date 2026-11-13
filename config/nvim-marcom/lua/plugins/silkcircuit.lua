-- SilkCircuit Glow (https://github.com/hyperb1iss/silkcircuit, MIT), same as nvim-lazyvim.
return {
  "hyperb1iss/silkcircuit",
  lazy = false,
  priority = 1000,
  opts = { variant = "glow" },
  config = function(_, opts)
    require("silkcircuit").setup(opts)
    vim.cmd.colorscheme("silkcircuit")
  end,
}
