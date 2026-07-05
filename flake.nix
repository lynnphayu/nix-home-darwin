{
  description = "Personal Nix MacOs configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-hashicorp-tap = {
      url = "github:hashicorp/homebrew-tap";
      flake = false;
    };
    homebrew-spogo-tap = {
      url = "github:steipete/homebrew-tap";
      flake = false;
    };
    homebrew-manaflow-tap = {
      url = "github:manaflow-ai/homebrew-cmux";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      homebrew-bundle,
      homebrew-hashicorp-tap,
      homebrew-spogo-tap,
      homebrew-manaflow-tap,
      home-manager,
      ...
    }:
    let
      username = "linphayoo";
      useremail = "lynnphayu@icloud.com";
      system = "aarch64-darwin";
      hostname = "${username}-macbook-pro";

      specialArgs = inputs // {
        inherit username useremail hostname;
      };

      configuration =
        {
          pkgs,
          home-manager,
          nix-homebrew,
          ...
        }:
        {
          nixpkgs = {
            hostPlatform = system;
            config.allowUnfree = true;
          };
          environment.systemPackages = with pkgs; [
            zoxide
            nmap
            ripgrep
            jq
            fzf
            vim
            neovim
            git
            tmux
            zsh
            go
            oh-my-posh
            htop
            air
            nodejs_24
            fnm
            fd
            k6
            fastfetch
            rustup
            bun
            yarn
            claude-code
            opencode
          ];
          services = import ./nix_native_services.nix { inherit username pkgs; };
          launchd.user.agents = {
            postgresql.serviceConfig = {
              StandardErrorPath = "/Users/${username}/services_log/postgres.log";
              StandardOutPath = "/Users/${username}/services_log/postgres.log";
            };
            mysql = {
              script = ''
                ${pkgs.mariadb}/bin/mysql_install_db \
                  --datadir=/Users/${username}/services_data/mysql_data
                ${pkgs.mariadb}/bin/mysqld --datadir=/Users/${username}/services_data/mysql_data  \
                  --socket=/tmp/mysql.sock \
                  --skip-grant-tables \
                  --user=${username}
              '';
              serviceConfig = {
                RunAtLoad = true;
                StandardErrorPath = "/Users/${username}/services_log/mysql.log";
                StandardOutPath = "/Users/${username}/services_log/mysql.log";
              };
            };
            mongodb = {
              script = ''
                ${pkgs.mongodb-ce}/bin/mongod \
                  --dbpath /Users/${username}/services_data/mongodb_data \
                  --logpath /Users/${username}/services_log/mongodb.log
              '';
              serviceConfig = {
                KeepAlive = true;
                RunAtLoad = true;
              };
            };

          };
          homebrew = import ./brew.nix;
          time.timeZone = "Asia/Singapore";
          fonts = {
            packages = with pkgs; [
              nerd-fonts.fira-code
              nerd-fonts.jetbrains-mono
              noto-fonts
              dejavu_fonts
            ];
          };
          system = import ./system_setting.nix { inherit username self; };
          security.pam.services.sudo_local.touchIdAuth = true;
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs;
            users.${username} = import ./home.nix;

          };
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = username;
            taps = {
              "manaflow-ai/homebrew-cmux" = homebrew-manaflow-tap;
              "steipete/homebrew-tap" = homebrew-spogo-tap;
              "hashicorp/homebrew-tap" = homebrew-hashicorp-tap;
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
            };
            mutableTaps = false;
          };
          users.users.${username} = {
            home = "/Users/${username}";
            description = "Personal Nix MacOs configuration";
          };
        };
    in
    {
      darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          inputs.nix-homebrew.darwinModules.nix-homebrew
        ];
      };
    };
}
