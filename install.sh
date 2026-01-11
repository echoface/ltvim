#!/bin/bash

cd "$(cd "$(dirname "$0")"; pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_success() {
  echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
  echo -e "${RED}✗ $1${NC}"
}

print_info() {
  echo -e "${BLUE}ℹ $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠ $1${NC}"
}

# Check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

################################################################################
# Backup functions
################################################################################

backupnvim() {
  dt=`date "+%Y%m%d-%H%M%S"`
  if [ ! -d "$HOME/.config" ]; then
    mkdir -p $HOME/.config
  fi
  if [ -e "$HOME/.config/nvim" ]; then
    mv $HOME/.config/nvim $HOME/.config/nvim.${dt}
    print_info "Backup $HOME/.config/nvim to $HOME/.config/nvim.${dt}"
  fi
}

backupvim() {
  dt=`date "+%Y%m%d-%H%M%S"`
  if [ -e "$HOME/.vim" ]; then
    mv $HOME/.vim $HOME/.vim.bak.${dt}
    print_info "Backup $HOME/.vim to $HOME/.vim.bak.${dt}"
  fi

  if [ -e "$HOME/.vimrc" ]; then
    mv $HOME/.vimrc $HOME/.vimrc.bak.${dt}
    print_info "Backup $HOME/.vimrc to $HOME/.vimrc.bak.${dt}"
  fi
}

################################################################################
# Main menu
################################################################################

echo ""
echo "=========================================="
echo "        Vim Configuration Setup"
echo "=========================================="
echo ""
echo "Choose vim type:"
echo "  [1] vim (base)"
echo "  [2] nvim (neovim)"
echo "  [q] Quit"
echo ""
read -p "Select an option [1-2, q]: " choice

case $choice in
  1)
    echo "Selected: vim (base)"
    read -p "Backup existing vim config? [Y/n]: " backup_confirm
    if [[ "$backup_confirm" =~ ^[Yy]$ ]] || [[ -z "$backup_confirm" ]]; then
      backupvim
    fi

    if [ -e "$HOME/.vim" ]; then
        rm -rf "$HOME/.vim"
    fi
    if [ -e "$HOME/.vimrc" ]; then
        rm -rf "$HOME/.vimrc"
    fi

    if [ -d "./vim" ]; then
      ln -s "$(pwd)/vim" $HOME/.vim
      echo "pos2 debug: `ls -al vim/`"
      ln -s "$(pwd)/vim/vimrc.base" $HOME/.vimrc
      echo "pos3 debug: `ls -al vim/`"
      print_success "vim base config installed successfully"
    else
      print_error "vim directory not found"
      exit 1
    fi
    ;;

  2)
    echo "Selected: nvim (neovim)"

    if ! command_exists nvim; then
      print_error "neovim is not installed. Please install it first:"
      print_info "  - Ubuntu/Debian: sudo apt install neovim"
      print_info "  - macOS: brew install neovim"
      print_info "  - Or use: ./scripts/ubuntu_setup.sh (Linux)"
      print_info "  - Or use: ./scripts/macos_setup.sh (macOS)"
      exit 1
    fi

    read -p "Backup existing nvim config? [Y/n]: " backup_confirm
    if [[ "$backup_confirm" =~ ^[Yy]$ ]] || [[ -z "$backup_confirm" ]]; then
      backupnvim
    fi

    if [ -e "$HOME/.config/nvim" ]; then
        rm -rf "$HOME/.config/nvim"
    fi

    if [ -d "./nvim" ]; then
      ln -sf "$(pwd)/nvim" $HOME/.config/nvim
      print_success "nvim config installed successfully"
    else
      print_error "nvim directory not found"
      exit 1
    fi
    ;;

  q)
    echo ""
    echo "=========================================="
    echo "      Configuration Complete"
    echo "=========================================="
    echo ""
    echo "...............................BYE..."
    exit 0
    ;;

  *)
    echo ""
    print_error "Invalid option. Please select 1-2 or q."
    exit 1
    ;;
esac

echo ""
print_success "Vim/Neovim configuration completed!"
echo ""
echo "Next steps:"
echo "  - Run: nvim (for neovim)"
echo "  - Run: vim (for vim)"
echo ""
