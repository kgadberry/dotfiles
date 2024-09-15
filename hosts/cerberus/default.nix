# System configuration for WSL on workstation (cerberus)

{ inputs, globals, overlays, ... }:

with inputs;

nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {};
    modules = [
        ../../modules/common
        ../../modules/nixos
        ../../modules/wsl
        globals
        wsl.nixosModules.wsl
        home-manager.nixosModules.home-manager
        {
            # networking.hostname = "cerberus";
            nixpkgs.overlays = overlays;
            # Set registry to flake packages, used for nix X commands
            nix.registry.nixpkgs.flake = nixpkgs;
            identityFile = "/home/${globals.user}/.ssh/id_ed25519";
            gui.enable = false;
            passwordHash = nixpkgs.lib.fileContents ../../password.sha512;
            wsl = {
                enable = true;
                wslConf.automount.root = "/mnt";
                defaultUser = globals.user;
                startMenuLaunchers = true;
                nativeSystemd = true;
                wslConf.network.generateResolvConf = false; # disabled because it breaks tailscale
                interop.includePath = true; # Include Windows PATH
            };
        }
    ];
}