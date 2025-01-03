{
	description = "System NixOS flake configuration";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		
		zen-browser.url = "github:ch4og/zen-browser-flake";
		polymc.url = "github:PolyMC/PolyMC";
		glslcc-flake.url = "github:xslendix/glslcc-flake";
		hyprland-qtutils.url = "github:hyprwm/hyprland-qtutils";
	};

	outputs = { self, nixpkgs, home-manager, ... }@inputs : {
		nixosConfigurations.navi = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";

			specialArgs = { inherit inputs; };
			
			modules = [
				./configuration.nix

				home-manager.nixosModules.home-manager {
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.extraSpecialArgs = { inherit nixpkgs; };
					home-manager.users.lain = import ./home.nix;
				}
			];
		};
	};
}

