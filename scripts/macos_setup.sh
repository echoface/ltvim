#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="${SCRIPT_DIR}/ltenv/env"
TARGET_ENV="$HOME/.ltenv"

# optional modules
INSTALL_GOLANG=false
INSTALL_SEQUEL_ACE=false
INSTALL_GHOSTTY=false
INSTALL_KEYCASTR=false
INSTALL_PEARCLEANER=false
INSTALL_IINA=false
INSTALL_LICECAP=false
INSTALL_RAYCAST=false
INSTALL_ZED=false

show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --golang       Install Golang"
    echo "  --sequel-ace   Install Sequel Ace (database client)"
    echo "  --ghostty      Install Ghostty (terminal)"
    echo "  --keycastr    Install Keycastr (key display)"
    echo "  --pearcleaner Install Pearcleaner (app cleaner)"
    echo "  --iina        Install IINA (video player)"
    echo "  --licecap     Install Licecap (screen recorder)"
    echo "  --raycast     Install Raycast (launcher)"
    echo "  --zed         Install Zed (code editor)"
    echo "  --all         Install all optional modules"
    echo "  -h, --help    Show this help message"
}

# parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --golang) INSTALL_GOLANG=true; shift ;;
        --sequel-ace) INSTALL_SEQUEL_ACE=true; shift ;;
        --ghostty) INSTALL_GHOSTTY=true; shift ;;
        --keycastr) INSTALL_KEYCASTR=true; shift ;;
        --pearcleaner) INSTALL_PEARCLEANER=true; shift ;;
        --iina) INSTALL_IINA=true; shift ;;
        --licecap) INSTALL_LICECAP=true; shift ;;
        --raycast) INSTALL_RAYCAST=true; shift ;;
        --zed) INSTALL_ZED=true; shift ;;
        --all)
            INSTALL_GOLANG=true
            INSTALL_SEQUEL_ACE=true
            INSTALL_GHOSTTY=true
            INSTALL_KEYCASTR=true
            INSTALL_PEARCLEANER=true
            INSTALL_IINA=true
            INSTALL_LICECAP=true
            INSTALL_RAYCAST=true
            INSTALL_ZED=true
            shift
            ;;
        -h|--help) show_help; exit 0 ;;
        *) echo "Unknown option: $1"; show_help; exit 1 ;;
    esac
done

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Error: This script is for macOS only."
    echo "Current OS: $OSTYPE"
    exit 1
fi

echo "Detected macOS system"
echo ""

# Install Homebrew if not exists
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    USE_MIRROR=y
    if [ -t 0 ]; then
        read -p "Use USTC mirror for brew installation? [Y/n]: " USE_MIRROR
    fi
    case "$USE_MIRROR" in
        [nN]|[nN][oO])
            echo "Installing Homebrew from official source..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            ;;
        *)
            export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
            export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
            export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"

            /bin/bash -c "$(curl -fsSL https://mirrors.ustc.edu.cn/misc/brew-install.sh)"
            ;;
    esac
else
    echo "✓ Homebrew already installed"
fi

# Ensure brew works
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Install essential tools via Homebrew
echo ""
echo "Installing essential tools via Homebrew..."
for tool in nvim zoxide tmux fd ripgrep; do
    if ! command -v $tool >/dev/null 2>&1; then
        brew install $tool
    else
        echo "✓ $tool already installed"
    fi
done

# Install Nerd Font
echo ""
echo "Installing Nerd Font..."
if ! brew list --cask | grep -q "font-hack-nerd-font"; then
    brew install --cask font-hack-nerd-font
else
    echo "✓ font-hack-nerd-font already installed"
fi

# Install n (Node.js version manager)
echo ""
if ! command -v n >/dev/null 2>&1; then
    echo "Installing n (Node.js version manager)..."
    curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n -o /tmp/n
    sudo install -m 0755 /tmp/n /usr/local/bin/n
    echo "n installed"
fi

# Install uv
if ! command -v uv >/dev/null 2>&1; then
    echo "Installing uv (Python package manager)..."
    curl -fsSL https://astral.sh/uv/install.sh | sh
fi

# Install node lts
echo ""
echo "Installing Node.js LTS..."
export N_PREFIX="$HOME/.n"
export NODE_MIRROR=https://mirrors.ustc.edu.cn/node/
mkdir -p "$N_PREFIX"
if ! command -v node >/dev/null 2>&1; then
    n install lts
else
    echo "✓ node already installed"
fi

# Copy env file to ~/.ltenv (with backup)
echo ""
echo "Setting up environment configuration..."
if [ -f "$TARGET_ENV" ]; then
    cp "$TARGET_ENV" "${TARGET_ENV}.bak.$(date +%Y%m%d_%H%M%S)"
    echo "Backed up existing $TARGET_ENV"
fi
cp "$ENV_FILE" "$TARGET_ENV"
echo "Environment file copied to $TARGET_ENV"

# Add source to shell rc files
add_env_source() {
    local rc_file="$1"
    local source_line='[ -f "$HOME/.ltenv" ] && source "$HOME/.ltenv"'

    if [ -f "$rc_file" ]; then
        if ! grep -qF '.ltenv' "$rc_file" 2>/dev/null; then
            echo "" >> "$rc_file"
            echo "# Load custom environment" >> "$rc_file"
            echo "$source_line" >> "$rc_file"
            echo "Added ltenv source to $rc_file"
        else
            echo "Env source already exists in $rc_file"
        fi
    fi
}

# Detect shell and add env source
if [ -f "$HOME/.zshrc" ]; then
    echo "Detected Zsh configuration"
    add_env_source "$HOME/.zshrc"
fi

if [ -f "$HOME/.bashrc" ] || [ -f "$HOME/.bash_profile" ]; then
    echo "Detected Bash configuration"
    add_env_source "$HOME/.bash_profile"
    add_env_source "$HOME/.bashrc"
fi

# Tmux config
echo ""
echo "Setting up tmux configuration..."
if [ -f "$HOME/.tmux.conf" ]; then
    mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak.$(date +%Y%m%d_%H%M%S)"
    echo "Backed up existing ~/.tmux.conf"
fi

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing tmux plugin manager (tpm)..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

cp "$REPO_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
echo "Tmux config installed"

# Optional: Golang
if [ "$INSTALL_GOLANG" = true ]; then
    echo ""
    if command -v go >/dev/null 2>&1; then
        echo "✓ Golang already installed"
    else
        echo "Installing Golang..."
        brew install go
        mkdir -p "$HOME/go"
        echo "Golang installed"
    fi
fi

# Optional: Sequel Ace
if [ "$INSTALL_SEQUEL_ACE" = true ]; then
    echo ""
    if brew list --cask | grep -q "sequel-ace"; then
        echo "✓ Sequel Ace already installed"
    else
        echo "Installing Sequel Ace..."
        brew install --cask sequel-ace
        echo "Sequel Ace installed successfully"
    fi
fi

# Optional: Ghostty
if [ "$INSTALL_GHOSTTY" = true ]; then
    echo ""
    if brew list --cask | grep -q "ghostty"; then
        echo "✓ Ghostty already installed"
    else
        echo "Installing Ghostty..."
        brew install --cask ghostty
        echo "Ghostty installed successfully"
    fi
fi

# Optional: Keycastr
if [ "$INSTALL_KEYCASTR" = true ]; then
    echo ""
    if brew list --cask | grep -q "keycastr"; then
        echo "✓ Keycastr already installed"
    else
        echo "Installing Keycastr..."
        brew install --cask keycastr
        echo "Keycastr installed successfully"
    fi
fi

# Optional: Pearcleaner
if [ "$INSTALL_PEARCLEANER" = true ]; then
    echo ""
    if brew list --cask | grep -q "pearcleaner"; then
        echo "✓ Pearcleaner already installed"
    else
        echo "Installing Pearcleaner..."
        brew install --cask pearcleaner
        echo "Pearcleaner installed successfully"
    fi
fi

# Optional: IINA
if [ "$INSTALL_IINA" = true ]; then
    echo ""
    if brew list --cask | grep -q "iina"; then
        echo "✓ IINA already installed"
    else
        echo "Installing IINA..."
        brew install --cask iina
        echo "IINA installed successfully"
    fi
fi

# Optional: Licecap
if [ "$INSTALL_LICECAP" = true ]; then
    echo ""
    if brew list --cask | grep -q "licecap"; then
        echo "✓ Licecap already installed"
    else
        echo "Installing Licecap..."
        brew install --cask licecap
        echo "Licecap installed successfully"
    fi
fi

# Optional: Raycast
if [ "$INSTALL_RAYCAST" = true ]; then
    echo ""
    if brew list --cask | grep -q "raycast"; then
        echo "✓ Raycast already installed"
    else
        echo "Installing Raycast..."
        brew install --cask raycast
        echo "Raycast installed successfully"
    fi
fi

# Optional: Zed
if [ "$INSTALL_ZED" = true ]; then
    echo ""
    if brew list --cask | grep -q "zed"; then
        echo "✓ Zed already installed"
    else
        echo "Installing Zed..."
        brew install --cask zed
        echo "Zed installed successfully"
    fi
fi

echo ""
echo "Setup complete! Please restart your shell or run: source ~/.ltenv"
