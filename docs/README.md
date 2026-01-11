# LTVIM - A Modern Vim/Neovim Configuration Toolkit

A modern, out-of-the-box vim toolkit bundle featuring neovim, vim, tmux, and terminal utilities with optimized configurations for developers.

## Features

### Core Tools
- **Neovim** - Modern, performant editor with Lua configuration
- **Vim** - Classic editor with base configuration
- **Tmux** - Terminal multiplexer with optimized settings
- **Ghostty** - Fast, feature-rich terminal emulator
- **Zoxide** - Smarter `cd` command for faster directory navigation
- **N** - Node.js version manager
- **UV** - Fast Python package installer
- **Ripgrep** - Fast text search tool
- **FD** - Simple, fast alternative to `find`

### AI Integration
- **Avante** - AI assistant for vim/nvim with Zen mode

## Quick Start

### 1. System Setup (Ubuntu)

```bash
# Clone this repository
git clone https://github.com/yourusername/ltvim.git
cd ltvim

# Run system setup (installs dependencies)
./scripts/ubuntu_setup.sh

# Or with optional modules:
./scripts/ubuntu_setup.sh --golang --docker --all
```

### 2. Editor Configuration

```bash
# Install vim or nvim configuration
./scripts/install.sh

# Choose:
#  1) vim (base)
#  2) nvim (neovim)
```

## Installation Options

### Ubuntu Setup Script

The `ubuntu_setup.sh` script provides automated system setup with optional modules:

```bash
# Basic installation
./scripts/ubuntu_setup.sh

# With specific modules
./scripts/ubuntu_setup.sh --golang    # Install Golang + proxy settings
./scripts/ubuntu_setup.sh --docker    # Install Docker (China mirror)

# Install all optional modules
./scripts/ubuntu_setup.sh --all
```

#### Golang Configuration
- Installed via Homebrew
- GOPROXY set to Chinese mirrors (goproxy.cn, goproxy.io)
- GOSUMDB configured for Chinese users
- GOPATH set to `$HOME/go`

#### Docker Configuration
- Installed with USTC mirror
- Systemd service configured
- User added to docker group (re-login required)

### Editor Setup Script

The `install.sh` script focuses solely on vim/nvim configuration:

```bash
./scripts/install.sh
```

This will:
- Back up your existing configuration
- Install vim or neovim configuration via symlinks
- Check for required dependencies
- Provide guidance on missing tools

## Directory Structure

```
ltvim/
├── scripts/              # Installation scripts
│   ├── install.sh       # Editor configuration installer
│   ├── ubuntu_setup.sh  # Ubuntu system setup
│   └── install_vim8.sh # Legacy vim8 installer
├── nvim/                # Neovim configuration
├── vim/                 # Vim configuration
├── tmux/                # Tmux configuration
├── ghostty/             # Ghostty terminal configuration
├── env/                 # Shell environment configurations
│   ├── ubuntu
│   └── macos
└── docs/                # Documentation
```

## Configuration Details

### Neovim
- Lazyvim-based setup
- LSP support for multiple languages
- Tree-sitter for syntax highlighting
- Telescope for fuzzy finding
- Multiple themes support

### Tmux
- Prefix key: `Ctrl+Space` (instead of default `Ctrl+B`)
- Mouse support enabled
- Vi mode for copy/paste
- Status bar with custom theme
- TPM (Tmux Plugin Manager) included

### Shell Environment
- Zoxide integration for directory jumping
- Node.js (LTS) via N
- Python packages via UV
- Go environment with Chinese mirrors

## Customization

### Adding Custom Vim Plugins

For neovim, add plugins to `nvim/lua/plugins/`:
```lua
return {
  "plugin-name/plugin-repo",
  config = function()
    -- plugin configuration
  end
}
```

### Shell Environment

Modify `env/ubuntu` to customize environment variables:
- Add custom PATH modifications
- Configure tool-specific settings
- Set up language-specific environments

## Troubleshooting

### Permission Issues with Docker
After installing Docker, you may need to:
```bash
# Log out and log back in
# Or manually add yourself to the docker group
sudo usermod -aG docker $USER
newgrp docker
```

### Missing Dependencies
If you see warnings about missing tools:
```bash
# Ubuntu
./scripts/ubuntu_setup.sh

# macOS
./scripts/macos_setup.sh

# Manual installation
brew install ripgrep fd
```

### Font Issues
After installing Hack Nerd Font:
```bash
# Refresh font cache
fc-cache -fv

# Restart your terminal
```

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

MIT License - see [LICENSE](../LICENSE) file for details.
