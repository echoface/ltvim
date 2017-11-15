#!/bin/sh

mkdir ~/.vim
cp -rf ./vim_config/vim/* ./vim_config/vim/.* ~/.vim/
cp -rf ./vim_config/vimrc ~/.vimrc

# fix error cuased by lc
echo "export LC_CTYPE=en_US.UTF-8" >> ~/.bashrc
echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc
