# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
	imports =
		[ # Include the results of the hardware scan.
			./hardware-configuration.nix
			./gpu.nix
		];

	hardware.nvidia-container-toolkit.enable = true;
	hardware.bluetooth.enable = true;
	hardware.bluetooth.powerOnBoot = true;

	nix.settings = {
		max-jobs = 28;
		experimental-features = [ "nix-command" "flakes" ];
	};

	nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 30d";
	};

	nixpkgs.config.channel = "nixos-unstable";
	nixpkgs.config.allowUnfree = true;
	nixpkgs.config.allowUnfreePredicate = _: true;
	nixpkgs.config.cudaSupport = true;

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	boot.blacklistedKernelModules = [ "nouveau" ];
	boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
	boot.kernel.sysctl."kernel.sysrq" = 1;

	boot.supportedFilesystems = [ "ntfs" ];

	networking.hostName = "navi"; # Define your hostname.
	networking.networkmanager.enable = true;

	time.timeZone = "Europe/Bucharest";

	# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";
	i18n.inputMethod = {
		enabled = "fcitx5";
		fcitx5.waylandFrontend = true;
		fcitx5.addons = with pkgs; [
			fcitx5-anthy
			fcitx5-gtk
		];
	};

	# console = {
	#	 font = "Lat2-Terminus16";
	#	 keyMap = "us";
	#	 useXkbConfig = true; # use xkb.options in tty.
	# };

	programs.hyprland.enable = true;
	programs.hyprland.xwayland.enable = true;
	programs.hyprland.systemd.setPath.enable = true;

	programs.steam = {
		enable = true;
		gamescopeSession.enable = true;
		extest.enable = true;
		extraCompatPackages = with pkgs; [
			proton-ge-bin
		];
	};

	programs.kdeconnect.enable = true;

	services.printing.enable = true;
	services.printing.drivers = with pkgs; [
		hplip
		hplipWithPlugin
	];

	services.openssh = {
		enable = true;
		ports = [ 22 ];
		settings = {
			PermitRootLogin = "prohibit-password";
		};
	};

	services.lorri.enable = true;
	services.blueman.enable = true;

	services.pipewire = {
		enable = true;
		pulse.enable = true;
	};

	# Enable touchpad support (enabled default in most desktopManager).
	services.libinput.enable = true;

	services.devmon.enable = true;
	services.gvfs.enable = true; 
	services.udisks2.enable = true;

	programs.zsh.enable = true;
	programs.tmux = {
		enable = true;
		keyMode = "vi";
	};

	users.users.lain = {
		isNormalUser = true;
		extraGroups = [ "wheel" "input" "dialout" "docker" ];
		shell = pkgs.zsh;
	};

	nixpkgs.overlays = [
		inputs.polymc.overlay
	];
	
	environment.systemPackages = with pkgs; [
		distrobox
		nvidia-container-toolkit

		udiskie

		git
		neovim
		curl
		kitty

		p7zip
		xz
		zip
		unzip

		file
		which
		tree
		gawk
		gnused
		gnutar

		dnsutils
		nmap

		strace
		ltrace
		lsof

		sysstat
		lm_sensors
		pciutils
		usbutils

		inputs.zen-browser.packages.${pkgs.system}.default
		inputs.glslcc-flake.packages.${pkgs.system}.default

		wofi
		wpaperd
		hyprshot

		man-pages
		man-pages-posix

		wineWowPackages.stable
		wine
		(wine.override { wineBuild = "wine64"; })
		wine64
		wineWowPackages.staging
		winetricks
	];

	documentation.dev.enable = true;

	environment.variables = {
		EDITOR = "nvim";
		IBUS_ENABLE_SYNC_MODE = "1";
	};

	networking.firewall.enable = true;
	networking.firewall.allowedTCPPorts = [ ];
	networking.firewall.allowedUDPPorts = [ ];

	virtualisation.waydroid.enable = true;
	virtualisation.docker.enable = true;

	# Copy the NixOS configuration file and link it from the resulting system
	# (/run/current-system/configuration.nix). This is useful in case you
	# accidentally delete configuration.nix.
	# system.copySystemConfiguration = true;

	# This option defines the first version of NixOS you have installed on this particular machine,
	# and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
	#
	# Most users should NEVER change this value after the initial install, for any reason,
	# even if you've upgraded your system to a new NixOS release.
	#
	# This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
	# so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
	# to actually do that.
	#
	# This value being lower than the current NixOS release does NOT mean your system is
	# out of date, out of support, or vulnerable.
	#
	# Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
	# and migrated your data accordingly.
	#
	# For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
	system.stateVersion = "24.05"; # Did you read the comment?

}

