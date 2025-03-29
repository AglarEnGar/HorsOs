local oil = require('oil')

oil.setup({
  skip_confirm_for_simple_edits = true,
  watch_for_changes = true,
  view_options = {
    show_hidden = true,
  },
  float = {
    max_width = 90,
    max_height = 30,
    border = "single",
  },
  use_default_keymaps = true,
  keymaps = {
    ["q"] = { "actions.close", mode = "n" },
  },
})

vim.keymap.set("n", "<Leader>`", "<Cmd>Oil --float<CR>", { desc = "Open file manager" })
