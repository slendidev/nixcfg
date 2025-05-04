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
		];
	};

	system = {
		defaults = {
			dock = {
				autohide = true;
				largesize = 32;
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
			};
		};
		keyboard = {
			enableKeyMapping = true;
			remapCapsLockToEscape = true;
		};
	};

	system.configurationRevision = self.rev or self.dirtyRev or null;
	system.stateVersion = 6;
}

