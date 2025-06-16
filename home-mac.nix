{ config, pkgs, system, ... } :
let
	common = import ./common/defaults.nix { inherit pkgs; };
	commonPrograms = import ./common/home-programs.nix;
in
{
	home.username = "lain";
	home.homeDirectory = "/Users/lain";

	programs.mpv.enable = true;

	home.packages =
		common.homePackages ++
		(with pkgs; [
			typst
			tinymist
	]);

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

	programs = commonPrograms;

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
