#!/bin/bash

set -e

cd $(cd `dirname $0`; pwd)
REPO_DIR="$(dirname "$PWD")"

# Show help message
show_help() {
  echo "LTVIM Editor Configuration Installer"
  echo ""
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  -h, --help     Show this help message"
  echo "  -v, --vim      Install vim configuration"
  echo "  -n, --nvim     Install neovim configuration"
  echo ""
  echo "Interactive Mode:"
  echo "  Run without arguments to choose interactively"
  echo ""
  echo "Note: This script only installs editor configurations."
  echo "      For system setup, run ./scripts/ubuntu_setup.sh first."
}

# Check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check and warn about required dependencies
check_dependencies() {
  local missing_tools=()

  # Check for ripgrep
  if ! command_exists rg; then
    missing_tools+=("ripgrep (rg)")
  fi

  # Check for fd
  if ! command_exists fd; then
    missing_tools+=("fd")
  fi

  # Check for nvim (if installing neovim)
  if [ "$1" = "nvim" ]; then
    if ! command_exists nvim; then
      missing_tools+=("neovim (nvim)")
    fi
  fi

  if [ ${#missing_tools[@]} -gt 0 ]; then
    echo "⚠ Warning: The following tools are not installed:"
    for tool in "${missing_tools[@]}"; do
      echo "  - $tool"
    done
    echo ""
    echo "To install them, you can:"
    echo "  - Run: ./scripts/ubuntu_setup.sh"
    echo "  - Or manually: brew install ${missing_tools[*]}"
    echo ""
    read -p "Continue anyway? [Y/n]: " continue_confirm
    if [[ ! $continue_confirm =~ ^[Yy]|^$ ]]; then
      echo "Installation cancelled."
      exit 1
    fi
  fi
}

# Backup existing nvim config
backupnvim() {
  dt=`date "+%Y%m%d-%H%M%S"`
  if [ ! -d "$HOME/.config" ]; then
    mkdir -p $HOME/.config
  fi
  if [ -d "$HOME/.config/nvim" ]; then
    mv $HOME/.config/nvim $HOME/.config/nvim.${dt}
    echo "✓ Backed up existing $HOME/.config/nvim to $HOME/.config/nvim.${dt}"
  elif [ -f "$HOME/.config/nvim" ]; then
    rm $HOME/.config/nvim
  fi
}

# Backup existing vim config
backupvim() {
  dt=`date "+%Y%m%d-%H%M%S"`
  if [ -d "$HOME/.vim" ]; then
    mv $HOME/.vim $HOME/.vim.bak.${dt}
    echo "✓ Backed up existing $HOME/.vim to $HOME/.vim.bak.${dt}"
  elif [ -f "$HOME/.vim" ]; then
    rm $HOME/.vim
  fi

  if [ -f "$HOME/.vimrc" ]; then
    mv $HOME/.vimrc $HOME/.vimrc.bak.${dt}
    echo "✓ Backed up existing $HOME/.vimrc to $HOME/.vimrc.bak.${dt}"
  fi
}

# Setup vim configuration
install_vim() {
  echo ""
  echo "--- Installing vim (base) configuration ---"

  # Check dependencies
  check_dependencies "vim"

  # Backup existing config
  read -p "Backup existing vim config? [Y/n]: " backup_confirm
  if [[ $backup_confirm =~ ^[Yy]|^$ ]]; then
    backupvim
  fi

  # Install vim config
  ln -sf "$REPO_DIR/vim" "$HOME/.vim"
  ln -sf "$REPO_DIR/vim/vimrc.base" "$HOME/.vimrc"
  echo ""
  echo "✓ vim configuration installed successfully!"
  echo ""
}

# Setup nvim configuration
install_nvim() {
  echo ""
  echo "--- Installing nvim (neovim) configuration ---"

  # Check dependencies
  check_dependencies "nvim"

  # Backup existing config
  read -p "Backup existing nvim config? [Y/n]: " backup_confirm
  if [[ $backup_confirm =~ ^[Yy]|^$ ]]; then
    backupnvim
  else
    [ -e "$HOME/.config/nvim" ] && rm "$HOME/.config/nvim"
  fi

  # Install nvim config
  ln -sf "$REPO_DIR/nvim" "$HOME/.config/nvim"
  echo ""
  echo "✓ neovim configuration installed successfully!"
  echo ""
}

# Interactive mode
interactive_mode() {
  echo ""
  echo "=== LTVIM Editor Configuration Installer ==="
  echo "This script will install vim/nvim configuration from this repository."
  echo ""
  echo "Note: For system setup (dependencies), run './scripts/ubuntu_setup.sh' first."
  echo ""
  echo "Choose editor type:"
  echo "  1) vim (base)"
  echo "  2) nvim (neovim)"
  echo "  q) quit"
  echo ""

  read -p "Select an option [1-2, q]: " choice

  case $choice in
    1)
      install_vim
      ;;
    2)
      install_nvim
      ;;
    q)
      echo "Exiting..."
      exit 0
      ;;
    *)
      echo ""
      echo "✗ Invalid option. Please select 1, 2, or q."
      echo ""
      interactive_mode
      ;;
  esac
}

# Main
# Parse command line arguments
if [[ $# -gt 0 ]]; then
  case "$1" in
    -h|--help)
      show_help
      exit 0
      ;;
    -v|--vim)
      install_vim
      ;;
    -n|--nvim)
      install_nvim
      ;;
    *)
      echo "Error: Unknown option '$1'"
      echo ""
      show_help
      exit 1
      ;;
  esac
else
  interactive_mode
fi

echo "=== Installation Complete ==="
echo ""
echo "✓ Configuration installed successfully!"
echo ""
echo "Required tools (install via system setup script):"
echo "  - ripgrep (rg)"
echo "  - fd"
echo ""
echo "Optional tools:"
echo "  - n (for Node.js version management)"
echo "  - uv (for Python package management)"
echo "  - zoxide (for better directory navigation)"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal"
echo "  2. Or run: source ~/.env"
echo "  3. Enjoy your LTVIM!"
echo ""
