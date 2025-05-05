{ config, pkgs, system, ... } :
{
	home.username = "lain";
	home.homeDirectory = "/Users/lain";

	programs.mpv.enable = true;

	home.packages = with pkgs; [
		direnv

		fastfetch

		ripgrep
		jq
		zoxide
		eza
		hut
		calc
		tokei

		weechat

		ani-cli
		yt-dlp

		ffmpeg

		btop
		htop

		prismlauncher
	];

	home.file.".config/nixpkgs/config.nix".text = ''
{
	allowUnfree = true;
}'';
	home.file."config/karabiner/karabiner.json".source = ./karabiner.json;

	home.file.".config/wpaperd/wallpaper.toml".text = ''
[default]
path = "${config.home.homeDirectory}/Pictures/Wallpapers"
sorting = "random"
mode = "center"'';

	programs = {
		git = {
			enable = true;
			userName = "Slendi";
			userEmail = "slendi@socopon.com";
			extraConfig = {
				gpg = {
					format = "ssh";
				};
				user = {
					signingkey = "~/.ssh/id_ed25519.pub";
				};
			};
		};

		kitty = {
			enable = true;
			extraConfig = ''
			background_opacity 0.8
			mouse_hide_wait 0
			default_pointer_shape arrow
			pointer_shape_when_dragging arrow
			confirm_os_window_close 0
			window_padding_width 4
			map ctrl+shift+k clear_terminal scrollback
			cursor_trail 3
			map ctrl+shift+w none
			'';
		};
	};

	imports = [
		./programs/neovim
		./programs/zsh.nix
		./programs/cli-visualizer.nix
	];

	services = {
		skhd = {
			enable = true;
			config = ./skhdrc;
		};
	};

	programs.home-manager.enable = true;

	home.stateVersion = "24.05";
}
