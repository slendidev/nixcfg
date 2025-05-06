{
	description = "System NixOS flake configuration";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		nix-darwin.url = "github:nix-darwin/nix-darwin/master";
		nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		
		zen-browser.url = "github:0xc000022070/zen-browser-flake";
		polymc.url = "github:PolyMC/PolyMC";
		glslcc-flake.url = "github:xslendix/glslcc-flake";
		hyprland-qtutils.url = "github:hyprwm/hyprland-qtutils";
		hyprpolkitagent = {
			url = "github:hyprwm/hyprpolkitagent";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nixgl.url = "github:nix-community/nixGL";
		blast.url = "github:Arete-Innovations/blast";
		hyprland.url = "github:hyprwm/Hyprland";
	};

	outputs = { self, nixpkgs, home-manager, hyprpolkitagent, nixgl, blast, nix-darwin, ... }@inputs :
		let
			system = "x86_64-linux";
		in
			{
				nixosConfigurations.navi = nixpkgs.lib.nixosSystem {
					system = system;

					specialArgs = { inherit inputs; };
					
					modules = [
						./configuration.nix

						home-manager.nixosModules.home-manager {
							home-manager.useGlobalPkgs = true;
							home-manager.useUserPackages = true;
							home-manager.extraSpecialArgs = { inherit nixpkgs; inherit blast; inherit system; };
							home-manager.users.lain = import ./home.nix;
						}
					];
				};

				darwinConfigurations."Lains-MacBook-Air" = nix-darwin.lib.darwinSystem {
					system = "aarch64-darwin";
					modules = [
						./configuration-mac.nix 

						home-manager.darwinModules.home-manager {
							home-manager.useGlobalPkgs = true;
							home-manager.useUserPackages = true;
							home-manager.extraSpecialArgs = {
								inherit nixpkgs;
								system = "aarch64-darwin";
							};
							home-manager.users.lain = import ./home-mac.nix;
						}
					];
					specialArgs = { inherit self inputs; };
				};

			};
}

