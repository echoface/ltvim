#!/bin/bash

if [ $# -lt 1 ]; then
  echo "usage:./install [base|nvim]"
  exit 1
fi

cd $(cd `dirname $0`; pwd)

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

setup_ghostty() {
  if [ -d "./ghostty" ]; then
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
    echo "ghostty config installed to $HOME/.config/ghostty"
  fi
}

read -r -p "setup your $! config now?[Y|n]" input
case $input in
  [yY][eE][sS]|[yY])
    ;;
  [nN][oO]|[nN])
    echo "nothing change for your vim config"
    echo "exit..."
    exit 1
    ;;
  *)
    echo "invlid input, exit..."
    exit 1
    ;;
esac

if [ "$1" == "base" ]; then
  backupvim
  ln -sf `pwd`/vim $HOME/.vim
  ln -sf `pwd`/vim/vimrc.base $HOME/.vimrc
elif [ "$1" == "nvim" ]; then
  backupnvim
  ln -sf `pwd`/nvim $HOME/.config/nvim
else
  echo "arg:$1 not supported"
  exit -1
fi

# setup tmux
./install_tmux.sh

# setup ghostty
setup_ghostty

echo "finish install and enjoy ltvim now!!!"
echo "please install npm ripgrep to ensure working"
echo "   ripgrep: sudo apt install ripgrep/brew install ripgrep"
echo "   apt install fd-find/brew install fd"
echo "   npm: wget https://raw.githubusercontent.com/tj/n/master/bin/n -O /usr/bin/n"
echo "...............................BYE..."

# fix error cuased by lc
#echo "export LC_CTYPE=en_US.UTF-8" >> ~/.bashrc
#echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc
