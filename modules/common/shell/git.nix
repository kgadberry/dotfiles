{ config, pkgs, lib, ... }:

{
    options = {
        gitName = lib.mkOption {
            type = lib.types.str;
            description = "Name to use for git commits.";
        };
        gitEmail = lib.mkOption {
            type = lib.types.str;
            description = "Email to use for git commits.";
        };
    };

    config.home-manager.users = {

        ${config.user} = {
            home.packages = with pkgs; [
                gh
                git
                git-crypt
                git-lfs
            ];

            programs.git = {
                enable = true;
                userName = config.gitName;
                userEmail = config.gitEmail;
                extraConfig = {
                    pager.branch = "false";
                    safe.directory = config.dotfilesPath;
                    pull.ff = "only";
                    push.autoSetupRemote = "true";
                    init.defaultBranch = "main";
                };
                ignores = [ ".direnv/**" "result" ];
            };

            # Add git aliases to zsh
            programs.zsh.shellAliases = {
                g = "git";
                gs = "git status";
                gd = "git diff";
                gds = "git diff --staged";
                gdp = "git diff HEAD^";
                ga = "git add";
                gaa = "git add -A";
                gac = "git commit -am";
                gc = "git commit -m";
                gca = "git commit --amend --no-edit";
                gcae = "git commit --amend";
                gu = "git pull";
                gp = "git push";
                gl = "git log --graph --decorate --oneline -20";
                gll = "git log --graph --decorate --oneline";
                gco = "git checkout";
                gcom = ''
                    git switch (git symbolic-ref refs/remotes/origin/HEAD | cut -d"/" -f4)'';
                gcob = "git switch -c";
                gb = "git branch";
                gbd = "git branch -d";
                gbD = "git branch -D";
                gr = "git reset";
                grh = "git reset --hard";
                gm = "git merge";
                gcp = "git cherry-pick";
                cdg = "cd (git rev-parse --show-toplevel)";
            };
        };

        # Set git configuration for root
        root.programs.git = {
            enable = true;
            extraConfig.safe.directory = config.dotfilesPath;
        };
        
    };

}