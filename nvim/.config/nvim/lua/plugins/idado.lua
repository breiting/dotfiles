return {
  {
    -- dir = "~/workspace/idado.nvim",
    "breiting/idado.nvim",
    config = function()
      local idado = require("idado")
      idado.config.target_path = "~/notes/_assets/"
      idado.config.pattern = "%Y-%m-%d_%H-%M-%S"
    end,
  },
}
