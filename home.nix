{ config, pkgs, ... } : {
	home.username = "lain";
	home.homeDirectory = "/home/lain";

	home.pointerCursor =
		let
			getFrom = url: hash: name: {
				gtk.enable = true;
				x11.enable = true;
				name = name;
				size = 24;
				package =
					pkgs.runCommand "moveUp" {} ''
						mkdir -p $out/share/icons
						ln -s ${pkgs.fetchzip {
							url = url;
							hash = hash;
						}} $out/share/icons/${name}
					'';
			};
		in
			getFrom
				"https://github.com/supermariofps/hatsune-miku-windows-linux-cursors/files/14914322/miku-cursor-linux-1.2.4.zip"
				"sha256-D3vd/F9mo9vXH1qzpnLP8NM0J1kVqPEdmDZoSqN1hMk="
				"MikuCursors";

	gtk = {
		enable = true;

		theme = {
			package = pkgs.flat-remix-gtk;
			name = "Flat-Remix-GTK-Red-Darker";
		};

		iconTheme = {
			package = pkgs.flat-remix-icon-theme;
			name = "Flat-Remix-Red-Darker";
		};
	};

	home.packages = with pkgs; [
		direnv
		steam
		steamPackages.steamcmd

		obs-studio

		fastfetch

		ripgrep
		jq
		zoxide
		eza
		hut

		mpv
		ani-cli

		clang-tools
		gf

		btop
		htop

		wl-clipboard
		playerctl
		pamixer

		easyeffects
		pavucontrol
		nautilus
		nautilus-python
		sushi
		nautilus-open-any-terminal

		nextcloud-client
		keepassxc
		inkscape
		libreoffice
		vesktop
		polymc
		renderdoc
	];

	home.file.".config/wpaperd/wallpaper.toml".text = ''
	[default]
	path = "${config.home.homeDirectory}/Pictures/Wallpapers"
	sorting = "random"
	mode = "center"
	'';

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
			'';
		};
	};

	imports = [
		./programs/neovim
		./programs/zsh.nix
	];

	wayland.windowManager.hyprland = {
		enable = true;
		xwayland.enable = true;
		extraConfig = builtins.readFile ./programs/hyprland.conf;
	};

	home.stateVersion = "24.05";

	programs.home-manager.enable = true;
}
