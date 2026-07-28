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
        nixosConfigurations = {
            
            # Laptop
            laptop = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./laptop-hardware-configuration.nix
                    ./configuration.nix    # Shared system config
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

            # Workstation 
            workstation = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./workstation-hardware-configuration.nix 
                    ./configuration.nix        # Shared system config
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
    };
}
