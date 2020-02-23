#!/bin/sh

CurDir=$(cd `dirname $0`; pwd)
cd ${CurDir}

echo "pwd:"`pwd`

if [ -d "$HOME/.vim" ]; then
  echo "backup $HOME/.vim to $HOME/.vim.bak"
  mv $HOME/.vim $HOME/.vim.bak
fi

if [ -f "$HOME/.vimrc" ]; then
  echo "backup $HOME/.vimrc to $HOME/.vimrc.bak"
  mv $HOME/.vimrc $HOME/.vimrc.bak
fi

echo "install .... ...."
mkdir -p "$HOME/.echo_vim"
cp -rf ${CurDir}/config/vim  $HOME/.echo_vim/
ln -sf $HOME/.echo_vim/vimrc_coc.nvim $HOME/.vimrc
echo "do a symbal link to ~/.vim/vimrc_coc.nvim or ~/.vim/vimrc_languageclient"

# fix error cuased by lc
#echo "export LC_CTYPE=en_US.UTF-8" >> ~/.bashrc
#echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc
