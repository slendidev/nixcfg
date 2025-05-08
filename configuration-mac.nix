{ self, pkgs, ... }:

{
	nix = {
		settings = {
			max-jobs = 2;
			cores = 2;
			experimental-features = [ "nix-command" "flakes" ];
		};
		gc = {
			automatic = true;
			options = "--delete-older-than 30d";
		};
		optimise.automatic = true;
	};

	nixpkgs.config.channel = "nixos-unstable";
	nixpkgs.config.allowUnfree = true;
	nixpkgs.config.allowUnfreePredicate = _: true;
	nixpkgs.hostPlatform = "aarch64-darwin";

	programs.zsh.enable = true;
	programs.tmux = {
		enable = true;
		enableVim = true;
		extraConfig = ''
set -g default-terminal "screen-256color"
'';
	};

	users.users.lain.home = "/Users/lain";

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
	];

	environment.variables = {
		EDITOR = "nvim";
	};

	homebrew = {
		enable = true;
		casks = [
			"thunderbird"
			"zen-browser"
			"nextcloud"
			"easy-move+resize"
			"stats"
			"raycast"
			"chatgpt"
			"monero-wallet"
			"whatsapp"
			"discord"
			"karabiner-elements"
			"skim"
			"keepassxc"
			"reaper"
			"coconutbattery"
			"roblox"
			"Kegworks-App/kegworks/kegworks"
			"qbittorrent"
			"datagrip"
			"docker"
		];
	};

	system = {
		defaults = {
			dock = {
				autohide = true;
				largesize = 64;
				magnification = true;
				show-recents = false;
			};
			finder = {
				AppleShowAllExtensions = true;
				ShowPathbar = true;
				FXEnableExtensionChangeWarning = false;
			};
			NSGlobalDomain = {
				InitialKeyRepeat = 15;
				KeyRepeat = 2;
				ApplePressAndHoldEnabled = false;
			};
		};
		keyboard = {
			enableKeyMapping = true;
			remapCapsLockToEscape = true;
		};
	};

	services = {
		yabai = {
			enable = true;
			config = {
				"layout" = "bsp";

				"top_padding"    = 16;
				"bottom_padding" = 16;
				"left_padding"   = 16;
				"right_padding"  = 16;
				"window_gap"     = 16;

				"auto_balance" = true;
				"focus_follows_mouse" = "autofocus";

				"mouse_modifier" = "alt";
				"mouse_action1" = "move";
				"mouse_action2" = "resize";
			};
			extraConfig = ''
				yabai -m rule --add app="^Etterna$" manage=off
				yabai -m rule --add app="^System Settings$" manage=off
			'';
		};
	};

	system.configurationRevision = self.rev or self.dirtyRev or null;
	system.stateVersion = 6;
}

