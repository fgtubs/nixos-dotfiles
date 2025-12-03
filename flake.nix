{
	description = "Hyprland on Nixos";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { nixpkgs, home-manager, ... }: {
		nixosConfigurations.hyprland-btw = nixpkgs.lib.nixosSystem {
			system = "x86_64-linus";
			modules = [
				./configuration.nix
				home-manager.nixosModules.home-manager
				{	 
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						users.fin = import ./home.nix;
						backupFileExtension = "backup";
					};
				}
			];
		};
	};
}
