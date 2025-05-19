local p = require('nvim-treesitter.configs')

p.setup {
	sync_install = false,
	auto_install = true,
	highlight = {

		enable = true,
		additional_vim_regex_highlighting = false,
	},
}

