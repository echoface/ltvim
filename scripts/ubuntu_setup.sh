#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="${SCRIPT_DIR}/ltenv/env"
TARGET_ENV="$HOME/.ltenv"

# optional modules
INSTALL_GOLANG=false
INSTALL_DOCKER=false
SERVER_MODE=false

show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --server    Server mode (apt-based, no brew/fonts)"
    echo "  --golang    Install Golang"
    echo "  --docker    Install Docker (with China mirror)"
    echo "  --all       Install all optional modules"
    echo "  -h, --help  Show this help message"
}

# ── Helper functions ────────────────────────────────────────
add_env_source() {
    local rc_file="$1"
    local source_line='[ -f "$HOME/.ltenv" ] && source "$HOME/.ltenv"'

    if [ -f "$rc_file" ]; then
        if ! grep -qF '.ltenv' "$rc_file"; then
            echo "" >> "$rc_file"
            echo "# Load custom environment" >> "$rc_file"
            echo "$source_line" >> "$rc_file"
            echo "Added env source to $rc_file"
        else
            echo "Env source already exists in $rc_file"
        fi
    fi
}

install_common_tools() {
    # n (Node.js version manager)
    if ! command -v n >/dev/null 2>&1; then
        curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n -o /tmp/n
        sudo install -m 0755 /tmp/n /usr/local/bin/n
        echo "n installed"
    fi

    # uv
    if ! command -v uv >/dev/null 2>&1; then
        curl -fsSL https://astral.sh/uv/install.sh | sh
    fi

    # Node.js LTS
    export N_PREFIX="$HOME/.n"
    mkdir -p "$N_PREFIX"
    if ! command -v node >/dev/null 2>&1; then
        n install lts
    else
        echo "✓ node already installed"
    fi

    # copy env file
    if [ -f "$TARGET_ENV" ]; then
        cp "$TARGET_ENV" "${TARGET_ENV}.bak.$(date +%Y%m%d_%H%M%S)"
        echo "Backed up existing $TARGET_ENV"
    fi
    cp "$ENV_FILE" "$TARGET_ENV"
    echo "Environment file copied to $TARGET_ENV"

    # shell rc
    add_env_source "$HOME/.bashrc"
    add_env_source "$HOME/.zshrc"

    # tmux config
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

install_docker() {
    if command -v docker >/dev/null 2>&1; then
        echo "✓ Docker already installed"
    else
        echo "Installing Docker..."
        curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
        sudo DOWNLOAD_URL=https://mirrors.ustc.edu.cn/docker-ce sh /tmp/get-docker.sh
        sudo usermod -aG docker "$USER"
        sudo mkdir -p /etc/docker
        sudo tee /etc/docker/daemon.json > /dev/null <<'EOF'
{
    "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"]
}
EOF
        sudo systemctl restart docker || true
        echo "Docker installed (re-login required for group permissions)"
    fi
}

# ── SSH Hardening ─────────────────────────────────────────
harden_ssh() {
    local sshd_config="/etc/ssh/sshd_config"
    local backup="${sshd_config}.bak.$(date +%Y%m%d_%H%M%S)"
    local new_port
    local current_port

    echo ""
    echo "═══════════════════════════════════════"
    echo "        SSH Hardening"
    echo "═══════════════════════════════════════"

    # detect current port
    if [ -f "$sshd_config" ]; then
        current_port=$(sed -n 's/^Port[[:space:]]*\([0-9]*\).*/\1/p' "$sshd_config")
    fi
    : "${current_port:=22}"

    echo "Current SSH port: $current_port"
    echo ""

    # prompt for new port
    read -p "Enter new SSH port [6022]: " new_port
    new_port="${new_port:-6022}"

    # validate port
    if ! [[ "$new_port" =~ ^[0-9]+$ ]] || [ "$new_port" -lt 1 ] || [ "$new_port" -gt 65535 ]; then
        echo "Invalid port. Using default: 6022"
        new_port=6022
    fi

    # backup
    echo "Backing up $sshd_config to $backup"
    sudo cp "$sshd_config" "$backup"

    # update port
    if grep -q '^Port' "$sshd_config"; then
        sudo sed -i "s/^Port.*/Port $new_port/" "$sshd_config"
    else
        echo "Port $new_port" | sudo tee -a "$sshd_config" > /dev/null
    fi

    # disable password auth
    if grep -q '^PasswordAuthentication' "$sshd_config"; then
        sudo sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' "$sshd_config"
    else
        echo "PasswordAuthentication no" | sudo tee -a "$sshd_config" > /dev/null
    fi

    # restart sshd
    sudo systemctl restart sshd || echo "⚠ sshd restart failed — manual intervention required"
    echo "SSHD restarted with new configuration."

    # ufw handling
    if command -v ufw >/dev/null 2>&1 && sudo ufw status | grep -q active; then
        echo "UFW is active — allowing port $new_port..."
        sudo ufw allow "$new_port"/tcp
        if [ "$new_port" != "$current_port" ]; then
            echo "Note: Port $current_port may still be open in UFW."
            echo "Remove it later with: sudo ufw delete allow $current_port/tcp"
        fi
    fi

    echo ""
    echo "═══════════════════════════════════════"
    echo " SSH hardening applied:"
    echo "   Port: $current_port → $new_port"
    echo "   PasswordAuthentication: no"
    echo "═══════════════════════════════════════"
    echo "⚠  Keep your current SSH session open!"
    echo "   Test new connection in another terminal before closing."
    echo ""
    read -p "Press Enter to continue..."
}

show_main_menu() {
    local choice

    while true; do
        echo ""
        echo "═══════════════════════════════════════"
        echo "       Ubuntu Setup — LTVIM"
        echo "═══════════════════════════════════════"
        echo "  1) Install Essential Tools"
        echo "  2) Install Golang"
        echo "  3) Install Docker"
        echo "  4) Harden SSH (port + disable password)"
        echo "  5) Full Setup (all)"
        echo "  6) Exit"
        echo "═══════════════════════════════════════"
        read -p "Choose [1-6]: " choice

        case $choice in
            1)
                echo "→ Installing essential tools..."
                missing_apt=()
                for pkg in build-essential git bash-completion unzip cloc ripgrep curl; do
                    if ! dpkg -s "$pkg" >/dev/null 2>&1; then
                        missing_apt+=("$pkg")
                    fi
                done
                if [ ${#missing_apt[@]} -gt 0 ]; then
                    sudo apt install -y "${missing_apt[@]}"
                else
                    echo "✓ All essential packages already installed"
                fi
                install_common_tools
                ;;
            2)
                echo "→ Installing Golang..."
                INSTALL_GOLANG=true
                install_golang
                ;;
            3)
                echo "→ Installing Docker..."
                INSTALL_DOCKER=true
                install_docker
                ;;
            4)
                harden_ssh
                ;;
            5)
                echo "→ Full setup..."
                INSTALL_GOLANG=true
                INSTALL_DOCKER=true
                missing_apt=()
                for pkg in build-essential git bash-completion unzip cloc ripgrep curl; do
                    if ! dpkg -s "$pkg" >/dev/null 2>&1; then
                        missing_apt+=("$pkg")
                    fi
                done
                if [ ${#missing_apt[@]} -gt 0 ]; then
                    sudo apt install -y "${missing_apt[@]}"
                fi
                install_common_tools
                install_golang
                install_docker
                ;;
            6)
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
        --server) SERVER_MODE=true; shift ;;
        --golang) INSTALL_GOLANG=true; shift ;;
        --docker) INSTALL_DOCKER=true; shift ;;
        --all) INSTALL_GOLANG=true; INSTALL_DOCKER=true; shift ;;
        -h|--help) show_help; exit 0 ;;
        *) echo "Unknown option: $1"; show_help; exit 1 ;;
    esac
done

# if no flags given, show interactive menu
if [ "$INSTALL_GOLANG" = false ] && [ "$INSTALL_DOCKER" = false ] && [ "$SERVER_MODE" = false ]; then
    show_main_menu
    exit 0
fi

# ── APT essentials ──────────────────────────────────────────
missing_apt=()
for pkg in build-essential git bash-completion unzip cloc ripgrep curl; do
    if ! dpkg -s "$pkg" >/dev/null 2>&1; then
        missing_apt+=("$pkg")
    fi
done
if [ ${#missing_apt[@]} -gt 0 ]; then
    sudo apt install -y "${missing_apt[@]}"
else
    echo "✓ All apt packages already installed"
fi

if [ "$SERVER_MODE" = true ]; then
    # ── Server path: apt-based ────────────────────────────
    missing_apt_server=()
    for pkg in neovim tmux zoxide fd-find; do
        if ! dpkg -s "$pkg" >/dev/null 2>&1; then
            missing_apt_server+=("$pkg")
        fi
    done
    if [ ${#missing_apt_server[@]} -gt 0 ]; then
        sudo apt install -y "${missing_apt_server[@]}"
    fi
else
    # ── Desktop path: brew-based ──────────────────────────
    # linuxbrew
    if ! [ -x "$(command -v brew)" ]; then
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
                export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
                export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
                export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"

                /bin/bash -c "$(curl -fsSL https://mirrors.ustc.edu.cn/misc/brew-install.sh)"
                ;;
        esac
    fi

    # ensure brew works
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    # brew things
    for tool in nvim zoxide tmux fd ripgrep; do
        if ! command -v $tool >/dev/null 2>&1; then
            brew install $tool
        else
            echo "✓ $tool already installed"
        fi
    done
    if brew list --cask | grep -q "font-hack-nerd-font"; then
        echo "✓ font-hack-nerd-font already installed"
    else
        brew install font-hack-nerd-font
    fi

    # refresh font cache
    fc-cache -fv
fi

install_common_tools

# ── Optional: Golang ────────────────────────────────────────
if [ "$INSTALL_GOLANG" = true ]; then
    install_golang
fi

# ── Optional: Docker ────────────────────────────────────────
if [ "$INSTALL_DOCKER" = true ]; then
    install_docker
fi

echo "Setup complete! Please restart your shell or run: source ~/.ltenv"
