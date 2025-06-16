{ pkgs }:
{
	systemPackages = with pkgs; [
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

	homePackages = with pkgs; [
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

	envVars = {
		EDITOR = "nvim";
	};
}
