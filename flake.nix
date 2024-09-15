{
    description = "kgadberry systems configuration";

    # Other flakes we want to pull from
    inputs = {
        # Used for system packages
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

         # Used for Windows Subsystem for Linux compatibility
        wsl.url = "github:nix-community/NixOS-WSL";

        # Nix user repository 
        nur.url = "github:nix-community/NUR";

        # Used for user packages and dotfiles
        home-manager = {
        url = "github:nix-community/home-manager/master";
        inputs.nixpkgs.follows =
            "nixpkgs"; # Use system packages list where available
        };

        # Nix language server
        nil.url = "github:oxalica/nil/2024-08-06";
    };

    outputs = { nixpkgs, ... }@inputs:

        let

            globals = rec {
                user = "kgadberry";
                fullName = "Kaye Gadberry";
                gitName = fullName;
                gitEmail = "1781520+kgadberry@users.noreply.github.com";
                dotfilesRepo = "github:kgadberry/dotfiles";
            };

            overlays = [
                # TODO: put something here
            ];

            # System types to support
            supportedSystems = 
                [ "x86-64_linux" "aarch64-linux" ];

            # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
            forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
            
        in rec {

            # Full system configurations including home-manager
            # nixos-rebuild switch --flake .#lapstation
            nixosConfigurations = {
                cerberus = import ./hosts/cerberus { inherit inputs globals overlays; };
                lapstation = import ./hosts/lapstation { inherit inputs globals overlays; };
            };
            
        };
}
