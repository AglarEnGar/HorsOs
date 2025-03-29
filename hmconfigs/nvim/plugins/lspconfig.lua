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
}

local default_opts = {
  -- capabilities = require('cmp_nvim_lsp').default_capabilities(), -- Need nvim-cmp installed for this
  on_attach = function(_, bufnum)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer=bufnum})
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {buffer=bufnum})
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, {buffer=bufnum})
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {buffer=bufnum})
    vim.keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>', {buffer=bufnum})
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, {buffer=bufnum})
  end,
}

-- Setup each server with default options
for server, opts in pairs(servers) do
  lsp[server].setup(vim.tbl_deep_extend("force", default_opts, opts))
end
