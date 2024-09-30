{ config, ... }: {
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;

		shellAliases = {
			cd = "z";
			ls = "eza";
			ll = "eza -l";
			gc = "git commit -svS";
			gs = "git status";
			"gc!" = "git commit --amend";
			gcld = "git clone --depth 1 --recurse --recursive-submodules";
			gcl = "git clone --recurse";
			gl = "git log";
			gd = "git diff";
			gds = "git diff --staged";
			upd = "sudo nixos-rebuild switch";
		};
		history = {
			size = 10000;
			path = "${config.xdg.dataHome}/zsh/history";
		};
		zplug = {
			enable = true;
			plugins = [
				{ name = "zsh-users/zsh-autosuggestions"; }
				{ name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
			];
		};
		initExtra = ''
		bindkey -v
		bindkey '^R' history-incremental-search-backward
		source ~/.p10k.zsh
		eval "$(direnv hook zsh)"

		export LESS_TERMCAP_mb=$'\e[1;32m'
		export LESS_TERMCAP_md=$'\e[1;32m'
		export LESS_TERMCAP_me=$'\e[0m'
		export LESS_TERMCAP_se=$'\e[0m'
		export LESS_TERMCAP_so=$'\e[01;33m'
		export LESS_TERMCAP_ue=$'\e[0m'
		export LESS_TERMCAP_us=$'\e[1;4;31m'

		gsudo='sudo git -c "include.path='"''${XDG_CONFIG_DIR:-$HOME/.config}/git/config\" -c \"include.path=$HOME/.gitconfig\""
		'';
	};
	programs.zoxide = {
		enable = true;
		enableBashIntegration = true;
		enableZshIntegration = true;
	};
}

