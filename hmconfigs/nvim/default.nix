{
  lib,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaConfig = builtins.readFile ./init.lua;

    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile ./plugins/lspconfig.lua;
      }
      # Completions
      {
        plugin = nvim-cmp;
        type = "lua";
        config = builtins.readFile ./plugins/cmp.lua;
      }
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp_luasnip
      luasnip

      comment-nvim

      # Formatting
      {
        plugin = conform-nvim;
        type = "lua";
        config = builtins.readFile ./plugins/conform.lua;
      }
      #
      #	# Editor
      which-key-nvim
      #	nvim-web-devicons
      #	{
      #	  plugin = flash-nvim;
      #	  type = "lua";
      #	  config = builtins.readFile ./plugins/flash-nvim.lua;
      #	}
      {
        plugin = neo-tree-nvim;
        type = "lua";
        config = builtins.readFile ./plugins/neo-tree.lua;
      }
      {
        plugin = oil-nvim;
        type = "lua";
        config = builtins.readFile ./plugins/oil.lua;
      }
      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile ./plugins/telescope.lua;
      }
      {
        plugin = catppuccin-nvim;
        type = "lua";
        config = "vim.cmd.colorscheme 'catppuccin'";
      }
      #	{
      #	  plugin = lualine-nvim;
      #	  type = "lua";
      #	  config = builtins.readFile ./plugins/lualine.lua;
      #}
      # {
      #   plugin = noice-nvim;
      #	  type = "lua";
      #	  config = builtins.readFile ./plugins/noice.lua;
      #	}
      #
      #	# Copilot
      #	{
      #	  plugin = copilot-lua;
      #	  type = "lua";
      #	  config = builtins.readFile ./plugins/copilot.lua;
      #	}
      #	CopilotChat-nvim
      #	plenary-nvim # for CopilotChat-nvim
      #	copilot-lualine
      #
      #
      #	# Misc
      #	vimtex
    ];
    #
    # All the language servers
    extraPackages = with pkgs; [
      lua-language-server

      # Nix
      nixd
      alejandra

      # C, C++
      clang-tools
      cppcheck
      ccls

      # Shell scripting
      shfmt
      shellcheck

      # Telescope dependencies
      ripgrep
      fd
    ];
  };
}
