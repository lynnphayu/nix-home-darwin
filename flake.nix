{
  description = "Personal Nix MacOs configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
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

  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      homebrew-core,
      homebrew-cask,
      homebrew-bundle,
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
        { pkgs, ... }:
        {
          nixpkgs.config.allowUnfree = true;
          environment.systemPackages = with pkgs; [
            zoxide
            vim
            neovim
            git
            tmux
            zsh
            go
            oh-my-posh
            htop
            air
            pnpm
            nodejs
          ];
          services = {
            nix-daemon.enable = true;
            postgresql = {
              dataDir = "/Users/${username}/services_data/postgres_data";
              enable = true;
              package = pkgs.postgresql_17;
              authentication = "
	  host    all             all             127.0.0.1/32            trust
	  local   all             all                                     trust
	  ";
              enableTCPIP = true;
            };
            redis = {
              enable = true;
              package = pkgs.redis;
              dataDir = "/Users/${username}/services_data/redis_data";
              extraConfig = ''
                logfile /Users/${username}/services_log/redis.log
              '';
            };
          };

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
          homebrew = {
            enable = true;
            onActivation = {
              autoUpdate = true;
              upgrade = true;
              cleanup = "zap";
            };

            masApps = {
              # Xcode = 497799835;
              OktaVerify = 490179405;
            };
            taps = [ ];
            brews = [
              "wget"
              "curl"
              "podman"
              "git"
              "tmux"
              "zsh"
              "oh-my-posh"
              "neovim"
              "maven"
              "graphviz"
              "terraform"
              "localstack"
              # "mongodb/brew/mongodb-community"
              # "mongodb/brew/mongosh"
              # "mongodb/brew/mongodb-database-tools"
            ];
            casks = [
              "studio-3t"
              "google-chrome"
              "cursor"
              "trae"
              "discord"
              "stats"
              "ghostty"
              # "webull"
              "podman-desktop"
              "alfred"
              "medis"
              "obsidian"
              "sequel-ace"
              "postman"
              "spotify"
              "slack"
              "telegram"
              "whatsapp"
              "chatgpt"
              "zoom"
              "logi-options+"
              "steam"
              "tableplus"
            ];
          };
          time.timeZone = "Asia/Singapore";
          fonts = {
            packages = with pkgs; [
              (nerdfonts.override {
                fonts = [
                  "FiraCode"
                  "JetBrainsMono"
                ];
              })
              noto-fonts
              dejavu_fonts
            ];
          };
          system = {
            defaults = {
              NSGlobalDomain = {
                AppleInterfaceStyleSwitchesAutomatically = true;
                AppleICUForce24HourTime = true;
              };
              loginwindow = {
                autoLoginUser = "${username}";
              };
              menuExtraClock = {
                Show24Hour = true;
              };
              screencapture = {
                location = "/Users/${username}/Desktop/screenshots";
              };
              dock = {
                autohide = true;
                autohide-delay = 0.1;
                orientation = "bottom";
                show-process-indicators = true;
                show-recents = false;
                tilesize = 40;
                largesize = 50;
                magnification = true;
                minimize-to-application = true;
                persistent-apps = [ ];
              };
              WindowManager = {
                EnableStandardClickToShowDesktop = true;
                EnableTiledWindowMargins = false;
              };
              controlcenter = {
                Display = true;
                BatteryShowPercentage = true;
                Sound = true;

                NowPlaying = false;
                AirDrop = false;
                Bluetooth = false;
                FocusModes = false;
              };
            };
            configurationRevision = self.rev or self.dirtyRev or null;
            stateVersion = 5;
          };
          nixpkgs.hostPlatform = system;
        };
    in
    {
      darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
        inherit system specialArgs;
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            users.users.${username} = {
              home = "/Users/${username}";
              description = "Personal Nix MacOs configuration";
            };
            home-manager.users.${username} = import ./home.nix;
          }
          inputs.nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = username;
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "homebrew/homebrew-bundle" = homebrew-bundle;
              };
              mutableTaps = false;
            };
          }

          (
            { pkgs, lib, ... }:
            {
              security.pam.enableSudoTouchIdAuth = true;
              programs.zsh.enable = true;

            }
          )
        ];
      };
      # darwinPackages = self.darwinConfigurations."macbook-pro".packages;
    };
}
