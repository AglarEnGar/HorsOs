local lsp = require('lspconfig')

local servers = {
  nixd = {
    cmd = {"nixd"},
    settings = {
      nixd = {
        formatting = { command = { "alejandra" } },
      },
    },
  },
  ccls = {},
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
        format = {
          enable = false,
        },
      },
    },
  },
	pyright = {},
	ts_ls = {
		init_options = {
			preferences = {
				disableSuggestions = true,
			},
		},
		filetypes = {
			"javascript",
			"typescript",
			"javascriptreact",
		},
	},
	biome = {},
}

local default_opts = {
	capabilities = require('cmp_nvim_lsp').default_capabilities(), -- Need nvim-cmp installed for this
  on_attach = function(_, bufnum)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer=bufnum})
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {buffer=bufnum})
    vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, {buffer=bufnum})
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {buffer=bufnum})
		vim.keymap.set({'n', 'v'}, '<leader>i', vim.lsp.buf.code_action, {buffer=bufnum})
    vim.keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>', {buffer=bufnum})
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, {buffer=bufnum})
  end,
}

-- Setup each server with default options
vim.lsp.enable({'nixd', 'ccls', 'lua_ls', 'pyright', 'bashls', 'ts_ls', 'biome', 'omnisharp', 'cmake', 'jdtls'})
--for server, opts in pairs(servers) do
--	vim.lsp.config('*', {
--		vim.tbl_deep_extend("force", default_opts, opts)
--	})
--end

vim.lsp.config('*', {
	capabilities = require('cmp_nvim_lsp').default_capabilities(), -- Need nvim-cmp installed for this
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer=args.buf})
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, {buffer=args.buf})
		vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, {buffer=args.buf})
		if client:supports_method('textDocument/implementation') then
      -- Create a keymap for vim.lsp.buf.implementation ...
			vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {buffer=args.buf})
    end
		vim.keymap.set({'n', 'v'}, '<leader>i', vim.lsp.buf.code_action, {buffer=args.buf})
		vim.keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>', {buffer=args.buf})
		vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, {buffer=args.buf})
  end,
})

--vim.lsp.config('clangd', {
--	filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
--})
vim.lsp.config('nixd', {
	cmd = {"nixd"},
	settings = {
		nixd = {
			formatting = { command = { "alejandra" } },
		},
	},
})
-- vim.lsp.config("ccls", {
--   init_options = {
--     compilationDatabaseDirectory = "build";
--     index = {
--       threads = 0;
--     };
--     clang = {
--       excludeArgs = { "-frounding-math"} ;
--     };
--   }
-- })
vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
			format = {
				enable = false,
			},
		},
	},
})
vim.lsp.config('ts_ls', {
	init_options = {
		preferences = {
			disableSuggestions = true,
		},
	},
	filetypes = {
		"javascript",
		"typescript",
		"javascriptreact",
	},
})
vim.lsp.config('jdlts', {
	cmd = {
		'nix',
		'develop',
		'--command',
		'jdtls',
	},

	init_options = {
		settings = {
			java = {
				imports = {
					gradle = {
						enabled = true,
						wrapper = {
							enabled = true,
							-- Note the nested table here. This is really important.
							-- `checksums` is an array of objects, which in lua translates to a table of tables.
							checksums = {
								{
									sha256 = '7d3a4ac4de1c32b59bc6a4eb8ecb8e612ccd0cf1ae1e99f66902da64df296172',
									allowed = true,
								},
							},
						},
					},
				},
			},
		},
	},
})


-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
--  
-- local servers = { 'clangd' }
-- for _, lsp in ipairs(servers) do
--     nvim_lsp[lsp].setup  {
--         capabilities = capabilities,
--         on_attach = on_attach,
--     }
-- end
