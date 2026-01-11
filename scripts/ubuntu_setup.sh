#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$REPO_DIR/env/ubuntu"
TARGET_ENV="$HOME/.env"

# optional modules
INSTALL_GOLANG=false
INSTALL_DOCKER=false

show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --golang    Install Golang"
    echo "  --docker    Install Docker (with China mirror)"
    echo "  --all       Install all optional modules"
    echo "  -h, --help  Show this help message"
}

# parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --golang) INSTALL_GOLANG=true; shift ;;
        --docker) INSTALL_DOCKER=true; shift ;;
        --all) INSTALL_GOLANG=true; INSTALL_DOCKER=true; shift ;;
        -h|--help) show_help; exit 0 ;;
        *) echo "Unknown option: $1"; show_help; exit 1 ;;
    esac
done

# install essentials
sudo apt install -y build-essential git bash-completion unzip cloc ripgrep curl

# linuxbrew
if ! [ -x "$(command -v brew)" ]; then
    export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
    export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
    export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
    export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"

    /bin/bash -c "$(curl -fsSL https://mirrors.ustc.edu.cn/misc/brew-install.sh)"
fi

# ensure brew works
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# brew things
brew install nvim n zoxide tmux fd uv ripgrep font-hack-nerd-font

# refresh font cache
fc-cache -fv

# install node lts
export N_PREFIX="$HOME/.n"
mkdir -p "$N_PREFIX"
n install lts

# copy env file to ~/.env (with backup)
if [ -f "$TARGET_ENV" ]; then
    cp "$TARGET_ENV" "${TARGET_ENV}.bak.$(date +%Y%m%d_%H%M%S)"
    echo "Backed up existing $TARGET_ENV"
fi
cp "$ENV_FILE" "$TARGET_ENV"
echo "Environment file copied to $TARGET_ENV"

# add source to shell rc files
add_env_source() {
    local rc_file="$1"
    local source_line='[ -f "$HOME/.env" ] && source "$HOME/.env"'

    if [ -f "$rc_file" ]; then
        if ! grep -qF '.env' "$rc_file"; then
            echo "" >> "$rc_file"
            echo "# Load custom environment" >> "$rc_file"
            echo "$source_line" >> "$rc_file"
            echo "Added env source to $rc_file"
        else
            echo "Env source already exists in $rc_file"
        fi
    fi
}

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

# optional: Golang
if [ "$INSTALL_GOLANG" = true ]; then
    echo "Installing Golang..."
    brew install go
    mkdir -p "$HOME/go"
    echo "Golang installed"
fi

# optional: Docker (with China mirror)
if [ "$INSTALL_DOCKER" = true ]; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    sudo DOWNLOAD_URL=https://mirrors.ustc.edu.cn/docker-ce sh /tmp/get-docker.sh
    sudo usermod -aG docker "$USER"

    # configure Docker registry mirror
    sudo mkdir -p /etc/docker
    sudo tee /etc/docker/daemon.json > /dev/null <<'EOF'
{
    "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"]
}
EOF
    sudo systemctl restart docker || true
    echo "Docker installed (re-login required for group permissions)"
fi

echo "Setup complete! Please restart your shell or run: source ~/.env"
