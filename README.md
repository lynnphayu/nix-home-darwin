# Nix-Darwin Conf

A declarative macOS system configuration using [nix-darwin](https://github.com/LnL7/nix-darwin) and [home-manager](https://github.com/nix-community/home-manager).

### Prerequisites

1. **Install Nix**:

   ```bash
   curl -L https://nixos.org/nix/install | sh -s -- --daemon
   ```

2. **Enable flakes** in your nix configuration:

   ```bash
   mkdir -p ~/.config/nix
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

3. **Install nix-darwin**:

   ```bash
   sudo nix run nix-darwin/<version>#darwin-rebuild -- switch
   ```

### Installation

1. **Clone this repository**

2. **Update user configuration** in `flake.nix`:

   ```nix
   username = "username";
   useremail = "email@domain.com";
   hostname = "hostname";
   system = "aarch64-darwin"; # Change this if you are not using Apple Silicon
   ```

3. **Apply the configuration**:
   ```bash
   darwin-rebuild switch --flake .#<hostname>
   ```

## Repository Structure

```
.
├── flake.nix              # Main flake configuration
├── home.nix               # Home-manager user configuration
├── system_setting.nix     # macOS system preferences
├── brew.nix               # Homebrew packages and casks
├── nix_native_services.nix # Nix-managed services
└── README.md              # This file
```

## Configuration Files

### `flake.nix`

Main configuration entry point that defines:

- System packages (development tools, utilities)
- Service configurations (databases, etc.)
- Homebrew integration
- System settings and defaults

### `home.nix`

User-specific configuration managed by home-manager:

- Shell configuration (zsh, oh-my-posh)
- User packages and dotfiles
- Application settings

### `system_setting.nix`

macOS system preferences including:

- Dock behavior and appearance
- Finder settings
- Keyboard and mouse preferences
- Security settings

## Directory Structure

The configuration creates these directories:

- `~/services_data/`: Database files and service data
- `~/services_log/`: Service log files
- `~/Desktop/screenshots/`: Screenshot storage location

### Adding Packages

1. **System packages** (available to all users):

   ```nix
   # In flake.nix, add to environment.systemPackages
   environment.systemPackages = with pkgs; [
     # existing packages...
     new-package-name
   ];
   ```

2. **User packages** (home-manager):

   ```nix
   # In home.nix, add to home.packages
   packages = with pkgs; [
     # existing packages...
     new-package-name
   ];
   ```

3. **Homebrew apps**:

   ```nix
   # In brew.nix, add to casks
   casks = [
     # existing casks...
     "new-app-name"
   ];
   ```

4. **Homebrew packages**:
   ```nix
   # In brew.nix, add to brew.brews
   brews = [
     # existing brews...
     "new-package-name"
   ];
   ```
