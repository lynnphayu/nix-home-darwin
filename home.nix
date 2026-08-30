{
  username,
  pkgs,
  config,
  lib,
  ...
}:

{
  imports = [ ];

  home = {
    activation = {
      run = ''
        echo "Creating data directories"
        mkdir -p /Users/${username}/services_data/postgres_data
        mkdir -p /Users/${username}/services_data/mysql_data
        mkdir -p /Users/${username}/services_data/redis_data
        mkdir -p /Users/${username}/services_data/mongodb_data

        echo "Creating directory for logs"
        mkdir -p /Users/${username}/services_log

        echo "Creating directories for screenshots"
        mkdir -p /Users/${username}/Desktop/screenshots
      '';
    };
    username = username;
    stateVersion = "25.11";
    packages = with pkgs; [
      pnpm
    ];
    sessionVariables = {
      PNPM_HOME = "${config.xdg.dataHome}/pnpm";
    };

    sessionPath = [
      "${config.xdg.dataHome}/pnpm"
    ];

  };
  programs = {
    zoxide.enable = true;
    zsh = {
      enable = true;

      autosuggestion = {
        enable = true;
        # highlight = "fg=#ff00ff,bg=cyan,bold,underline";
      };
      enableCompletion = true;
      shellAliases = {
        pi = ''op run --env-file="$HOME/.config/pi/secrets.env" --no-masking -- pi'';
      };
      initContent = lib.mkMerge [
        # Homebrew must be on PATH before compinit so its completions load
        (lib.mkOrder 550 ''
          eval "$(/opt/homebrew/bin/brew shellenv)"
          fpath+=(/opt/homebrew/share/zsh/site-functions)
        '')
        ''
          eval "$(fnm env --use-on-cd --shell zsh)"
        ''
      ];
    };
    oh-my-posh = {
      enable = true;
      settings = builtins.fromJSON (builtins.readFile ./omp.json);
    };
    home-manager.enable = true;
  };
}
