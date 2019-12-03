#!/bin/sh

CurDir=$(cd `dirname $0`; pwd)
cd ${CurDir}

echo `pwd`

if [ -d "~/.vim" ]; then
  echo "backup ~/.vim folder..."
  mv ~/.vim ~/.vim.bak
fi

if [ -f "~/.vimrc" ]; then
  echo "backup ~/.vimrc file..."
  mv ~/.vimrc ~/.vimrc.bak
fi

echo "install .... ...."
cp -rf ./config/vim  ~/.vim
echo "do a symbal link to ~/.vim/vimrc_coc.nvim or ~/.vim/vimrc_languageclient"

# fix error cuased by lc
#echo "export LC_CTYPE=en_US.UTF-8" >> ~/.bashrc
#echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc
