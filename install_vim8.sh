#!/bin/bash

read -r -p "install vim8 to your ${HOME}? [Y|n]" input
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

git clone https://gitee.com/ltecho/vim.git .ltvim8 --depth=1
cd .ltvim8
./configure                                                           \
  --prefix=$HOME                                                      \
  --with-features=huge                                                \
  --disable-gui --without-x                                           \
  --enable-fontset --with-compiledby="HuanGong"                       \
  --enable-cscope --enable-fail-if-missing --enable-multibyte         \
  --enable-python3interp --enable-pythoninterp                        \
  --with-python-config-dir=/usr/lib64/python2.7//config               \
  --with-python3-config-dir=/usr/lib64/python3.6/config-3.6m-x86_64-linux-gnu

make -j4
make install
echo "clean source code..."
rm -rf .ltvim8
echo "enjoy lt vim8...."

