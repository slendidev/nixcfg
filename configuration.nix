# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, inputs, ... }:

{
	imports =
		[ # Include the results of the hardware scan.
			./hardware-configuration.nix
			./gpu.nix
			./cachix.nix
		];

	hardware.nvidia-container-toolkit.enable = true;
	hardware.bluetooth.enable = true;
	hardware.bluetooth.powerOnBoot = true;

	nix.settings = {
		max-jobs = 2;
		#max-jobs = 1;
		cores = 14;
		#cores = 8;
		experimental-features = [ "nix-command" "flakes" ];
	};

	xdg.portal = {
		enable = true;
		wlr.enable = true;
	};

	nix.gc = {
		automatic = true;
		options = "--delete-older-than 30d";
	};
	nix.optimise.automatic = true;

	nixpkgs.config.channel = "nixos-unstable";
	nixpkgs.config.allowUnfree = true;
	nixpkgs.config.allowUnfreePredicate = _: true;
	nixpkgs.config.cudaSupport = true;

	# TODO: Re-enable when this issue is closed: https://github.com/NixOS/nixpkgs/issues/392841
	# virtualisation.vmware.host.enable = true;

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	boot.blacklistedKernelModules = [ "nouveau" ];
	boot.initrd.kernelModules = [ "btusb" ];
	boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
	boot.kernel.sysctl."kernel.sysrq" = 1;

	boot.supportedFilesystems = [ "ntfs" ];
	boot.kernelModules = [ "v4l2loopback" ];
	boot.extraModulePackages = [
		config.boot.kernelPackages.v4l2loopback
	];

	networking.hostName = "navi"; # Define your hostname.
	networking.networkmanager.enable = true;
	networking.extraHosts = "0.0.0.0		master.binary.ninja";

	time.timeZone = "Europe/Bucharest";

	programs.virt-manager.enable = true;
	virtualisation.libvirtd.enable = true;
	virtualisation.libvirtd.qemu.swtpm.enable = true;
	virtualisation.spiceUSBRedirection.enable = true;

	# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";
	# console = {
	#	 font = "Lat2-Terminus16";
	#	 keyMap = "us";
	#	 useXkbConfig = true; # use xkb.options in tty.
	# };

	programs.cfs-zen-tweaks.enable = true;

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

	services.ollama = {
		enable = true;
		acceleration = "cuda";
	};

	services.journald.extraConfig = ''
		SystemMaxUse=2G
	'';

	services.avahi = {
		publish = {
			enable = true;
			userServices = true;
		};
		enable = true;
	};
	services.printing.enable = true;
	services.printing.drivers = with pkgs; [
		hplip
		hplipWithPlugin
	];

	services.samba = {
		enable = true;
		securityType = "user";
		openFirewall = true;

		shares = {
			public = {
				path					 = "/home/public";
				readOnly			 = false;
				browseable		 = true;
				guestOk				= true;
				createMask		 = "0644";
				directoryMask	= "0755";
			};
		};

		settings = {
			global = {
				"workgroup"		= "WORKGROUP";
				"server string" = "mySambaServer";
				"security"			= "user";
				"map to guest"	= "Bad User";
			};
		};
	};

	services.openssh = {
		enable = true;
		ports = [ 22 ];
		settings = {
			PermitRootLogin = "prohibit-password";
		};
	};

	programs.adb.enable = true;
	services.udev.packages = [
		pkgs.android-udev-rules
	];

	services.lorri.enable = true;
	services.blueman.enable = true;

	services.pipewire = {
		enable = true;
		pulse.enable = true;
		jack.enable = true;
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
		extraConfig = ''
set -g default-terminal "screen-256color"
'';
	};

	users.users.lain = {
		isNormalUser = true;
		extraGroups = [ "wheel" "input" "dialout" "docker" "audio" "libvirtd" "adbusers" ];
		shell = pkgs.zsh;
	};

	nixpkgs.overlays = [
		inputs.polymc.overlay
		inputs.nixgl.overlay
		(
			final: prev:
			let
				finalAttrs = final.vmware-workstation;
				version = "17.6.1";
				build = "24319023";
				baseUrl = "https://web.archive.org/web/20241105192443if_/https://softwareupdate.vmware.com/cds/vmw-desktop/ws/${version}/${build}/linux";
				vmware-unpack-env = prev.buildFHSEnv {
					pname = "vmware-unpack-env";
					inherit version;
					targetPkgs = pkgs: [ pkgs.zlib ];
				};
			in
			{
				vmware-workstation = prev.vmware-workstation.overrideAttrs {
					src =
						prev.fetchzip {
							url = "${baseUrl}/core/VMware-Workstation-${version}-${build}.x86_64.bundle.tar";
							hash = "sha256-VzfiIawBDz0f1w3eynivW41Pn4SqvYf/8o9q14hln4s=";
							stripRoot = false;
						}
						+ "/VMware-Workstation-${version}-${build}.x86_64.bundle";
					unpackPhase = ''
						${vmware-unpack-env}/bin/vmware-unpack-env -c "sh ${finalAttrs.src} --extract unpacked"
					'';
				};
			}
		)
	];
	
	environment.systemPackages = with pkgs; [
		qemu
		quickemu
		swtpm

		gamemode

		distrobox
		nvidia-container-toolkit
		cachix

		libnotify
		hyprnotify

		shairport-sync

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

		inputs.hyprland-qtutils.packages.${pkgs.system}.default
		inputs.hyprpolkitagent.packages.${pkgs.system}.default
		kdePackages.qqc2-desktop-style

		wofi
		wpaperd
		hyprshot
		open-vm-tools

		man-pages
		man-pages-posix

		wineWowPackages.stable
		wine
		(wine.override { wineBuild = "wine64"; })
		wine64
		wineWowPackages.staging
		winetricks

		vmware-workstation

		koboldcpp
	];

	fonts.packages = with pkgs; [
		noto-fonts
		noto-fonts-cjk-sans
		noto-fonts-emoji
		liberation_ttf
		fira-code
		fira-code-symbols
		dina-font
		proggyfonts
	];

	documentation.dev.enable = true;

	environment.variables = {
		EDITOR = "nvim";
		IBUS_ENABLE_SYNC_MODE = "1";
	};

	networking.firewall = {
		enable = false;
		#allowedTCPPorts = [ 3689 5000 7000 ] ++ (builtins.genList (x: 32768 + x) (60999 - 32768 + 1));
		#allowedUDPPorts = [ 319 320 5353 6000 6001 6002 6003 6004 6005 6006 6007 6008 6009 ] ++ (builtins.genList (x: 32768 + x) (60999 - 32768 + 1));
	};

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

