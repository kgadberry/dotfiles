{ config, pkgs, lib, ... }: {

    options = {

        passwordHash = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            description = "Password created with sha512.";
            default = null;
        };

    };

    config = lib.mkIf (pkgs.stdenv.isLinux) {

        # Allows us to declaritively set password
        users.mutableUsers = false;

        # Define a user account. Don't forget to set a password with ‘passwd’.
        users.users.${config.user} = {

            # Create a home directory for human user
            isNormalUser = true;

            # Automatically create a password to start
            hashedPassword = config.passwordHash;

            extraGroups = [
                "wheel" # Sudo privileges
            ];

        };

        home-manager.users.${config.user}.xdg = {

            # Allow Nix to manage the default applications list
            mimeApps.enable = true;

            # Set directories for application defaults
            userDirs = {
                enable = true;
                createDirectories = true;
                documents = "$HOME/Documents";
                download = "$HOME/Downloads";
                music = "$HOME/Media/Music";
                pictures = "$HOME/Media/Images";
                videos = "$HOME/Media/Videos";
                desktop = "$HOME/Other/Desktop";
                publicShare = "$HOME/Other/Public";
                templates = "$HOME/Other/Templates";
                extraConfig = { XDG_DEV_DIR = "$HOME/Code"; };
            };
        };

    };

}