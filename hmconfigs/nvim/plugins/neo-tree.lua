local nt = require("neo-tree.command")
local wk = require("which-key")

-- require("neo-tree").setup({
-- 	filesystem = {
-- 		window = {
-- 			hijack_netrw_behavior = "open_current"
-- 		}
-- 	}
-- })

wk.add({
  {
    "<leader>fe",
    function()
      nt.execute({ toggle = true, dir = vim.uv.cwd() })
    end,
    desc = "Explorer NeoTree",
  },
  { "<leader>e", "<leader>fe", desc = "Explorer NeoTree", remap = true },
  {
    "<leader>ge",
    function()
      nt.execute({ source = "git_status", toggle = true })
    end,
    desc = "Git Explorer",
  },
  {
    "<leader>be",
    function()
      nt.execute({ source = "buffers", toggle = true })
    end,
    desc = "Buffer Explorer",
  },
})
