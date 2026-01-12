#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="${SCRIPT_DIR}/envrc/macos"
TARGET_ENV="$HOME/.envrc"

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
    export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
    export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
    export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
    export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"

    /bin/bash -c "$(curl -fsSL https://mirrors.ustc.edu.cn/misc/brew-install.sh)"
    #/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "✓ Homebrew already installed"
fi

# Ensure brew works
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install essential tools via Homebrew
echo ""
echo "Installing essential tools via Homebrew..."
brew install git nvim n zoxide tmux fd uv ripgrep

# Install Nerd Font
echo ""
echo "Installing Nerd Font..."
brew install --cask font-hack-nerd-font

# Install node lts
echo ""
echo "Installing Node.js LTS..."
export N_PREFIX="$HOME/.n"
mkdir -p "$N_PREFIX"
n install lts

# Copy env file to ~/.envrc (with backup)
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
    local source_line='[ -f "$HOME/.envrc" ] && source "$HOME/.envrc"'

    if [ -f "$rc_file" ]; then
        if ! grep -qF '.envrc' "$rc_file" 2>/dev/null; then
            echo "" >> "$rc_file"
            echo "# Load custom environment" >> "$rc_file"
            echo "$source_line" >> "$rc_file"
            echo "Added envrc source to $rc_file"
        else
            echo "Env source already exists in $rc_file"
        fi
    fi
}

# Detect shell and add env source
if [ -n "$ZSH_VERSION" ]; then
    echo "Detected Zsh shell"
    add_env_source "$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    echo "Detected Bash shell"
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
    echo "Installing Golang..."
    brew install go
    mkdir -p "$HOME/go"
    echo "Golang installed"
fi

# Optional: Sequel Ace
if [ "$INSTALL_SEQUEL_ACE" = true ]; then
    echo ""
    echo "Installing Sequel Ace..."
    brew install --cask sequel-ace
    echo "Sequel Ace installed successfully"
fi

# Optional: Ghostty
if [ "$INSTALL_GHOSTTY" = true ]; then
    echo ""
    echo "Installing Ghostty..."
    brew install --cask ghostty
    echo "Ghostty installed successfully"
fi

# Optional: Keycastr
if [ "$INSTALL_KEYCASTR" = true ]; then
    echo ""
    echo "Installing Keycastr..."
    brew install --cask keycastr
    echo "Keycastr installed successfully"
fi

# Optional: Pearcleaner
if [ "$INSTALL_PEARCLEANER" = true ]; then
    echo ""
    echo "Installing Pearcleaner..."
    brew install --cask pearcleaner
    echo "Pearcleaner installed successfully"
fi

# Optional: IINA
if [ "$INSTALL_IINA" = true ]; then
    echo ""
    echo "Installing IINA..."
    brew install --cask iina
    echo "IINA installed successfully"
fi

# Optional: Licecap
if [ "$INSTALL_LICECAP" = true ]; then
    echo ""
    echo "Installing Licecap..."
    brew install --cask licecap
    echo "Licecap installed successfully"
fi

# Optional: Raycast
if [ "$INSTALL_RAYCAST" = true ]; then
    echo ""
    echo "Installing Raycast..."
    brew install --cask raycast
    echo "Raycast installed successfully"
fi

# Optional: Zed
if [ "$INSTALL_ZED" = true ]; then
    echo ""
    echo "Installing Zed..."
    brew install --cask zed
    echo "Zed installed successfully"
fi

echo ""
echo "Setup complete! Please restart your shell or run: source ~/.envrc"
