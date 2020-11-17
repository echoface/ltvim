#!/bin/bash

if [ $# -lt 1 ]; then
  echo "usage:./install [ycm|coc|base]"
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

mkdir -p "$HOME/.ltvim"
cp -rf ./config/vim/*  $HOME/.ltvim/
ln -sf $HOME/.ltvim $HOME/.vim

if [ "$1" == "coc" ]; then
  ln -sf $HOME/.ltvim/vimrc.coc $HOME/.vimrc
elif [ "$1" == "ycm" ]; then
  ln -sf $HOME/.ltvim/vimrc.ycm $HOME/.vimrc
else
  ln -sf $HOME/.ltvim/vimrc.base $HOME/.vimrc
fi

echo "finish install enjoy ltvim life!!!"
echo "............................BYE..."

# fix error cuased by lc
#echo "export LC_CTYPE=en_US.UTF-8" >> ~/.bashrc
#echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc
