{ config, pkgs, blast, system, ... } :
{
	home.username = "lain";
	home.homeDirectory = "/home/lain";

	i18n.inputMethod = {
		enabled = "fcitx5";
		#fcitx5.waylandFrontend = true;
		fcitx5.addons = with pkgs; [
			fcitx5-anthy
			fcitx5-gtk
			fcitx5-material-color
		];
	};

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

	programs.mpv = {
		enable = true;
		scripts = [
			pkgs.mpvScripts.mpris
		];
	};

	home.packages = with pkgs; [
		(pkgs.python312.withPackages (ppkgs: [
			ppkgs.numpy
			ppkgs.ipython
			ppkgs.pyzmq
			ppkgs.pyserial
		]))
		unityhub
		openseeface
		lorien

		qpwgraph

		direnv
		steamcmd
		ryujinx
		gzdoom
		r2modman

		monero-gui
		tor-browser-bundle-bin

		libreoffice
		qbittorrent

		#lmms
		#surge
		#vital
		#helm
		#calf
		#noise-repellent
		#drumgizmo
		#bespokesynth
		#yabridge

		fastfetch

		ripgrep
		jq
		zoxide
		eza
		hut
		calc
		tokei

		ani-cli
		yt-dlp

		zathura

		handbrake
		ffmpeg
		audacity
		(pkgs.wrapOBS { plugins = [ pkgs.obs-studio-plugins.wlrobs pkgs.obs-studio-plugins.obs-vkcapture ]; })

		arduino-cli
		gf

		btop
		htop

		wl-clipboard
		playerctl
		pamixer
		cli-visualizer

		easyeffects
		pavucontrol
		helvum
		nautilus
		nautilus-python
		sushi
		nautilus-open-any-terminal
		ffmpegthumbnailer

		nextcloud-client
		keepassxc
		inkscape
		goofcord
		weechat

		prismlauncher

		thunderbird
		blender
		krita
		kicad

		texliveFull

		kdePackages.xwaylandvideobridge

		qzdl
		gzdoom

		blast.packages."${system}".blast

		(let
			renderdocWithWayland = renderdoc.overrideAttrs (oldAttrs: {
				waylandSupport = true;
			});
		in
			renderdocWithWayland)
	];

	home.file.".config/nixpkgs/config.nix".text = ''
{
	allowUnfree = true;
}'';

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

	services.swayosd = {
		enable = true;
		stylePath = ./programs/swayosd.css;
	};

	wayland.windowManager.hyprland = {
		enable = true;
		xwayland.enable = true;
		extraConfig = builtins.readFile ./programs/hyprland.conf;
	};

	home.stateVersion = "24.05";

	programs.home-manager.enable = true;
}
