{
  enable = true;
  onActivation = {
    autoUpdate = true;
    upgrade = true;
    cleanup = "zap";
  };

  masApps = {
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
    "podman-desktop"
    "alfred"
    "obsidian"
    "postman"
    "spotify"
    "slack"
    "telegram"
    "chatgpt"
    "zoom"
    "logi-options+"
    "steam"
    "tableplus"
    # "sequel-ace"
    # "whatsapp"
    # "medis"
  ];
}
