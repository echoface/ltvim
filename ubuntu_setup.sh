#!/bin/bash

# install enssntials

sudo apt install build-essential git

#linuxbrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# ensure brew work
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# brew things
brew install nvim utf8proc n

# update env
cat <<EOF >>$HOME/.bashrc

# >>> this add by gonghuan.dev's ubuntu sys setup automatics

alias vim=nvim

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

export N_PREFIX=$HOME/.n
export PATH=$N_PREFIX/bin:$PATH

export no_proxy=.byteintl.net,.byted.org,.bytedance.net

#
#<<<<<<<<<<<<<<<<<<<<<<<<<< end <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
EOF


source $HOME/.bashrc

# post install setup
n intsll lts
