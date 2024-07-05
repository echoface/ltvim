#!/bin/bash

cd $(cd `dirname $0`; pwd)

Hint="This will override ${HOME}/.tmux.conf without backup"
read -r -p "${Hint}; continue? [Y|n]" input
case $input in
  [yY][eE][sS]|[yY])
    ;;
  [nN][oO]|[nN])
    echo "nothing change for your tmux config"
    echo "exit..."
    exit 1
    ;;
  *)
    echo "invlid input, exit..."
    exit 1
    ;;
esac

timestamp=$(date +%Y%m%d_%H%M%S)

if [ -f "$HOME/.tmux.conf" ]; then
  echo "backup old tmux config, ohah"
  mv $HOME/.tmux.conf $HOME/tmux.conf.bak.${timestamp}
fi

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "tpm not found, installing ..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

cp tmux/tmux.conf $HOME/.tmux.conf
echo "done!, reload and have a try"
