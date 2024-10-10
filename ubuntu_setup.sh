#!/bin/bash

set -e

#if ! [ -x "$(command -v orb)" ]; then
if [ -x "$(command -v orb)" ]; then
	read -r -p "seems you are in orbstack env, setup user passwd now?[Y|n]" input
	case $input in
		[yY][eE][sS]|[yY])
			sudo passwd $USER 
			;;
		[nN][oO]|[nN])
			echo "skip set password for user:$USER"
			;;
		*)
			echo "invlid input, exit..."
			exit 1
			;;
	esac
fi

# install enssntials
sudo apt install build-essential git bash-completion unzip

#linuxbrew
if ! [ -x "$(command -v brew)" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # ensure brew work
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    # brew things
    brew update-reset
    brew config
fi

brew install nvim utf8proc n

# update env, use 'EOF' avoiding variable expanding
cat <<'EOF' >>$HOME/.bashrc

# >>> this add by gonghuan.dev's ubuntu sys setup automatics >>>>>>>>>>

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
echo "installing node js latest lts version by n..."
n install lts
