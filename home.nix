{ config, pkgs, blast, system, ... } :
let
	common = import ./common/defaults.nix { inherit pkgs; };
	commonPrograms = import ./common/home-programs.nix;
in
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

	home.packages =
		common.homePackages ++
		(with pkgs; [
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

			zathura

			handbrake
			(pkgs.wrapOBS { plugins = [ pkgs.obs-studio-plugins.wlrobs pkgs.obs-studio-plugins.obs-vkcapture ]; })

			arduino-cli
			gf

			wl-clipboard
			playerctl
			pamixer

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

			bs-manager
			zenity

			thunderbird
			blender
			krita

			texliveFull

			kdePackages.xwaylandvideobridge

			qzdl
			gzdoom

			android-studio

			blast.packages."${system}".blast

			(let
			renderdocWithWayland = renderdoc.overrideAttrs (oldAttrs: {
			waylandSupport = true;
			});
			in
			renderdocWithWayland)
	]);

	home.file.".config/nixpkgs/config.nix".text = ''
{
	allowUnfree = true;
}'';

	home.file.".config/wpaperd/wallpaper.toml".text = ''
[default]
path = "${config.home.homeDirectory}/Pictures/Wallpapers"
sorting = "random"
mode = "center"'';

	programs = commonPrograms // {
		home-manager.enable = true;
		mpv = {
			enable = true;
			scripts = [
				pkgs.mpvScripts.mpris
			];
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
}
