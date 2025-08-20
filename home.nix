{ username, pkgs, ... }:

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
    stateVersion = "24.11";
    file = { };
    packages = with pkgs; [
    ];
  };
  programs = {
    zoxide = {
      enable = true;
    };
    zsh = {
      enable = true;
      autosuggestion = {
        enable = true;
        # highlight = "fg=#ff00ff,bg=cyan,bold,underline";
      };
      enableCompletion = true;
      initExtra = ''
        # Add Homebrew to PATH
        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';
    };
    oh-my-posh = {
      enable = true;
      useTheme = "half-life";
    };
    home-manager.enable = true;
  };
}
