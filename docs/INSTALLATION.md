# Installation Guide

## Overview

LTVIM provides a comprehensive terminal development environment. Installation is split into two parts:

1. **System Setup** - Install dependencies and configure the system
2. **Editor Configuration** - Install vim/nvim configurations

## Ubuntu Installation

### Prerequisites
- Ubuntu 18.04 or later
- Internet connection
- Sudo privileges

### Step 1: System Setup

Clone the repository and run the setup script:

```bash
git clone https://github.com/yourusername/ltvim.git
cd ltvim
chmod +x scripts/ubuntu_setup.sh
./scripts/ubuntu_setup.sh
```

#### Optional Modules

Add specific tools during installation:

```bash
# Install with Golang
./scripts/ubuntu_setup.sh --golang

# Install with Docker
./scripts/ubuntu_setup.sh --docker

# Install all optional modules
./scripts/ubuntu_setup.sh --all
```

### Step 2: Editor Configuration

```bash
chmod +x scripts/install.sh
./scripts/install.sh
```

Follow the prompts to choose between vim or nvim.

## What Gets Installed

### System Dependencies (via Homebrew)
- **nvim** - Neovim editor
- **tmux** - Terminal multiplexer
- **zoxide** - Directory navigation tool
- **n** - Node.js version manager
- **uv** - Python package installer
- **ripgrep** - Fast text search
- **fd** - Fast file finder
- **font-hack-nerd-font** - Developer font

### Optional Modules

#### Golang
- Installs Go via Homebrew
- Configures GOPROXY for Chinese mirrors
- Sets up GOPATH
- Includes GOSUMDB for checksum verification

#### Docker
- Installs Docker Engine via official script
- Configures USTC mirror for faster downloads
- Adds user to docker group
- Sets up systemd service

### Editor Configurations

#### Vim
- Base configuration
- Plugin manager setup
- Essential key mappings

#### Neovim
- Lazyvim-based setup
- LSP support
- Tree-sitter syntax highlighting
- Multiple plugins for enhanced productivity

### Tmux Configuration
- Custom prefix key (Ctrl+Space)
- Mouse support
- Vi mode for copy/paste
- Status bar customization
- TPM (Plugin Manager) installed

### Shell Environment
- Environment variables for all tools
- Shell integration (bash/zsh)
- Optimized for Chinese users (mirrors, proxies)

## Post-Installation

### 1. Restart Your Shell

```bash
# Source the environment file
source ~/.env

# Or restart your terminal
```

### 2. For Docker Users

Log out and log back in, or run:

```bash
newgrp docker
```

### 3. Install Node.js LTS

```bash
# After running ubuntu_setup.sh
n lts
```

### 4. Verify Installation

```bash
# Check if tools are installed
which nvim
which tmux
which zoxide
which go

# Check versions
nvim --version
tmux -V
```

## Uninstallation

### Remove LTVIM Configurations

```bash
# Remove vim configuration
rm ~/.vimrc
rm -rf ~/.vim

# Remove neovim configuration
rm -rf ~/.config/nvim

# Remove tmux configuration
rm ~/.tmux.conf

# Remove environment file
rm ~/.env
```

### Remove Installed Packages

```bash
# Remove Homebrew packages (optional)
brew uninstall nvim tmux zoxide n uv ripgrep fd go docker
```

## Troubleshooting

### Script Fails During Execution

```bash
# Check error details
./scripts/ubuntu_setup.sh 2>&1 | tee setup.log
```

### Permission Denied Errors

```bash
# Make scripts executable
chmod +x scripts/*.sh
```

### Homebrew Installation Fails

```bash
# Install Homebrew manually
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then run the setup script again.

### Docker Group Issues

```bash
# Check if user is in docker group
groups $USER

# Add user to docker group manually
sudo usermod -aG docker $USER
```

## Customization

After installation, you can customize configurations:

- **Editor**: Modify `~/.config/nvim` or `~/.vim`
- **Tmux**: Edit `~/.tmux.conf`
- **Shell**: Modify `~/.env`

## Getting Help

- Check [docs/README.md](README.md) for general information
- Review [FAQ.md](FAQ.md) for common issues
- Open an issue on GitHub for bugs or feature requests
