#!/bin/bash

cd $(cd `dirname $0`; pwd)

# Check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Auto-install ripgrep
install_ripgrep() {
  if command_exists rg; then
    echo "✓ ripgrep already installed"
    return 0
  fi

  echo "ripgrep not found. Attempting to install..."
  if command_exists brew; then
    echo "Installing ripgrep via Homebrew..."
    brew install ripgrep
  elif command_exists apt-get; then
    echo "Installing ripgrep via apt-get..."
    sudo apt-get update && sudo apt-get install -y ripgrep
  elif command_exists yum; then
    echo "Installing ripgrep via yum..."
    sudo yum install -y ripgrep
  elif command_exists dnf; then
    echo "Installing ripgrep via dnf..."
    sudo dnf install -y ripgrep
  else
    echo "✗ Could not detect package manager. Please install ripgrep manually."
    echo "  Visit: https://github.com/BurntSushi/ripgrep"
    return 1
  fi

  if command_exists rg; then
    echo "✓ ripgrep installed successfully"
    return 0
  else
    echo "✗ Failed to install ripgrep"
    return 1
  fi
}

# Auto-install fd
install_fd() {
  if command_exists fd; then
    echo "✓ fd already installed"
    return 0
  fi

  echo "fd not found. Attempting to install..."
  if command_exists brew; then
    echo "Installing fd via Homebrew..."
    brew install fd
  elif command_exists apt-get; then
    echo "Installing fd via apt-get..."
    sudo apt-get update && sudo apt-get install -y fd-find
  elif command_exists yum; then
    echo "Installing fd via yum..."
    sudo yum install -y fd
  elif command_exists dnf; then
    echo "Installing fd via dnf..."
    sudo dnf install -y fd
  else
    echo "✗ Could not detect package manager. Please install fd manually."
    echo "  Visit: https://github.com/sharkdp/fd"
    return 1
  fi

  if command_exists fd; then
    echo "✓ fd installed successfully"
    return 0
  else
    echo "✗ Failed to install fd"
    return 1
  fi
}

# Auto-install nvim
install_nvim() {
  if command_exists nvim; then
    echo "✓ neovim already installed"
    return 0
  fi

  echo "neovim not found. Attempting to install..."
  if command_exists brew; then
    echo "Installing neovim via Homebrew..."
    brew install neovim
  elif command_exists apt-get; then
    echo "Installing neovim via apt-get..."
    sudo apt-get update && sudo apt-get install -y neovim
  elif command_exists yum; then
    echo "Installing neovim via yum..."
    sudo yum install -y neovim
  elif command_exists dnf; then
    echo "Installing neovim via dnf..."
    sudo dnf install -y neovim
  else
    echo "✗ Could not detect package manager. Please install neovim manually."
    echo "  Visit: https://github.com/neovim/neovim"
    return 1
  fi

  if command_exists nvim; then
    echo "✓ neovim installed successfully"
    return 0
  else
    echo "✗ Failed to install neovim"
    return 1
  fi
}

# Auto-install tmux
install_tmux() {
  if command_exists tmux; then
    echo "✓ tmux already installed"
    return 0
  fi

  echo "tmux not found. Attempting to install..."
  if command_exists brew; then
    echo "Installing tmux via Homebrew..."
    brew install tmux
  elif command_exists apt-get; then
    echo "Installing tmux via apt-get..."
    sudo apt-get update && sudo apt-get install -y tmux
  elif command_exists yum; then
    echo "Installing tmux via yum..."
    sudo yum install -y tmux
  elif command_exists dnf; then
    echo "Installing tmux via dnf..."
    sudo dnf install -y tmux
  else
    echo "✗ Could not detect package manager. Please install tmux manually."
    echo "  Visit: https://github.com/tmux/tmux"
    return 1
  fi

  if command_exists tmux; then
    echo "✓ tmux installed successfully"
    return 0
  else
    echo "✗ Failed to install tmux"
    return 1
  fi
}

# Auto-install ghostty
install_ghostty() {
  if command_exists ghostty; then
    echo "✓ ghostty already installed"
    return 0
  fi

  echo "ghostty not found. Attempting to install..."
  if command_exists brew; then
    echo "Installing ghostty via Homebrew..."
    brew install ghostty
  elif command_exists apt-get; then
    echo "Installing ghostty via apt-get..."
    # Ghostty might not be in default repos, suggest manual installation
    echo "Note: Ghostty may not be available in apt repositories."
    echo "Please visit: https://ghostty.org/install"
    return 1
  elif command_exists yum; then
    echo "Installing ghostty via yum..."
    echo "Please visit: https://ghostty.org/install"
    return 1
  elif command_exists dnf; then
    echo "Installing ghostty via dnf..."
    echo "Please visit: https://ghostty.org/install"
    return 1
  else
    echo "Please visit: https://ghostty.org/install"
    return 1
  fi

  if command_exists ghostty; then
    echo "✓ ghostty installed successfully"
    return 0
  else
    echo "✗ Failed to install ghostty"
    return 1
  fi
}

backupnvim () {
  dt=`date "+%Y%m%d-%H%M%S"`
  if [ ! -d "$HOME/.config" ]; then
    mkdir -p $HOME/.config
  fi
  if [ -d "$HOME/.config/nvim" ]; then
    mv $HOME/.config/nvim $HOME/.config/nvim.${dt}
    echo "backup $HOME/.config/nvim to $HOME/.config/nvim.${dt}"
  elif [ -f "$HOME/.config/nvim" ]; then
    rm $HOME/.config/nvim
  fi
}

backupvim() {
  dt=`date "+%Y%m%d-%H%M%S"`
  if [ -d "$HOME/.vim" ]; then
    mv $HOME/.vim $HOME/.vim.bak.${dt}
    echo "backup $HOME/.vim to $HOME/.vim.bak.${dt}"
  elif [ -f "$HOME/.vim" ]; then
    rm $HOME/.vim
  fi

  if [ -f "$HOME/.vimrc" ]; then
    mv $HOME/.vimrc $HOME/.vimrc.bak.${dt}
    echo "backup $HOME/.vimrc to $HOME/.vimrc.bak.${dt}"
  fi
}

setup_vim() {
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

      ln -sf `pwd`/vim $HOME/.vim
      ln -sf `pwd`/vim/vimrc.base $HOME/.vimrc
      echo "✓ vim base config installed successfully"

      # Auto-install required tools for vim
      echo ""
      echo "Installing required tools for vim..."
      install_ripgrep
      install_fd
      ;;
    2)
      echo "Selected: nvim (neovim)"

      # Check if nvim is installed, if not offer to install
      if ! command_exists nvim; then
        echo ""
        echo "⚠ neovim is not installed."
        read -p "Install neovim automatically? [Y/n]: " install_nvim_confirm
        if [[ $install_nvim_confirm =~ ^[Yy]|^$ ]]; then
          install_nvim
        else
          echo "✗ neovim is required for this configuration. Skipping..."
          return 1
        fi
      else
        echo "✓ neovim is already installed"
      fi

      read -p "Backup existing nvim config? [Y/n]: " backup_confirm
      if [[ $backup_confirm =~ ^[Yy]|^$ ]]; then
        backupnvim
      else
        rm $HOME/.config/nvim
      fi

      ln -sf `pwd`/nvim $HOME/.config/nvim
      echo "✓ nvim config installed successfully"

      # Auto-install required tools for nvim
      echo ""
      echo "Installing required tools for nvim..."
      install_ripgrep
      install_fd
      ;;
    *)
      echo "✗ Invalid choice"
      return 1
      ;;
  esac
}

setup_tmux() {
  read -p "Setup tmux? [Y/n]: " tmux_confirm
  if [[ $tmux_confirm =~ ^[Yy]|^$ ]]; then
    # Check if tmux is installed, if not offer to install
    if ! command_exists tmux; then
      echo ""
      echo "⚠ tmux is not installed."
      read -p "Install tmux automatically? [Y/n]: " install_tmux_confirm
      if [[ $install_tmux_confirm =~ ^[Yy]|^$ ]]; then
        install_tmux
      else
        echo "✗ tmux is required for this configuration. Skipping..."
        return 1
      fi
    else
      echo "✓ tmux is already installed"
    fi

    if [ -f "./install_tmux.sh" ]; then
      ./install_tmux.sh
      echo "✓ tmux config installed successfully"
    else
      echo "✗ install_tmux.sh not found"
    fi
  else
    echo "✗ skipped tmux installation"
  fi
}

setup_ghostty() {
  if [ -d "./ghostty" ]; then
    read -p "Setup ghostty? [Y/n]: " ghostty_confirm
    if [[ $ghostty_confirm =~ ^[Yy]|^$ ]]; then
      # Check if ghostty is installed, if not offer to install
      if ! command_exists ghostty; then
        echo ""
        echo "⚠ ghostty is not installed."
        read -p "Install ghostty automatically? [Y/n]: " install_ghostty_confirm
        if [[ $install_ghostty_confirm =~ ^[Yy]|^$ ]]; then
          install_ghostty
        else
          echo "✗ ghostty is required for this configuration. Skipping..."
          return 1
        fi
      else
        echo "✓ ghostty is already installed"
      fi

      dt=`date "+%Y%m%d-%H%M%S"`
      # Create ghostty config directory if it doesn't exist
      if [ ! -d "$HOME/.config/ghostty" ]; then
        mkdir -p $HOME/.config/ghostty
        echo "created directory $HOME/.config/ghostty"
      fi

      # Backup existing ghostty config if it exists
      if [ -d "$HOME/.config/ghostty" ]; then
        if [ "$(ls -A $HOME/.config/ghostty 2>/dev/null)" ]; then
          mv $HOME/.config/ghostty $HOME/.config/ghostty.${dt}
          mkdir -p $HOME/.config/ghostty
          echo "backup $HOME/.config/ghostty to $HOME/.config/ghostty.${dt}"
        fi
      fi

      # Copy ghostty config files
      cp -r ./ghostty/* $HOME/.config/ghostty/
      echo "✓ ghostty config installed to $HOME/.config/ghostty"
    else
      echo "✗ skipped ghostty installation"
    fi
  else
    echo "ghostty config directory not found, skipping..."
  fi
}

show_menu() {
  echo ""
  echo "=== LTVIM Setup Menu ==="
  echo "What would you like to configure?"
  echo "  1) vim/nvim"
  echo "  2) tmux"
  echo "  3) ghostty"
  echo "  4) quit"
  echo ""
}

main_menu() {
  while true; do
    show_menu
    read -p "Select an option [1-4]: " choice

    case $choice in
      1)
        echo ""
        echo "--- Configuring vim/nvim ---"
        setup_vim
        ;;
      2)
        echo ""
        echo "--- Configuring tmux ---"
        setup_tmux
        ;;
      3)
        echo ""
        echo "--- Configuring ghostty ---"
        setup_ghostty
        ;;
      4)
        echo ""
        echo "=== Installation Complete ==="
        echo "Enjoy ltvim now!!!"
        echo ""
        echo "Required tools (auto-installed if missing):"
        echo "  ✓ ripgrep (rg)"
        echo "  ✓ fd"
        echo "  ✓ nvim"
        echo "  ✓ tmux"
        echo "  ✓ ghostty"
        echo ""
        echo "Optional:"
        echo "  - npm: wget https://raw.githubusercontent.com/tj/n/master/bin/n -O /usr/bin/n"
        echo ""
        echo "...............................BYE..."
        exit 0
        ;;
      *)
        echo ""
        echo "✗ Invalid option. Please select 1-4."
        ;;
    esac
  done
}

# Start the interactive menu
main_menu
