#!/bin/bash

wget https://github.com/git/git/blob/master/contrib/completion/git-completion.bash ~/.git-completion.bash
echo "source ~/.git-completion.bash" >> ~/.bashrc
