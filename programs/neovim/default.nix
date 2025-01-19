{ pkgs, ... }: 

let
	treesitterWithGrammars = (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
		p.bash
		p.comment
		p.css
		p.dockerfile
		p.fish
		p.gitattributes
		p.gitignore
		p.go
		p.gomod
		p.gowork
		p.hcl
		p.javascript
		p.jq
		p.json5
		p.json
		p.lua
		p.make
		p.markdown
		p.c
		p.cpp
		p.nix
		p.python
		p.rust
		p.toml
		p.typescript
		p.vue
		p.yaml
	]));
	treesitter-parsers = pkgs.symlinkJoin {
		name = "treesitter-parsers";
		paths = treesitterWithGrammars.dependencies;
	};
in
{
	home.packages = with pkgs; [
		ripgrep
		fzf

		ols
		lua-language-server
		rust-analyzer-unwrapped
	];

	programs.neovim = {
		enable = true;
		viAlias = true;
		vimAlias = true;
		vimdiffAlias = true;
		withNodeJs = true;
		defaultEditor = true;
		coc.enable = false;

		plugins = [
			treesitterWithGrammars
			pkgs.vimPlugins.blink-cmp
		];
	};

	home.file.".config/nvim/" = {
		source = ./nvim;
		recursive = true;
	};

	home.file.".config/nvim/init.lua".text = ''
	require 'slendi'
	vim.opt.rtp:append('${treesitter-parsers}')
	'';

	home.file.".local/share/nvim/nix/nvim-treesitter/" = {
		recursive = true;
		source = treesitterWithGrammars;
	};
}

