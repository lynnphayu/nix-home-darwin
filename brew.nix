{
  enable = true;
  onActivation = {
    autoUpdate = true;
    upgrade = true;
    cleanup = "zap";
  };

  masApps = {
  };
  taps = [
    "homebrew/core"
    "homebrew/cask"
    "homebrew/bundle"
    "hashicorp/tap"
    "steipete/tap"
    "manaflow-ai/cmux"
  ];
  brews = [
    "wget"
    "curl"
    "podman"
    "git"
    "tmux"
    "zsh"
    "oh-my-posh"
    "maven"
    "graphviz"
    "hashicorp/tap/terraform"
    "localstack"
    "helm"
    "watchman"
    "k6"
    "steipete/tap/spogo"
    "pi-coding-agent"
    "herdr"
    # "mongodb/brew/mongodb-community"
    # "mongodb/brew/mongosh"
    # "mongodb/brew/mongodb-database-tools"
  ];
  casks = [
    "1password"
    "1password-cli"
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
    "orbstack"
    "localsend"
    "manaflow-ai/cmux/cmux"
    "claude"
    "chatgpt"
    # "sequel-ace"
    # "whatsapp"
    # "medis"
  ];
}
