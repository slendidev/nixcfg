{ config, pkgs, ... }: {
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;

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
		setopt AUTO_CD
		bindkey -v
		bindkey '^R' history-incremental-search-backward
		source ~/.p10k.zsh
		eval "$(direnv hook zsh)"

		alias cd="z"
		alias ls="eza"
		alias ll="eza -l"
		alias gc="git commit -svS"
		alias gp="git push"
		alias gpf="git push --force-with-lease"
		alias ga="git add"
		alias gs="git status"
		alias "gc!"="git commit --amend"
		alias gcld="git clone --depth 1 --recursive --shallow-submodules"
		alias gcl="git clone --recurse --shallow-submodules"
		alias gl="git pull --rebase"
		alias glo="git log"
		alias gd="git diff"
		alias gds="git diff --staged"
		alias upd="sudo nixos-rebuild switch"
		alias grep="rg"
		alias open="xdg-open"
		alias s="kitten ssh"

		nix() {
			if [[ $1 == "develop" ]]; then
				shift
				command nix develop -c $SHELL "$@"
			else
				command nix "$@"
			fi
		}

		export LESS_TERMCAP_mb=$'\e[1;32m'
		export LESS_TERMCAP_md=$'\e[1;32m'
		export LESS_TERMCAP_me=$'\e[0m'
		export LESS_TERMCAP_se=$'\e[0m'
		export LESS_TERMCAP_so=$'\e[01;33m'
		export LESS_TERMCAP_ue=$'\e[0m'
		export LESS_TERMCAP_us=$'\e[1;4;31m'

		export LD_LIBRARY_PATH="${pkgs.libGL}/lib/:$LD_LIBRARY_PATH"
		export PATH="$HOME/.local/bin:$PATH"

		export QT_IM_MODULE=fcitx
		export XMODIFIERS=@im=fcitx

		alias gsudo='sudo git -c "include.path=''${XDG_CONFIG_DIR:-$HOME/.config}/git/config" -c "include.path=$HOME/.gitconfig"'

		if [[ ! -f ~/.ssh/id_ed25519 ]]; then
			echo "SSH key not found. Generating a new one..."
			ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
		fi
		'';
	};
	programs.zoxide = {
		enable = true;
		enableBashIntegration = true;
		enableZshIntegration = true;
	};
}

