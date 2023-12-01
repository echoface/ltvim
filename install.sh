#!/bin/bash

if [ $# -lt 1 ]; then
  echo "usage:./install [ycm|coc|hg|base|nvim]"
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



if [ "$1" == "coc" ]; then
  backupvim
  ln -sf `pwd`/vim $HOME/.vim
  ln -sf `pwd`/vim/vimrc.coc $HOME/.vimrc
elif [ "$1" == "ycm" ]; then
  backupvim
  ln -sf `pwd`/vim $HOME/.vim
  ln -sf `pwd`/vim/vimrc.ycm $HOME/.vimrc
elif [ "$1" == "base" ]; then
  backupvim
  ln -sf `pwd`/vim $HOME/.vim
  ln -sf `pwd`/vim/vimrc.base $HOME/.vimrc
elif [ "$1" == "hg" ]; then
  backupvim
  ln -sf `pwd`/vim $HOME/.vim
  ln -sf `pwd`/vim/vimrc.hg $HOME/.vimrc
elif [ "$1" == "nvim" ]; then
  backupnvim
  ln -sf `pwd`/nvim $HOME/.config/nvim
else
  echo "arg:$1 not supported"
  exit -1
fi

echo "finish install and enjoy ltvim now!!!"
echo "1. please install npm ripgrep to ensure working"
echo "   ripgrep: sudo apt install ripgrep"
echo "   npm: wget https://raw.githubusercontent.com/tj/n/master/bin/n -O /usr/bin/n"
echo "...............................BYE..."

# fix error cuased by lc
#echo "export LC_CTYPE=en_US.UTF-8" >> ~/.bashrc
#echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc
