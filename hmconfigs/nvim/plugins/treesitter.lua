-- local p = require("nvim-treesitter.configs")
--
-- p.setup({
-- 	highlight = {
-- 		enable = true,
-- 	},
-- })
require('nvim-treesitter').setup {
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  -- install_dir = vim.fn.stdpath('data') .. '/site'
} 
