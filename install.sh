#!/bin/bash

if [ $# -lt 1 ]; then
  echo "usage:./install [ycm|coc|base|nvim]"
  exit 1
fi

cd $(cd `dirname $0`; pwd)
if [ -d "$HOME/.vim" ]; then
  echo "backup $HOME/.vim to $HOME/.vim.bak"
  mv $HOME/.vim $HOME/.vim.bak
fi

if [ -f "$HOME/.vimrc" ]; then
  echo "backup $HOME/.vimrc to $HOME/.vimrc.bak"
  mv $HOME/.vimrc $HOME/.vimrc.bak
fi

read -r -p "will install ltvim to ${HOME}/.ltvim [Y|n]" input
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

echo "install vim use config $1 to ${HOME}/.ltvim"
if [ -d "$HOME/.ltvim" ]; then
  rm -rf $HOME/.ltvim
fi
mkdir -p "$HOME/.ltvim"
cp -r vim nvim $HOME/.ltvim/

if [ "$1" == "coc" ]; then
  ln -sf $HOME/.ltvim/vim $HOME/.vim
  ln -sf $HOME/.ltvim/vimrc.coc $HOME/.vimrc
elif [ "$1" == "ycm" ]; then
  ln -sf $HOME/.ltvim/vim $HOME/.vim
  ln -sf $HOME/.ltvim/vimrc.ycm $HOME/.vimrc
elif [ "$1" == "base" ]; then
  ln -sf $HOME/.ltvim/vim $HOME/.vim
  ln -sf $HOME/.ltvim/vimrc.base $HOME/.vimrc
elif [ "$1" == "nvim" ]; then
  if [ -d "$HOME/.config/nvim" ]; then
    dt=`date "+%Y%m%d-%H%M%S"`
    mv $HOME/.config/nvim $HOME/.config/nvim.${dt}
    echo "backup $HOME/.config/nvim to $HOME/.config/nvim.${dt}"
  elif [ -f "$HOME/.config/nvim" ]; then
    rm $HOME/.config/nvim
    echo "del file $HOME/.config/nvim"
  fi
  ln -sf $HOME/.ltvim/nvim $HOME/.config/nvim
else
  echo "arg:$1 not supported"
  exit -1
fi

echo "finish install enjoy ltvim life!!!"
echo "............................BYE..."

# fix error cuased by lc
#echo "export LC_CTYPE=en_US.UTF-8" >> ~/.bashrc
#echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc
