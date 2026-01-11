#!/bin/bash

cd $(cd `dirname $0`; pwd)

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
  if [ -d "$HOME/.config/nvim" ]; then
    mv $HOME/.config/nvim $HOME/.config/nvim.${dt}
    print_info "Backup $HOME/.config/nvim to $HOME/.config/nvim.${dt}"
  elif [ -f "$HOME/.config/nvim" ]; then
    rm $HOME/.config/nvim
  fi
}

backupvim() {
  dt=`date "+%Y%m%d-%H%M%S"`
  if [ -d "$HOME/.vim" ]; then
    mv $HOME/.vim $HOME/.vim.bak.${dt}
    print_info "Backup $HOME/.vim to $HOME/.vim.bak.${dt}"
  elif [ -f "$HOME/.vim" ]; then
    rm $HOME/.vim
  fi

  if [ -f "$HOME/.vimrc" ]; then
    mv $HOME/.vimrc $HOME/.vimrc.bak.${dt}
    print_info "Backup $HOME/.vimrc to $HOME/.vimrc.bak.${dt}"
  fi
}

################################################################################
# Vim configuration setup
################################################################################

setup_vim_config() {
  echo ""
  echo "=========================================="
  echo "  Configure Vim/Neovim"
  echo "=========================================="
  echo ""

  echo "Choose vim type:"
  echo "  1) vim (base)"
  echo "  2) nvim (neovim)"
  read -p "Select [1-2]: " vim_choice

  case $vim_choice in
    1)
      echo "Selected: vim (base)"

      read -p "Backup existing vim config? [Y/n]: " backup_confirm
      if [[ $backup_confirm =~ ^[Yy]|^$ ]]; then
        backupvim
      fi

      if [ -d "./vim" ]; then
        ln -sf `pwd`/vim $HOME/.vim
        ln -sf `pwd`/vim/vimrc.base $HOME/.vimrc
        print_success "vim base config installed successfully"
      else
        print_error "vim directory not found"
        return 1
      fi
      ;;

    2)
      echo "Selected: nvim (neovim)"

      # Check if nvim is installed
      if ! command_exists nvim; then
        print_error "neovim is not installed. Please install it first:"
        print_info "  - Ubuntu/Debian: sudo apt install neovim"
        print_info "  - macOS: brew install neovim"
        print_info "  - Or use: ./scripts/ubuntu_setup.sh"
        return 1
      fi

      read -p "Backup existing nvim config? [Y/n]: " backup_confirm
      if [[ $backup_confirm =~ ^[Yy]|^$ ]]; then
        backupnvim
      else
        rm -rf $HOME/.config/nvim
      fi

      if [ -d "./nvim" ]; then
        ln -sf `pwd`/nvim $HOME/.config/nvim
        print_success "nvim config installed successfully"
      else
        print_error "nvim directory not found"
        return 1
      fi
      ;;

    *)
      print_error "Invalid choice"
      return 1
      ;;
  esac

  echo ""
  print_success "Vim/Neovim configuration completed!"
}

################################################################################
# Main menu
################################################################################

show_menu() {
  echo ""
  echo "=========================================="
  echo "        Vim Configuration Setup"
  echo "=========================================="
  echo ""
  echo "This script will configure vim or neovim."
  echo ""
  echo "  [1] Configure vim/nvim"
  echo "  [q] Quit"
  echo ""
}

main_menu() {
  while true; do
    show_menu
    read -p "Select an option [1, q]: " choice

    case $choice in
      1)
        setup_vim_config
        ;;
      q)
        echo ""
        echo "=========================================="
        echo "      Configuration Complete"
        echo "=========================================="
        echo ""
        echo "Vim setup finished!"
        echo ""
        echo "Next steps:"
        echo "  - Run: nvim (for neovim)"
        echo "  - Run: vim (for vim)"
        echo ""
        echo "...............................BYE..."
        exit 0
        ;;
      *)
        echo ""
        print_error "Invalid option. Please select 1 or q."
        ;;
    esac

    echo ""
    read -p "Press Enter to continue..."
  done
}

# Detect operating system
if [[ "$OSTYPE" == "darwin"* ]]; then
  print_info "Detected macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  print_info "Detected Linux"
  if [ -f "./scripts/ubuntu_setup.sh" ]; then
    print_info "Tip: Use ./scripts/ubuntu_setup.sh for full environment setup"
  fi
else
  print_warning "Unknown operating system: $OSTYPE"
fi

# Start the interactive menu
main_menu
