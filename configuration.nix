# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }: {
	imports =
		[ # Include the results of the hardware scan.
			./hardware-configuration.nix
			./gpu.nix
		];

	hardware.bluetooth.enable = true;
	hardware.bluetooth.powerOnBoot = true;

	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 30d";
	};

	nixpkgs.config.allowUnfree = true;
	nixpkgs.config.allowUnfreePredicate = _: true;

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	boot.blacklistedKernelModules = [ "nouveau" ];

	networking.hostName = "navi"; # Define your hostname.
	networking.networkmanager.enable = true;

	time.timeZone = "Europe/Bucharest";

	# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";
	# console = {
	#	 font = "Lat2-Terminus16";
	#	 keyMap = "us";
	#	 useXkbConfig = true; # use xkb.options in tty.
	# };

	programs.hyprland.enable = true;
	programs.hyprland.xwayland.enable = true;
	programs.hyprland.systemd.setPath.enable = true;

	services.printing.enable = true;
	services.printing.drivers = with pkgs; [
		hplip
		hplipWithPlugin
	];

	services.lorri.enable = true;
	services.blueman.enable = true;

	services.pipewire = {
		enable = true;
		pulse.enable = true;
	};

	# Enable touchpad support (enabled default in most desktopManager).
	services.libinput.enable = true;

	programs.zsh.enable = true;
	users.users.lain = {
		isNormalUser = true;
		extraGroups = [ "wheel" "input" ];
		shell = pkgs.zsh;
	};

	nixpkgs.overlays = [
		inputs.polymc.overlay
	];

	environment.systemPackages = with pkgs; [
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
	];

	documentation.dev.enable = true;

	environment.variables.EDITOR = "nvim";

	networking.firewall.enable = true;
	networking.firewall.allowedTCPPorts = [ ];
	networking.firewall.allowedUDPPorts = [ ];

	virtualisation.waydroid.enable = true;

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

