{ username, pkgs, ... }:

{
  # for sub mods
  imports = [
  ];
  home = {
    activation = {
      # touch /Users/${username}/services_log/postgres.log
      # touch /Users/${username}/services_log/mysql.log
      # touch /Users/${username}/services_log/redis.log
      # touch /Users/${username}/services_log/mongodb.log
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
    stateVersion = "24.11";
    file = { };
    packages = with pkgs; [
      nmap
      ripgrep
      jq
      fzf
    ];
  };
  programs = {
    zsh = {
      enable = true;
      autosuggestion = {
        enable = true;
        # highlight = "fg=#ff00ff,bg=cyan,bold,underline";
      };
      enableCompletion = true;
    };
    oh-my-posh = {
      enable = true;
      useTheme = "half-life";
    };
  };
  programs.home-manager.enable = true;
}
