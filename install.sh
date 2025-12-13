#!/bin/bash

cd $(cd `dirname $0`; pwd)

# Check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Install Homebrew if not exists
install_brew() {
  if command_exists brew; then
    echo "✓ Homebrew already installed"
    return 0
  fi

  echo "Homebrew not found. Installing Homebrew..."
  echo "This may take a few minutes..."

  # Install Homebrew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH if not already there
  if [[ -d "/opt/homebrew" ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi

  if command_exists brew; then
    echo "✓ Homebrew installed successfully"

    # Set up Homebrew bottle mirror for faster downloads in China
    echo "Setting up Homebrew mirror for faster downloads..."
    echo "export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles" >> ~/.zprofile
    export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles

    return 0
  else
    echo "✗ Failed to install Homebrew"
    echo "Please install Homebrew manually: https://brew.sh"
    return 1
  fi
}

# Auto-install ripgrep
install_ripgrep() {
  if command_exists rg; then
    echo "✓ ripgrep already installed"
    return 0
  fi

  echo "ripgrep not found. Installing via Homebrew..."
  brew install ripgrep

  if command_exists rg; then
    echo "✓ ripgrep installed successfully"
    return 0
  else
    echo "✗ Failed to install ripgrep"
    echo "  Visit: https://github.com/BurntSushi/ripgrep"
    return 1
  fi
}

# Auto-install fd
install_fd() {
  if command_exists fd; then
    echo "✓ fd already installed"
    return 0
  fi

  echo "fd not found. Installing via Homebrew..."
  brew install fd

  if command_exists fd; then
    echo "✓ fd installed successfully"
    return 0
  else
    echo "✗ Failed to install fd"
    echo "  Visit: https://github.com/sharkdp/fd"
    return 1
  fi
}

# Auto-install nvim
install_nvim() {
  if command_exists nvim; then
    echo "✓ neovim already installed"
    return 0
  fi

  echo "neovim not found. Installing via Homebrew..."
  brew install neovim

  if command_exists nvim; then
    echo "✓ neovim installed successfully"
    return 0
  else
    echo "✗ Failed to install neovim"
    echo "  Visit: https://github.com/neovim/neovim"
    return 1
  fi
}

# Auto-install tmux
install_tmux() {
  if command_exists tmux; then
    echo "✓ tmux already installed"
    return 0
  fi

  echo "tmux not found. Installing via Homebrew..."
  brew install tmux

  if command_exists tmux; then
    echo "✓ tmux installed successfully"
    return 0
  else
    echo "✗ Failed to install tmux"
    echo "  Visit: https://github.com/tmux/tmux"
    return 1
  fi
}

# Auto-install ghostty
install_ghostty() {
  if command_exists ghostty; then
    echo "✓ ghostty already installed"
    return 0
  fi

  echo "ghostty not found. Installing via Homebrew..."
  brew install ghostty

  if command_exists ghostty; then
    echo "✓ ghostty installed successfully"
    return 0
  else
    echo "✗ Failed to install ghostty"
    echo "  Visit: https://ghostty.org/install"
    return 1
  fi
}

# Auto-install zoxide
install_zoxide() {
  if command_exists zoxide; then
    echo "✓ zoxide already installed"
    return 0
  fi

  echo "zoxide not found. Installing via Homebrew..."
  brew install zoxide

  if command_exists zoxide; then
    echo "✓ zoxide installed successfully"
    return 0
  else
    echo "✗ Failed to install zoxide"
    echo "  Visit: https://github.com/ajeetdsouza/zoxide"
    return 1
  fi
}

# Auto-install n (node version manager)
install_n() {
  if command_exists n; then
    echo "✓ n (node version manager) already installed"
    return 0
  fi

  echo "n not found. Installing via Homebrew..."
  brew install n

  if command_exists n; then
    echo "✓ n installed successfully"
    echo "  Note: You may need to set up N_PREFIX and add it to your PATH"
    echo "  Example: export N_PREFIX=$HOME/n"
    echo "          export PATH=$N_PREFIX/bin:$PATH"
    return 0
  else
    echo "✗ Failed to install n"
    echo "  Visit: https://github.com/tj/n"
    return 1
  fi
}

# Auto-install uv (Python package installer)
install_uv() {
  if command_exists uv; then
    echo "✓ uv already installed"
    return 0
  fi

  echo "uv not found. Installing via Homebrew..."
  brew install uv

  if command_exists uv; then
    echo "✓ uv installed successfully"
    return 0
  else
    echo "✗ Failed to install uv"
    echo "  Visit: https://github.com/astral-sh/uv"
    return 1
  fi
}

# Auto-install font-hack-nerd-font
install_font_hack_nerd_font() {
  if brew list font-hack-nerd-font >/dev/null 2>&1; then
    echo "✓ font-hack-nerd-font already installed"
    return 0
  fi

  echo "font-hack-nerd-font not found. Installing via Homebrew..."
  brew install --cask font-hack-nerd-font

  if brew list font-hack-nerd-font >/dev/null 2>&1; then
    echo "✓ font-hack-nerd-font installed successfully"
    echo "  Note: You may need to restart your terminal or system to use the font"
    return 0
  else
    echo "✗ Failed to install font-hack-nerd-font"
    echo "  You can install it manually from: https://github.com/ryanoasis/nerd-fonts"
    return 1
  fi
}

# Install all dependencies at once
install_all_dependencies() {
  echo "Installing all required dependencies via Homebrew..."
  echo ""

  # First ensure brew is installed
  install_brew

  # Install all dependencies
  install_n
  install_uv
  install_fd
  install_nvim
  install_tmux
  install_zoxide
  install_ripgrep
  install_font_hack_nerd_font

  echo ""
  echo "✓ All dependencies installation attempt completed"
  echo ""
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
      install_zoxide
      install_n
      install_uv
      install_font_hack_nerd_font
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
      install_zoxide
      install_n
      install_uv
      install_font_hack_nerd_font
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
  echo "  1) tmux"
  echo "  2) ghostty"
  echo "  3) vim/nvim"
  echo "  4) Install all dependencies (brew, ripgrep, fd, nvim, tmux, ghostty, zoxide, n, uv, font)"
  echo "  q) quit"
  echo ""
}

main_menu() {
  # First ensure brew is available
  install_brew

  while true; do
    show_menu
    read -p "Select an option [1-5]: " choice

    case $choice in
      1)
        echo ""
        echo "--- Configuring tmux ---"
        setup_tmux
        ;;
      2)
        echo ""
        echo "--- Configuring vim/nvim ---"
        setup_vim
        ;;
      3)
        echo ""
        echo "--- Configuring ghostty ---"
        setup_ghostty
        ;;
      4)
        echo ""
        echo "--- Installing all dependencies ---"
        install_all_dependencies
        ;;
      q)
        echo ""
        echo "=== Installation Complete ==="
        echo "Enjoy ltvim now!!!"
        echo ""
        echo "Required tools (auto-installed if missing):"
        echo "  ✓ fd"
        echo "  ✓ nvim"
        echo "  ✓ tmux"
        echo "  ✓ zoxide"
        echo "  ✓ ghostty"
        echo "  ✓ ripgrep (rg)"
        echo "  ✓ n (node version manager)"
        echo "  ✓ uv (Python package installer)"
        echo "  ✓ font-hack-nerd-font"
        echo ""
        echo "Optional:"
        echo "  - npm: Use 'n' to install Node.js versions"
        echo ""
        echo "...............................BYE..."
        exit 0
        ;;
      *)
        echo ""
        echo "✗ Invalid option. Please select 1-5."
        ;;
    esac
  done
}

# Start the interactive menu
main_menu
