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

# ── Helper functions ────────────────────────────────────────
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

install_common_tools() {
    for tool in nvim zoxide tmux fd ripgrep; do
        if ! command -v $tool >/dev/null 2>&1; then
            brew install $tool
        else
            echo "✓ $tool already installed"
        fi
    done

    if ! brew list --cask | grep -q "font-hack-nerd-font"; then
        brew install --cask font-hack-nerd-font
    else
        echo "✓ font-hack-nerd-font already installed"
    fi
    fc-cache -fv 2>/dev/null || true

    if ! command -v n >/dev/null 2>&1; then
        curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n -o /tmp/n
        sudo install -m 0755 /tmp/n /usr/local/bin/n
        echo "n installed"
    fi

    if ! command -v uv >/dev/null 2>&1; then
        curl -fsSL https://astral.sh/uv/install.sh | sh
    fi

    export N_PREFIX="$HOME/.n"
    export NODE_MIRROR=https://mirrors.ustc.edu.cn/node/
    mkdir -p "$N_PREFIX"
    if ! command -v node >/dev/null 2>&1; then
        n install lts
    else
        echo "✓ node already installed"
    fi

    if [ -f "$TARGET_ENV" ]; then
        cp "$TARGET_ENV" "${TARGET_ENV}.bak.$(date +%Y%m%d_%H%M%S)"
        echo "Backed up existing $TARGET_ENV"
    fi
    cp "$ENV_FILE" "$TARGET_ENV"
    echo "Environment file copied to $TARGET_ENV"

    if [ -f "$HOME/.zshrc" ]; then
        add_env_source "$HOME/.zshrc"
    fi
    if [ -f "$HOME/.bashrc" ] || [ -f "$HOME/.bash_profile" ]; then
        add_env_source "$HOME/.bash_profile"
        add_env_source "$HOME/.bashrc"
    fi

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

    cp "$REPO_DIR/bin/wt" "$HOME/bin/wt"
    echo "git worktree bash-util installed"
}

install_golang() {
    if command -v go >/dev/null 2>&1; then
        echo "✓ Golang already installed"
    else
        echo "Installing Golang..."
        brew install go
        mkdir -p "$HOME/go"
        echo "Golang installed"
    fi
}

install_sequel_ace() {
    if brew list --cask | grep -q "sequel-ace"; then
        echo "✓ Sequel Ace already installed"
    else
        echo "Installing Sequel Ace..."
        brew install --cask sequel-ace
        echo "Sequel Ace installed successfully"
    fi
}

install_ghostty() {
    if brew list --cask | grep -q "ghostty"; then
        echo "✓ Ghostty already installed"
    else
        echo "Installing Ghostty..."
        brew install --cask ghostty
        echo "Ghostty installed successfully"
    fi
}

install_keycastr() {
    if brew list --cask | grep -q "keycastr"; then
        echo "✓ Keycastr already installed"
    else
        echo "Installing Keycastr..."
        brew install --cask keycastr
        echo "Keycastr installed successfully"
    fi
}

install_pearcleaner() {
    if brew list --cask | grep -q "pearcleaner"; then
        echo "✓ Pearcleaner already installed"
    else
        echo "Installing Pearcleaner..."
        brew install --cask pearcleaner
        echo "Pearcleaner installed successfully"
    fi
}

install_iina() {
    if brew list --cask | grep -q "iina"; then
        echo "✓ IINA already installed"
    else
        echo "Installing IINA..."
        brew install --cask iina
        echo "IINA installed successfully"
    fi
}

install_licecap() {
    if brew list --cask | grep -q "licecap"; then
        echo "✓ Licecap already installed"
    else
        echo "Installing Licecap..."
        brew install --cask licecap
        echo "Licecap installed successfully"
    fi
}

install_raycast() {
    if brew list --cask | grep -q "raycast"; then
        echo "✓ Raycast already installed"
    else
        echo "Installing Raycast..."
        brew install --cask raycast
        echo "Raycast installed successfully"
    fi
}

install_zed() {
    if brew list --cask | grep -q "zed"; then
        echo "✓ Zed already installed"
    else
        echo "Installing Zed..."
        brew install --cask zed
        echo "Zed installed successfully"
    fi
}

show_main_menu() {
    local choice

    while true; do
        echo ""
        echo "═══════════════════════════════════════"
        echo "       macOS Setup — LTVIM"
        echo "═══════════════════════════════════════"
        echo "  1) Install Essential Tools"
        echo "     (nvim, zoxide, tmux, fd, ripgrep, fonts, n, uv, shell env)"
        echo "  2) Install Golang"
        echo "  3) Install Sequel Ace"
        echo "  4) Install Ghostty"
        echo "  5) Install Keycastr"
        echo "  6) Install Pearcleaner"
        echo "  7) Install IINA"
        echo "  8) Install Licecap"
        echo "  9) Install Raycast"
        echo " 10) Install Zed"
        echo " 11) Full Setup (all)"
        echo " 12) Exit"
        echo "═══════════════════════════════════════"
        read -p "Choose [1-12]: " choice

        case $choice in
            1)
                echo "→ Installing essential tools..."
                install_common_tools
                ;;
            2) echo "→ Installing Golang..."; install_golang ;;
            3) echo "→ Installing Sequel Ace..."; install_sequel_ace ;;
            4) echo "→ Installing Ghostty..."; install_ghostty ;;
            5) echo "→ Installing Keycastr..."; install_keycastr ;;
            6) echo "→ Installing Pearcleaner..."; install_pearcleaner ;;
            7) echo "→ Installing IINA..."; install_iina ;;
            8) echo "→ Installing Licecap..."; install_licecap ;;
            9) echo "→ Installing Raycast..."; install_raycast ;;
            10) echo "→ Installing Zed..."; install_zed ;;
            11)
                echo "→ Full setup..."
                install_common_tools
                install_golang
                install_sequel_ace
                install_ghostty
                install_keycastr
                install_pearcleaner
                install_iina
                install_licecap
                install_raycast
                install_zed
                ;;
            12)
                echo "Exiting."
                exit 0
                ;;
            *)
                echo "Invalid option, please try again."
                ;;
        esac
    done
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

# if no flags given, show interactive menu
if [ "$INSTALL_GOLANG" = false ] && [ "$INSTALL_SEQUEL_ACE" = false ] && [ "$INSTALL_GHOSTTY" = false ] && [ "$INSTALL_KEYCASTR" = false ] && [ "$INSTALL_PEARCLEANER" = false ] && [ "$INSTALL_IINA" = false ] && [ "$INSTALL_LICECAP" = false ] && [ "$INSTALL_RAYCAST" = false ] && [ "$INSTALL_ZED" = false ]; then
    show_main_menu
    exit 0
fi

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

install_common_tools

# ── Optional modules ─────────────────────────────────────────
if [ "$INSTALL_GOLANG" = true ]; then install_golang; fi
if [ "$INSTALL_SEQUEL_ACE" = true ]; then install_sequel_ace; fi
if [ "$INSTALL_GHOSTTY" = true ]; then install_ghostty; fi
if [ "$INSTALL_KEYCASTR" = true ]; then install_keycastr; fi
if [ "$INSTALL_PEARCLEANER" = true ]; then install_pearcleaner; fi
if [ "$INSTALL_IINA" = true ]; then install_iina; fi
if [ "$INSTALL_LICECAP" = true ]; then install_licecap; fi
if [ "$INSTALL_RAYCAST" = true ]; then install_raycast; fi
if [ "$INSTALL_ZED" = true ]; then install_zed; fi

echo ""
echo "Setup complete! Please restart your shell or run: source ~/.ltenv"
