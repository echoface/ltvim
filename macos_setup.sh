#!/bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

eval "$(/usr/local/bin/brew shellenv)"
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> $HOME/.zprofile

brew install font-hack-nerd-font font-hack iina iterm2 keycastr licecap orbstack pearcleaner raycast	sequel-ace
